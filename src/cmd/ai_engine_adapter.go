package cmd

import (
	"context"
	"fmt"
	
	"github.com/rrecio/crazy-dev-zsh/src/ai"
	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// aiEngineCompatAdapter adapts types.AIEngine to ai.AIEngine interface
type aiEngineCompatAdapter struct {
	typesEngine types.AIEngine
}

// newAIEngineAdapter creates a new adapter that wraps types.AIEngine to implement ai.AIEngine
func newAIEngineAdapter(engine types.AIEngine) ai.AIEngine {
	return &aiEngineCompatAdapter{typesEngine: engine}
}

// convertRequest converts from ai.AIRequest to types.AIRequest
func (a *aiEngineCompatAdapter) convertRequest(req ai.AIRequest) types.AIRequest {
	messages := make([]types.Message, 0, len(req.Messages))
	for _, msg := range req.Messages {
		messages = append(messages, types.Message{
			Role:    msg.Role,
			Content: msg.Content,
		})
	}
	
	return types.AIRequest{
		Model:           req.Model,
		ModelType:       types.ModelType(req.ModelType),
		Provider:        req.Provider,
		Messages:        messages,
		Prompt:          req.Prompt,
		MaxTokens:       req.MaxTokens,
		Temperature:     req.Temperature,
		TopP:            req.TopP,
		Context:         req.Context,
		StopSequences:   req.StopSequences,
		Timeout:         req.Timeout,
		Stream:          req.Stream,
		FallbackToCloud: req.FallbackToCloud,
	}
}

// convertResponse converts from types.AIResponse to ai.AIResponse
func (a *aiEngineCompatAdapter) convertResponse(resp *types.AIResponse) *ai.AIResponse {
	if resp == nil {
		return nil
	}
	
	return &ai.AIResponse{
		Text:            resp.Text,
		FinishReason:    resp.FinishReason,
		Usage:           ai.AIUsage{
			PromptTokens:     resp.Usage.PromptTokens,
			CompletionTokens: resp.Usage.CompletionTokens,
			TotalTokens:      resp.Usage.TotalTokens,
		},
		SelectedModel:   resp.SelectedModel,
		SelectedProvider:resp.SelectedProvider,
		Latency:         resp.Latency,
		Error:           resp.Error,
	}
}

// Chat implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) Chat(ctx context.Context, req ai.AIRequest) (*ai.AIResponse, error) {
	typesReq := a.convertRequest(req)
	typesResp, err := a.typesEngine.Chat(ctx, typesReq)
	if err != nil {
		return nil, fmt.Errorf("chat failed: %w", err)
	}
	
	return a.convertResponse(typesResp), nil
}

// StreamChat implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) StreamChat(ctx context.Context, req ai.AIRequest, callback func(chunk string) error) (*ai.AIResponse, error) {
	typesReq := a.convertRequest(req)
	
	typesResp, err := a.typesEngine.StreamChat(ctx, typesReq, callback)
	if err != nil {
		return nil, fmt.Errorf("stream chat failed: %w", err)
	}
	
	return a.convertResponse(typesResp), nil
}

// Complete implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) Complete(ctx context.Context, req ai.AIRequest) (*ai.AIResponse, error) {
	typesReq := a.convertRequest(req)
	typesResp, err := a.typesEngine.Complete(ctx, typesReq)
	if err != nil {
		return nil, fmt.Errorf("complete failed: %w", err)
	}
	
	return a.convertResponse(typesResp), nil
}

// GetEmbedding implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// This one is a direct passthrough since the signatures match
	return a.typesEngine.GetEmbedding(ctx, text, model)
}

// ListModels implements the ai.AIEngine interface by wrapping types.AIEngine 
func (a *aiEngineCompatAdapter) ListModels(ctx context.Context, provider string) ([]ai.ModelInfo, error) {
	typesModels, err := a.typesEngine.ListModels(ctx, provider)
	if err != nil {
		return nil, fmt.Errorf("list models failed: %w", err)
	}
	
	// Convert the response
	models := make([]ai.ModelInfo, 0, len(typesModels))
	for _, m := range typesModels {
		// Convert ModelProvider and ModelType to their corresponding ai package types
		var providerType ai.ModelProvider
		var modelType ai.ModelType
		
		// Map the provider
		switch m.Provider {
		case types.ProviderOllama:
			providerType = ai.ProviderOllama
		case types.ProviderOpenAI:
			providerType = ai.ProviderOpenAI
		case types.ProviderAnthropic:
			providerType = ai.ProviderAnthropic
		default:
			// Default to Ollama if unknown
			providerType = ai.ProviderOllama
		}
		
		// Map the model type
		switch m.Type {
		case types.ModelTypeCompletion:
			modelType = ai.ModelTypeCompletion
		case types.ModelTypeChat:
			modelType = ai.ModelTypeChat
		case types.ModelTypeEmbedding:
			modelType = ai.ModelTypeEmbedding
		default:
			// Default to Chat if unknown
			modelType = ai.ModelTypeChat
		}
		
		models = append(models, ai.ModelInfo{
			Name:        m.Name,
			Provider:    providerType,
			Type:        modelType,
			Description: m.Description,
			SizeBytes:   m.SizeBytes,
			Installed:   m.Installed,
			Default:     m.Default,
		})
	}
	
	return models, nil
}

// CheckModelAvailability implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error) {
	return a.typesEngine.CheckModelAvailability(ctx, model, provider)
}

// InstallModel implements the ai.AIEngine interface by wrapping types.AIEngine
func (a *aiEngineCompatAdapter) InstallModel(ctx context.Context, model string) error {
	// Direct passthrough as signatures match
	return a.typesEngine.InstallModel(ctx, model)
}
