// Package factory provides factory functions for creating AI engine components.
package factory

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// ollamaClientAdapter adapts the internal Ollama client to the types.OllamaClient interface
type ollamaClientAdapter struct {
	endpoint string
}

// NewOllamaClient creates a new Ollama client adapter that implements types.OllamaClient
func NewOllamaClient(endpoint string) (types.OllamaClient, error) {
	if endpoint == "" {
		endpoint = "http://localhost:11434" // Default Ollama endpoint
	}
	return &ollamaClientAdapter{endpoint: endpoint}, nil
}

// Complete generates a completion for the given prompt
func (c *ollamaClientAdapter) Complete(ctx context.Context, model string, prompt string, opts types.CompletionOptions) (*types.AIResponse, error) {
	start := time.Now()
	
	// Mock response for completion
	mockResponse := "This is a mock completion response from Ollama."
	
	response := &types.AIResponse{
		Text:             mockResponse,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: string(types.ProviderOllama),
		Model:            model,
		Provider:         string(types.ProviderOllama),
		Usage: types.AIUsage{
			PromptTokens:     50, // Mocked token count
			CompletionTokens: 10,
			TotalTokens:      60,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// Chat generates a response for the given chat messages
func (c *ollamaClientAdapter) Chat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions) (*types.AIResponse, error) {
	start := time.Now()
	
	// Construct response message from the last user message
	var lastUserMessage string
	for i := len(messages) - 1; i >= 0; i-- {
		if messages[i].Role == "user" {
			lastUserMessage = messages[i].Content
			break
		}
	}
	
	responseMessage := types.Message{
		Role:    "assistant",
		Content: "This is a mock chat response from Ollama for: " + lastUserMessage,
	}
	
	// Mock implementation - in real code this would call the actual Ollama client
	response := &types.AIResponse{
		Text:             responseMessage.Content,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: string(types.ProviderOllama),
		Model:            model,
		Provider:         string(types.ProviderOllama),
		Messages:         append(messages, responseMessage),
		Usage: types.AIUsage{
			PromptTokens:     100, // Mocked token count
			CompletionTokens: 20,
			TotalTokens:      120,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// StreamChat streams a chat response token by token
func (c *ollamaClientAdapter) StreamChat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions, callback func(chunk string) error) (*types.AIResponse, error) {
	start := time.Now()
	
	// Simulate streaming by breaking response into chunks
	mockResponse := "This is a mock streaming response from Ollama. The response is chunked into multiple callbacks."
	chunks := []string{"This is ", "a mock ", "streaming ", "response ", "from Ollama. ", "The response ", "is chunked ", "into multiple ", "callbacks."}
	
	// Call callback with each chunk
	for _, chunk := range chunks {
		select {
		case <-ctx.Done():
			return nil, fmt.Errorf("context canceled during streaming: %w", ctx.Err())
		default:
			if err := callback(chunk); err != nil {
				return nil, fmt.Errorf("streaming callback failed: %w", err)
			}
			time.Sleep(50 * time.Millisecond) // Simulate processing time between chunks
		}
	}
	
	// Construct final response after streaming
	responseMessage := types.Message{
		Role:    "assistant",
		Content: mockResponse,
	}
	
	response := &types.AIResponse{
		Text:             mockResponse,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: string(types.ProviderOllama),
		Model:            model,
		Provider:         string(types.ProviderOllama),
		Messages:         append(messages, responseMessage),
		Usage: types.AIUsage{
			PromptTokens:     100, // Mocked token count
			CompletionTokens: 20,
			TotalTokens:      120,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// GetEmbedding generates embeddings for the given text
func (c *ollamaClientAdapter) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// Mock implementation - in real code this would call the actual Ollama client
	// Return a mock embedding with 10 dimensions
	mockEmbedding := make([]float32, 10)
	for i := range mockEmbedding {
		mockEmbedding[i] = float32(i) * 0.1
	}
	return mockEmbedding, nil
}

// ListModels lists available models
func (c *ollamaClientAdapter) ListModels(ctx context.Context) ([]types.ModelInfo, error) {
	// Mock implementation - in real code this would call the actual Ollama client
	models := []types.ModelInfo{
		{
			Name:        "llama2",
			Provider:    types.ProviderOllama,
			Type:        types.ModelTypeChat,
			Description: "Llama 2 7B by Meta",
			SizeBytes:   4000000000,
			Installed:   true,
			Default:     true,
		},
		{
			Name:        "codellama",
			Provider:    types.ProviderOllama,
			Type:        types.ModelTypeChat,
			Description: "Code Llama 7B by Meta",
			SizeBytes:   4100000000,
			Installed:   true,
			Default:     false,
		},
	}
	return models, nil
}

// GetModelInfo gets detailed information about a model
func (c *ollamaClientAdapter) GetModelInfo(ctx context.Context, model string) (*types.ModelInfo, error) {
	// Mock implementation - in real code this would call the actual Ollama client
	models := map[string]*types.ModelInfo{
		"llama2": {
			Name:        "llama2",
			Provider:    types.ProviderOllama,
			Type:        types.ModelTypeChat,
			Description: "Llama 2 7B by Meta",
			SizeBytes:   4000000000,
			Installed:   true,
			Default:     true,
		},
		"codellama": {
			Name:        "codellama",
			Provider:    types.ProviderOllama,
			Type:        types.ModelTypeChat,
			Description: "Code Llama 7B by Meta",
			SizeBytes:   4100000000,
			Installed:   true,
			Default:     false,
		},
	}
	
	if info, ok := models[model]; ok {
		return info, nil
	}
	return nil, fmt.Errorf("model %s not found", model)
}

// CheckModelAvailability checks if a model is available
func (c *ollamaClientAdapter) CheckModelAvailability(ctx context.Context, model string) (bool, error) {
	// Mock implementation - in real code this would call the actual Ollama client
	// Consider mock models "llama2" and "codellama" as available
	availableModels := map[string]bool{
		"llama2":    true,
		"codellama": true,
		"phi3":      true,
	}
	return availableModels[model], nil
}

// InstallModel installs a model
func (o *ollamaClientAdapter) InstallModel(ctx context.Context, model string) error {
	// Mock implementation - in real code this would call the actual Ollama API
	time.Sleep(100 * time.Millisecond) // Simulate API call latency
	return nil
}

// cloudClientAdapter adapts cloud AI providers to the types.CloudClient interface
type cloudClientAdapter struct {
	provider string
}

// NewCloudClient creates a new cloud client adapter that implements types.CloudClient
func NewCloudClient(provider string) (types.CloudClient, error) {
	if provider == "" {
		return nil, fmt.Errorf("provider cannot be empty")
	}
	return &cloudClientAdapter{provider: provider}, nil
}

// Complete generates a completion for the given prompt
func (c *cloudClientAdapter) Complete(ctx context.Context, model string, prompt string, opts types.CompletionOptions) (*types.AIResponse, error) {
	start := time.Now()
	
	// Mock implementation - in real code this would call the actual cloud API
	response := &types.AIResponse{
		Text:             "This is a mock response from " + c.provider + " Complete API for: " + prompt,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: c.provider,
		Model:            model,
		Provider:         c.provider,
		Usage: types.AIUsage{
			PromptTokens:     len(strings.Split(prompt, " ")),
			CompletionTokens: 25,
			TotalTokens:      len(strings.Split(prompt, " ")) + 25,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// Chat generates a response for the given chat messages
func (c *cloudClientAdapter) Chat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions) (*types.AIResponse, error) {
	start := time.Now()
	
	// Construct response message from the last user message
	var lastUserMessage string
	for i := len(messages) - 1; i >= 0; i-- {
		if messages[i].Role == "user" {
			lastUserMessage = messages[i].Content
			break
		}
	}
	
	responseMessage := types.Message{
		Role:    "assistant",
		Content: "This is a mock chat response from " + c.provider + " for: " + lastUserMessage,
	}
	
	// Mock implementation - in real code this would call the actual cloud API
	response := &types.AIResponse{
		Text:             responseMessage.Content,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: c.provider,
		Model:            model,
		Provider:         c.provider,
		Messages:         append(messages, responseMessage),
		Usage: types.AIUsage{
			PromptTokens:     150, // Mocked token count
			CompletionTokens: 30,
			TotalTokens:      180,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// StreamChat streams a chat response token by token
func (c *cloudClientAdapter) StreamChat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions, callback func(chunk string) error) (*types.AIResponse, error) {
	start := time.Now()
	
	// Simulate streaming by breaking response into chunks
	mockResponse := fmt.Sprintf("This is a mock streaming response from %s. The response is chunked into multiple callbacks.", c.provider)
	chunks := []string{"This is ", "a mock ", "streaming ", "response ", fmt.Sprintf("from %s. ", c.provider), "The response ", "is chunked ", "into multiple ", "callbacks."}
	
	// Call callback with each chunk
	for _, chunk := range chunks {
		select {
		case <-ctx.Done():
			return nil, fmt.Errorf("context canceled during streaming: %w", ctx.Err())
		default:
			if err := callback(chunk); err != nil {
				return nil, fmt.Errorf("streaming callback failed: %w", err)
			}
			time.Sleep(50 * time.Millisecond) // Simulate processing time between chunks
		}
	}
	
	// Construct final response after streaming
	responseMessage := types.Message{
		Role:    "assistant",
		Content: mockResponse,
	}
	
	response := &types.AIResponse{
		Text:             mockResponse,
		FinishReason:     "stop",
		SelectedModel:    model,
		SelectedProvider: c.provider,
		Model:            model,
		Provider:         c.provider,
		Messages:         append(messages, responseMessage),
		Usage: types.AIUsage{
			PromptTokens:     150, // Mocked token count
			CompletionTokens: 30,
			TotalTokens:      180,
		},
		Latency: time.Since(start),
	}
	
	return response, nil
}

// GetEmbedding generates embeddings for the given text
func (c *cloudClientAdapter) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// Mock implementation - in real code this would call the actual cloud API
	// Return a mock embedding with 15 dimensions (different from Ollama to distinguish)
	mockEmbedding := make([]float32, 15)
	for i := range mockEmbedding {
		mockEmbedding[i] = float32(i) * 0.2
	}
	return mockEmbedding, nil
}

// ListModels lists available models
func (c *cloudClientAdapter) ListModels(ctx context.Context) ([]types.ModelInfo, error) {
	// Mock implementation - in real code this would call the actual cloud API
	models := []types.ModelInfo{}
	
	switch c.provider {
	case string(types.ProviderOpenAI):
		models = append(models, types.ModelInfo{
			Name:        "gpt-4",
			Provider:    types.ProviderOpenAI,
			Type:        types.ModelTypeChat,
			Description: "OpenAI GPT-4 Turbo",
			Default:     true,
		})
		models = append(models, types.ModelInfo{
			Name:        "gpt-3.5-turbo",
			Provider:    types.ProviderOpenAI,
			Type:        types.ModelTypeChat,
			Description: "OpenAI GPT-3.5 Turbo",
			Default:     false,
		})
	case string(types.ProviderAnthropic):
		models = append(models, types.ModelInfo{
			Name:        "claude-3-opus",
			Provider:    types.ProviderAnthropic,
			Type:        types.ModelTypeChat,
			Description: "Anthropic Claude 3 Opus",
			Default:     true,
		})
		models = append(models, types.ModelInfo{
			Name:        "claude-3-sonnet",
			Provider:    types.ProviderAnthropic,
			Type:        types.ModelTypeChat,
			Description: "Anthropic Claude 3 Sonnet",
			Default:     false,
		})
	default:
		return nil, fmt.Errorf("unsupported provider: %s", c.provider)
	}
	
	return models, nil
}

// CheckModelAvailability checks if a model is available
func (c *cloudClientAdapter) CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error) {
	// Mock implementation - in real code this would call the actual cloud API
	availableModels := map[string]bool{
		"gpt-4":           true,
		"gpt-3.5-turbo":   true,
		"claude-3-opus":   true,
		"claude-3-sonnet": true,
	}
	return availableModels[model], nil
}
