// Package types provides shared types and interfaces for the AI engine
package types

import (
	"context"
)

// AIEngine is the interface for interacting with AI models
type AIEngine interface {
	// Complete generates a completion for the given prompt
	Complete(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// Chat generates a response for the given chat messages
	Chat(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// StreamChat streams a chat response token by token
	StreamChat(ctx context.Context, req AIRequest, callback func(chunk string) error) (*AIResponse, error)
	
	// GetEmbedding generates embeddings for the given text
	GetEmbedding(ctx context.Context, text string, model string) ([]float32, error)
	
	// ListModels lists available models
	ListModels(ctx context.Context, provider string) ([]ModelInfo, error)
	
	// CheckModelAvailability checks if a model is available
	CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error)
	
	// InstallModel installs a model (for local providers like Ollama)
	InstallModel(ctx context.Context, model string) error
}

// OllamaClient is the interface for interacting with Ollama API
type OllamaClient interface {
	// Complete generates a completion for the given prompt
	Complete(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// Chat generates a response for the given chat messages
	Chat(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// StreamChat streams a chat response token by token
	StreamChat(ctx context.Context, req AIRequest, callback func(chunk string) error) (*AIResponse, error)
	
	// GetEmbedding generates embeddings for the given text
	GetEmbedding(ctx context.Context, text string, model string) ([]float32, error)
	
	// ListModels lists available models
	ListModels(ctx context.Context) ([]ModelInfo, error)
	
	// CheckModelAvailability checks if a model is available
	CheckModelAvailability(ctx context.Context, model string) (bool, error)
	
	// InstallModel installs a model
	InstallModel(ctx context.Context, model string) error
}

// CloudClient is the interface for interacting with cloud AI providers
type CloudClient interface {
	// Complete generates a completion for the given prompt
	Complete(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// Chat generates a response for the given chat messages
	Chat(ctx context.Context, req AIRequest) (*AIResponse, error)
	
	// StreamChat streams a chat response token by token
	StreamChat(ctx context.Context, req AIRequest, callback func(chunk string) error) (*AIResponse, error)
	
	// GetEmbedding generates embeddings for the given text
	GetEmbedding(ctx context.Context, text string, model string) ([]float32, error)
	
	// ListModels lists available models
	ListModels(ctx context.Context, provider string) ([]ModelInfo, error)
	
	// CheckModelAvailability checks if a model is available
	CheckModelAvailability(ctx context.Context, model string, provider string) (bool, error)
}

// PromptEngine is the interface for processing prompts
type PromptEngine interface {
	// ProcessPrompt processes a prompt with the given context
	ProcessPrompt(prompt string, context []byte) (string, error)
	
	// ProcessMessages processes chat messages with the given context
	ProcessMessages(messages []Message, context []byte) ([]Message, error)
	
	// ExecuteTemplate executes a template with the given data
	ExecuteTemplate(name string, data interface{}) (string, error)
	
	// RegisterTemplate registers a template with the prompt engine
	RegisterTemplate(name string, templateStr string) error
	
	// LoadDefaultTemplates loads the default templates into the prompt engine
	LoadDefaultTemplates() error
}
