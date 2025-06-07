// Package ai provides the core AI engine functionality for Crazy Dev
package ai

import (
	"context"
	"errors"
	"fmt"

	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// AIEngineImpl implements the types.AIEngine interface
type AIEngineImpl struct {
	OllamaClient types.OllamaClient
	CloudClient  types.CloudClient
	PromptEngine types.PromptEngine
	Config       types.AIConfig
}

// NewAIEngineImpl creates a new AIEngineImpl instance
func NewAIEngineImpl(ollamaClient types.OllamaClient, cloudClient types.CloudClient, promptEngine types.PromptEngine, config types.AIConfig) *AIEngineImpl {
	return &AIEngineImpl{
		OllamaClient: ollamaClient,
		CloudClient:  cloudClient,
		PromptEngine: promptEngine,
		Config:       config,
	}
}

// Complete generates a completion for the given prompt
func (e *AIEngineImpl) Complete(ctx context.Context, req types.AIRequest) (*types.AIResponse, error) {
	// Set default timeout if not provided
	if req.Timeout == nil {
		timeout := e.Config.AIResponseTimeout
		req.Timeout = &timeout
	}

	// Process the prompt with the prompt engine
	processedPrompt, err := e.PromptEngine.ProcessPrompt(req.Prompt, req.Context)
	if err != nil {
		return nil, fmt.Errorf("failed to process prompt: %w", err)
	}
	req.Prompt = processedPrompt

	// Try local model first if enabled
	if e.Config.LocalEnabled && (req.Provider == string(types.ProviderOllama) || req.Provider == "") {
		localReq := req
		localReq.Provider = string(types.ProviderOllama)
		
		response, err := e.OllamaClient.Complete(ctx, localReq.Model, localReq.Prompt, types.CompletionOptions{
			MaxTokens:     localReq.MaxTokens,
			Temperature:   localReq.Temperature,
			TopP:          localReq.TopP,
			StopSequences: localReq.StopSequences,
		})
		if err == nil {
			return response, nil
		}
		
		// If local fails and fallback is enabled, try cloud
		if req.FallbackToCloud || e.Config.FallbackToCloud {
			cloudReq := req
			cloudReq.Provider = e.Config.CloudProvider
			cloudTimeout := e.Config.CloudAITimeout
			cloudReq.Timeout = &cloudTimeout
			
			return e.CloudClient.Complete(ctx, cloudReq.Model, cloudReq.Prompt, types.CompletionOptions{
				MaxTokens:     cloudReq.MaxTokens,
				Temperature:   cloudReq.Temperature,
				TopP:          cloudReq.TopP,
				StopSequences: cloudReq.StopSequences,
			})
		}
		
		return nil, err
	}
	
	// Use cloud directly if local is disabled or another provider is specified
	return e.CloudClient.Complete(ctx, req.Model, req.Prompt, types.CompletionOptions{
		MaxTokens:     req.MaxTokens,
		Temperature:   req.Temperature,
		TopP:          req.TopP,
		StopSequences: req.StopSequences,
	})
}

// Chat generates a response for the given chat messages
func (e *AIEngineImpl) Chat(ctx context.Context, req types.AIRequest) (*types.AIResponse, error) {
	// Set default timeout if not provided
	if req.Timeout == nil {
		timeout := e.Config.AIResponseTimeout
		req.Timeout = &timeout
	}

	// Process the messages with the prompt engine
	processedMessages, err := e.PromptEngine.ProcessMessages(req.Messages, req.Context)
	if err != nil {
		return nil, fmt.Errorf("failed to process messages: %w", err)
	}
	req.Messages = processedMessages

	// Try local model first if enabled
	if e.Config.LocalEnabled && (req.Provider == string(types.ProviderOllama) || req.Provider == "") {
		localReq := req
		localReq.Provider = string(types.ProviderOllama)
		
		response, err := e.OllamaClient.Chat(ctx, localReq.Model, localReq.Messages, types.ChatOptions{
			MaxTokens:     localReq.MaxTokens,
			Temperature:   localReq.Temperature,
			TopP:          localReq.TopP,
			StopSequences: localReq.StopSequences,
		})
		if err == nil {
			return response, nil
		}
		
		// If local fails and fallback is enabled, try cloud
		if req.FallbackToCloud || e.Config.FallbackToCloud {
			cloudReq := req
			cloudReq.Provider = e.Config.CloudProvider
			cloudTimeout := e.Config.CloudAITimeout
			cloudReq.Timeout = &cloudTimeout
			
			return e.CloudClient.Chat(ctx, cloudReq.Model, cloudReq.Messages, types.ChatOptions{
				MaxTokens:     cloudReq.MaxTokens,
				Temperature:   cloudReq.Temperature,
				TopP:          cloudReq.TopP,
				StopSequences: cloudReq.StopSequences,
			})
		}
		
		return nil, err
	}
	
	// Use cloud directly if local is disabled or another provider is specified
	return e.CloudClient.Chat(ctx, req.Model, req.Messages, types.ChatOptions{
		MaxTokens:     req.MaxTokens,
		Temperature:   req.Temperature,
		TopP:          req.TopP,
		StopSequences: req.StopSequences,
	})
}

// StreamChat streams a chat response token by token
func (e *AIEngineImpl) StreamChat(ctx context.Context, req types.AIRequest, callback func(chunk string) error) (*types.AIResponse, error) {
	// Set default timeout if not provided
	if req.Timeout == nil {
		timeout := e.Config.AIResponseTimeout
		req.Timeout = &timeout
	}

	// Process the messages with the prompt engine
	processedMessages, err := e.PromptEngine.ProcessMessages(req.Messages, req.Context)
	if err != nil {
		return nil, fmt.Errorf("failed to process messages: %w", err)
	}
	req.Messages = processedMessages

	// Try local model first if enabled
	if e.Config.LocalEnabled && (req.Provider == string(types.ProviderOllama) || req.Provider == "") {
		localReq := req
		localReq.Provider = string(types.ProviderOllama)
		
		response, err := e.OllamaClient.StreamChat(ctx, localReq.Model, localReq.Messages, types.ChatOptions{
			MaxTokens:     localReq.MaxTokens,
			Temperature:   localReq.Temperature,
			TopP:          localReq.TopP,
			StopSequences: localReq.StopSequences,
		}, callback)
		if err == nil {
			return response, nil
		}
		
		// If local fails and fallback is enabled, try cloud
		if req.FallbackToCloud || e.Config.FallbackToCloud {
			cloudReq := req
			cloudReq.Provider = e.Config.CloudProvider
			cloudTimeout := e.Config.CloudAITimeout
			cloudReq.Timeout = &cloudTimeout
			
			return e.CloudClient.StreamChat(ctx, cloudReq.Model, cloudReq.Messages, types.ChatOptions{
				MaxTokens:     cloudReq.MaxTokens,
				Temperature:   cloudReq.Temperature,
				TopP:          cloudReq.TopP,
				StopSequences: cloudReq.StopSequences,
			}, callback)
		}
		
		return nil, err
	}
	
	// Use cloud directly if local is disabled or another provider is specified
	return e.CloudClient.StreamChat(ctx, req.Model, req.Messages, types.ChatOptions{
		MaxTokens:     req.MaxTokens,
		Temperature:   req.Temperature,
		TopP:          req.TopP,
		StopSequences: req.StopSequences,
	}, callback)
}

// GetEmbedding generates embeddings for the given text
func (e *AIEngineImpl) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// Try local model first if enabled
	if e.Config.LocalEnabled {
		embedding, err := e.OllamaClient.GetEmbedding(ctx, text, model)
		if err == nil {
			return embedding, nil
		}
		
		// If local fails and fallback is enabled, try cloud
		if e.Config.FallbackToCloud {
			return e.CloudClient.GetEmbedding(ctx, text, model)
		}
		
		return nil, err
	}
	
	// Use cloud directly if local is disabled
	return e.CloudClient.GetEmbedding(ctx, text, model)
}

// ListModels lists available models
func (e *AIEngineImpl) ListModels(ctx context.Context, provider string) ([]types.ModelInfo, error) {
	var models []types.ModelInfo
	var err error

	// If provider is specified, only list models from that provider
	if provider != "" {
		switch types.ModelProvider(provider) {
		case types.ProviderOllama:
			return e.OllamaClient.ListModels(ctx)
		case types.ProviderOpenAI, types.ProviderAnthropic:
			models, err := e.CloudClient.ListModels(ctx)
			// Filter models by provider
			var filteredModels []types.ModelInfo
			for _, model := range models {
				if string(model.Provider) == provider {
					filteredModels = append(filteredModels, model)
				}
			}
			return filteredModels, err
		default:
			return nil, fmt.Errorf("unsupported provider: %s", provider)
		}
	}

	// Otherwise, list models from all configured providers
	ollamaModels, ollamaErr := e.OllamaClient.ListModels(ctx)
	if ollamaErr == nil {
		models = append(models, ollamaModels...)
	} else {
		err = errors.New("failed to list Ollama models")
	}

	cloudModels, cloudErr := e.CloudClient.ListModels(ctx)
	// Filter models by provider
	var filteredCloudModels []types.ModelInfo
	for _, model := range cloudModels {
		if string(model.Provider) == e.Config.CloudProvider {
			filteredCloudModels = append(filteredCloudModels, model)
		}
	}
	cloudModels = filteredCloudModels
	if cloudErr == nil {
		models = append(models, cloudModels...)
	} else if err == nil {
		err = errors.New("failed to list cloud models")
	} else {
		err = errors.New("failed to list both Ollama and cloud models")
	}

	if len(models) > 0 {
		return models, err
	}
	return nil, err
}

// CheckModelAvailability checks if a model is available
func (e *AIEngineImpl) CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error) {
	if provider == "" {
		provider = string(types.ProviderOllama)
	}

	switch types.ModelProvider(provider) {
	case types.ProviderOllama:
		return e.OllamaClient.CheckModelAvailability(ctx, model)
	case types.ProviderOpenAI, types.ProviderAnthropic:
		return e.CloudClient.CheckModelAvailability(ctx, model, provider)
	default:
		return false, fmt.Errorf("unsupported provider: %s", provider)
	}
}

// InstallModel installs a model (for local providers like Ollama)
func (e *AIEngineImpl) InstallModel(ctx context.Context, model string) error {
	// Only Ollama supports model installation
	return e.OllamaClient.InstallModel(ctx, model)
}
