package cmd

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	
	"github.com/rrecio/crazy-dev-zsh/src/ai"
	"github.com/rrecio/crazy-dev-zsh/src/ai/factory"
	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
	ctxanalyzer "github.com/rrecio/crazy-dev-zsh/src/core/context"
)

var (
	aiEngine ai.AIEngine
	typesEngine types.AIEngine
)

// initAIEngine initializes the AI engine
func initAIEngine() error {
	// Get configuration from viper
	config := ai.AIConfig{
		LocalEnabled:      viper.GetBool("ai.local.enabled"),
		LocalEndpoint:     viper.GetString("ai.local.endpoint"),
		DefaultModels:     viper.GetStringSlice("ai.local.models"),
		FallbackToCloud:   viper.GetBool("ai.local.fallback_to_cloud"),
		CloudProvider:     viper.GetString("ai.cloud.provider"),
		RateLimit:         viper.GetInt("ai.cloud.rate_limit"),
		CacheTTL:          viper.GetDuration("ai.cloud.cache_ttl"),
		AIResponseTimeout: viper.GetDuration("core.ai_response_timeout"),
		CloudAITimeout:    viper.GetDuration("core.cloud_ai_timeout"),
	}

	// Convert config and create AI engine using the factory
	typesConfig := factory.ConvertAIConfigToTypes(config)
	engine, err := factory.NewAIEngine(typesConfig)
	if err != nil {
		return fmt.Errorf("failed to initialize AI engine: %w", err)
	}

	// Store the types engine
	typesEngine = engine
	
	// Create a compatibility adapter for the ai.AIEngine interface
	aiEngine = newAIEngineAdapter(typesEngine)
	return nil
}

// runAICommand executes the main AI command
func runAICommand(cmd *cobra.Command, args []string) {
	// Initialize AI engine if not already initialized
	if aiEngine == nil {
		if err := initAIEngine(); err != nil {
			fmt.Printf("Error initializing AI engine: %v\n", err)
			return
		}
	}

	// List available models
	fmt.Println("Available AI models:")
	
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	
	models, err := aiEngine.ListModels(ctx, "")
	if err != nil {
		fmt.Printf("Error listing models: %v\n", err)
		return
	}
	
	// Group models by provider
	modelsByProvider := make(map[string][]ai.ModelInfo)
	for _, model := range models {
		provider := string(model.Provider)
		modelsByProvider[provider] = append(modelsByProvider[provider], model)
	}
	
	// Print models by provider
	for provider, models := range modelsByProvider {
		fmt.Printf("\n%s:\n", strings.ToUpper(provider))
		for _, model := range models {
			status := "Available"
			if model.Installed {
				status = "Installed"
			}
			if model.Default {
				status += " (Default)"
			}
			fmt.Printf("  - %s: %s [%s]\n", model.Name, model.Description, status)
		}
	}
	
	fmt.Println("\nUse 'crazy ai chat' to start a chat session")
	fmt.Println("Use 'crazy ai suggest' to get suggestions")
}

// runChatCommand executes the AI chat subcommand
func runChatCommand(cmd *cobra.Command, args []string) {
	// Initialize AI engine if not already initialized
	if aiEngine == nil {
		if err := initAIEngine(); err != nil {
			fmt.Printf("Error initializing AI engine: %v\n", err)
			return
		}
	}
	
	// Get flags
	model, _ := cmd.Flags().GetString("model")
	includeContext, _ := cmd.Flags().GetBool("context")
	temperature, _ := cmd.Flags().GetFloat64("temperature")
	
	// Welcome message
	fmt.Println("Starting AI chat session. Type 'exit' or 'quit' to end the session.")
	fmt.Printf("Using model: %s\n", model)
	
	// Initialize context data if needed
	var contextData []byte
	if includeContext {
		fmt.Println("Analyzing project context...")
		contextData = getProjectContext()
	}
	
	// Initialize chat history
	messages := []ai.Message{
		{
			Role:    "system",
			Content: "You are a helpful AI assistant for software development. Provide concise and accurate responses.",
		},
	}
	
	// Chat loop
	scanner := bufio.NewScanner(os.Stdin)
	userColor := color.New(color.FgCyan).SprintFunc()
	aiColor := color.New(color.FgGreen).SprintFunc()
	
	for {
		// Get user input
		fmt.Print(userColor("You: "))
		if !scanner.Scan() {
			break
		}
		
		userInput := scanner.Text()
		if userInput == "exit" || userInput == "quit" {
			break
		}
		
		// Add user message to history
		messages = append(messages, ai.Message{
			Role:    "user",
			Content: userInput,
		})
		
		// Create AI request
		req := ai.AIRequest{
			Model:       model,
			ModelType:   ai.ModelTypeChat,
			Messages:    messages,
			Temperature: temperature,
			Context:     contextData,
		}
		
		// Stream the response
		fmt.Print(aiColor("AI: "))
		
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		var responseText strings.Builder
		
		_, err := aiEngine.StreamChat(ctx, req, func(chunk string) error {
			fmt.Print(chunk)
			responseText.WriteString(chunk)
			return nil
		})
		
		cancel()
		fmt.Println()
		
		if err != nil {
			fmt.Printf("Error: %v\n", err)
			continue
		}
		
		// Add assistant message to history
		messages = append(messages, ai.Message{
			Role:    "assistant",
			Content: responseText.String(),
		})
	}
}

// runSuggestCommand executes the AI suggest subcommand
func runSuggestCommand(cmd *cobra.Command, args []string) {
	// Initialize AI engine if not already initialized
	if aiEngine == nil {
		if err := initAIEngine(); err != nil {
			fmt.Printf("Error initializing AI engine: %v\n", err)
			return
		}
	}
	
	// Get flags
	model, _ := cmd.Flags().GetString("model")
	suggestionType, _ := cmd.Flags().GetString("type")
	
	// Get project context
	fmt.Println("Analyzing project context...")
	contextData := getProjectContext()
	
	// Create prompt based on suggestion type
	var prompt string
	switch suggestionType {
	case "code":
		prompt = "Based on the project context, suggest improvements or additions to the codebase. Focus on code quality, performance, and best practices."
	case "refactor":
		prompt = "Based on the project context, suggest refactoring opportunities. Identify code smells, technical debt, and areas that could be improved."
	case "test":
		prompt = "Based on the project context, suggest testing strategies. Identify areas that need more test coverage and recommend testing approaches."
	default:
		prompt = "Based on the project context, provide helpful suggestions for improving the project."
	}
	
	// Create AI request
	req := ai.AIRequest{
		Model:       model,
		ModelType:   ai.ModelTypeChat,
		Messages: []ai.Message{
			{
				Role:    "system",
				Content: "You are a helpful AI assistant for software development. Provide concise and actionable suggestions.",
			},
			{
				Role:    "user",
				Content: prompt,
			},
		},
		Temperature: 0.7,
		Context:     contextData,
	}
	
	// Get the response
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	
	fmt.Printf("Generating %s suggestions using %s...\n", suggestionType, model)
	
	response, err := aiEngine.Chat(ctx, req)
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		return
	}
	
	// Print the response
	fmt.Println("\n--- AI Suggestions ---")
	fmt.Println(response.Text)
	fmt.Println("---------------------")
}

// getProjectContext gets the project context data
func getProjectContext() []byte {
	// Get current directory
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Printf("Warning: Could not get current directory: %v\n", err)
		return nil
	}
	
	// Create analyzer
	analyzer := ctxanalyzer.NewContextAnalyzer(500, 10*1024*1024) // Max 500 files, 10MB max file size
	
	// Run analysis
	result, err := analyzer.Analyze(currentDir)
	if err != nil {
		fmt.Printf("Warning: Could not analyze project context: %v\n", err)
		return nil
	}
	
	// Convert to JSON
	contextData, err := json.Marshal(result)
	if err != nil {
		fmt.Printf("Warning: Could not marshal context data: %v\n", err)
		return nil
	}
	
	return contextData
}

// runModelsCommand executes the AI models subcommand
func runModelsCommand(cmd *cobra.Command, args []string) {
	// Initialize AI engine if not already initialized
	if aiEngine == nil {
		if err := initAIEngine(); err != nil {
			fmt.Printf("Error initializing AI engine: %v\n", err)
			return
		}
	}
	
	// Get flags
	provider, _ := cmd.Flags().GetString("provider")
	
	// List available models
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	
	models, err := aiEngine.ListModels(ctx, provider)
	if err != nil {
		fmt.Printf("Error listing models: %v\n", err)
		return
	}
	
	// Group models by provider
	modelsByProvider := make(map[string][]ai.ModelInfo)
	for _, model := range models {
		provider := string(model.Provider)
		modelsByProvider[provider] = append(modelsByProvider[provider], model)
	}
	
	// Print models by provider
	for provider, models := range modelsByProvider {
		fmt.Printf("\n%s:\n", strings.ToUpper(provider))
		for _, model := range models {
			status := "Available"
			if model.Installed {
				status = "Installed"
			}
			if model.Default {
				status += " (Default)"
			}
			fmt.Printf("  - %s: %s [%s]\n", model.Name, model.Description, status)
		}
	}
}

// runInstallCommand executes the AI install subcommand
func runInstallCommand(cmd *cobra.Command, args []string) {
	// Initialize AI engine if not already initialized
	if aiEngine == nil {
		if err := initAIEngine(); err != nil {
			fmt.Printf("Error initializing AI engine: %v\n", err)
			return
		}
	}
	
	// Check if model name is provided
	if len(args) == 0 {
		fmt.Println("Error: Model name is required")
		fmt.Println("Usage: crazy ai install <model-name>")
		return
	}
	
	modelName := args[0]
	
	// Install the model
	fmt.Printf("Installing model %s...\n", modelName)
	
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancel()
	
	err := aiEngine.InstallModel(ctx, modelName)
	if err != nil {
		fmt.Printf("Error installing model: %v\n", err)
		return
	}
	
	fmt.Printf("Model %s installed successfully\n", modelName)
}
