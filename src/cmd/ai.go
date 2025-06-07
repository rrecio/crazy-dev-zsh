package cmd

import (
	"github.com/spf13/cobra"
)

// aiCmd represents the ai command
var aiCmd = &cobra.Command{
	Use:   "ai",
	Short: "Interact with the AI engine",
	Long: `The ai command allows you to interact with the Crazy Dev AI engine.
It provides context-aware suggestions, code generation, and project analysis.

The AI engine can use local models via Ollama or cloud-based models.`,
	Run: runAICommand,
}

// chatCmd represents the ai chat subcommand
var chatCmd = &cobra.Command{
	Use:   "chat",
	Short: "Start an AI chat session",
	Long:  `Start an interactive chat session with the AI assistant.`,
	Run:   runChatCommand,
}

// suggestCmd represents the ai suggest subcommand
var suggestCmd = &cobra.Command{
	Use:   "suggest",
	Short: "Get AI suggestions for your project",
	Long:  `Get context-aware suggestions for your current project.`,
	Run:   runSuggestCommand,
}

// modelsCmd represents the ai models subcommand
var modelsCmd = &cobra.Command{
	Use:   "models",
	Short: "List available AI models",
	Long:  `List all available AI models from local and cloud providers.`,
	Run:   runModelsCommand,
}

// installCmd represents the ai install subcommand
var installCmd = &cobra.Command{
	Use:   "install [model]",
	Short: "Install an AI model",
	Long:  `Install an AI model for local use with Ollama.`,
	Run:   runInstallCommand,
}

func init() {
	rootCmd.AddCommand(aiCmd)
	
	// Add subcommands
	aiCmd.AddCommand(chatCmd)
	aiCmd.AddCommand(suggestCmd)
	aiCmd.AddCommand(modelsCmd)
	aiCmd.AddCommand(installCmd)
	
	// Flags for the ai command
	aiCmd.PersistentFlags().StringP("model", "m", "llama3.2", "AI model to use")
	aiCmd.PersistentFlags().BoolP("local", "l", true, "Use local AI model")
	
	// Flags for the chat subcommand
	chatCmd.Flags().BoolP("context", "c", true, "Include project context in chat")
	chatCmd.Flags().Float64P("temperature", "t", 0.7, "Temperature for response generation (0.0-1.0)")
	
	// Flags for the suggest subcommand
	suggestCmd.Flags().StringP("type", "t", "code", "Type of suggestion (code, refactor, test)")
	
	// Flags for the models subcommand
	modelsCmd.Flags().StringP("provider", "p", "", "Filter models by provider (ollama, openai, anthropic)")
}
