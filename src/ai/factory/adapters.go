// Package factory provides factory functions for creating AI components
package factory

import (
	"context"
	"fmt"

	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// aiEngineAdapter adapts internal AI engine to types.AIEngine interface
type aiEngineAdapter struct {
	ollamaClient types.OllamaClient
	cloudClient  types.CloudClient
	promptEngine types.PromptEngine
	config       types.AIConfig
}

// Chat implements the types.AIEngine interface
func (a *aiEngineAdapter) Chat(ctx context.Context, req types.AIRequest) (*types.AIResponse, error) {
	// Process messages with prompt engine if they exist
	if len(req.Messages) > 0 {
		processedMessages, err := a.promptEngine.ProcessMessages(req.Messages, req.Context)
		if err != nil {
			return nil, fmt.Errorf("failed to process messages: %w", err)
		}
		req.Messages = processedMessages
	}
	
	// Use local or cloud client based on provider
	var resp *types.AIResponse
	var err error
	
	if req.Provider == "ollama" {
		resp, err = a.ollamaClient.Chat(ctx, req)
	} else {
		resp, err = a.cloudClient.Chat(ctx, req)
	}
	
	if err != nil {
		return nil, err
	}
	
	return resp, nil
}

// StreamChat implements the types.AIEngine interface
func (a *aiEngineAdapter) StreamChat(ctx context.Context, req types.AIRequest, callback func(chunk string) error) (*types.AIResponse, error) {
	// Process messages with prompt engine if they exist
	if len(req.Messages) > 0 {
		processedMessages, err := a.promptEngine.ProcessMessages(req.Messages, req.Context)
		if err != nil {
			return nil, fmt.Errorf("failed to process messages: %w", err)
		}
		req.Messages = processedMessages
	}
	
	// Use local or cloud client based on provider
	var resp *types.AIResponse
	var err error
	
	if req.Provider == "ollama" {
		resp, err = a.ollamaClient.StreamChat(ctx, req, callback)
	} else {
		resp, err = a.cloudClient.StreamChat(ctx, req, callback)
	}
	
	if err != nil {
		return nil, err
	}
	
	return resp, nil
}

// Complete implements the types.AIEngine interface
func (a *aiEngineAdapter) Complete(ctx context.Context, req types.AIRequest) (*types.AIResponse, error) {
	// Process prompt with prompt engine if exists
	if req.Prompt != "" {
		processedPrompt, err := a.promptEngine.ProcessPrompt(req.Prompt, req.Context)
		if err != nil {
			return nil, fmt.Errorf("failed to process prompt: %w", err)
		}
		req.Prompt = processedPrompt
	}
	
	// Use local or cloud client based on provider
	var resp *types.AIResponse
	var err error
	
	if req.Provider == "ollama" {
		resp, err = a.ollamaClient.Complete(ctx, req)
	} else {
		resp, err = a.cloudClient.Complete(ctx, req)
	}
	
	if err != nil {
		return nil, err
	}
	
	return resp, nil
}

// GetEmbedding implements the types.AIEngine interface
func (a *aiEngineAdapter) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// Use ollama for local embeddings or cloud service based on model name/config
	if a.config.LocalEnabled {
		return a.ollamaClient.GetEmbedding(ctx, text, model)
	} else {
		return a.cloudClient.GetEmbedding(ctx, text, model)
	}
}

// ListModels implements the types.AIEngine interface
func (a *aiEngineAdapter) ListModels(ctx context.Context, provider string) ([]types.ModelInfo, error) {
	// Get models from appropriate client based on provider
	var models []types.ModelInfo
	
	if provider == "ollama" || provider == "" {
		// Get Ollama models
		ollamaModels, err := a.ollamaClient.ListModels(ctx)
		if err != nil {
			return nil, fmt.Errorf("failed to list Ollama models: %w", err)
		}
		models = append(models, ollamaModels...)
	}
	
	if provider != "ollama" {
		// Get cloud models if provider is not specifically Ollama
		cloudModels, err := a.cloudClient.ListModels(ctx, provider)
		if err != nil {
			return nil, fmt.Errorf("failed to list cloud models: %w", err)
		}
		models = append(models, cloudModels...)
	}
	
	return models, nil
}

// CheckModelAvailability implements the types.AIEngine interface
func (a *aiEngineAdapter) CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error) {
	// Check model availability based on provider
	if provider == "ollama" {
		return a.ollamaClient.CheckModelAvailability(ctx, model)
	} else {
		return a.cloudClient.CheckModelAvailability(ctx, model, provider)
	}
}

// InstallModel implements the types.AIEngine interface
func (a *aiEngineAdapter) InstallModel(ctx context.Context, model string) error {
	// For now, we only support installing models through Ollama
	// This matches the interface signature in types.AIEngine
	return a.ollamaClient.InstallModel(ctx, model)
}

// We don't need type conversion functions anymore since we're using the types package directly
// and not converting between ai package and types package

