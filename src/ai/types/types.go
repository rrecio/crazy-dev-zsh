// Package types provides shared types and interfaces for the AI engine
package types

import (
	"time"
)

// ModelProvider represents the source of AI models
type ModelProvider string

const (
	// ProviderOllama represents local Ollama models
	ProviderOllama ModelProvider = "ollama"
	// ProviderOpenAI represents OpenAI cloud models
	ProviderOpenAI ModelProvider = "openai"
	// ProviderAnthropic represents Anthropic cloud models
	ProviderAnthropic ModelProvider = "anthropic"
)

// ModelType represents the type of AI model
type ModelType string

const (
	// ModelTypeCompletion represents text completion models
	ModelTypeCompletion ModelType = "completion"
	// ModelTypeChat represents chat models
	ModelTypeChat ModelType = "chat"
	// ModelTypeEmbedding represents embedding models
	ModelTypeEmbedding ModelType = "embedding"
)

// Message represents a message in a chat conversation
type Message struct {
	Role    string `json:"role"`    // Role can be "system", "user", or "assistant"
	Content string `json:"content"` // Content is the message text
}

// AIRequest represents a request to the AI engine
type AIRequest struct {
	Model           string     `json:"model"`            // Model name to use
	ModelType       ModelType  `json:"model_type"`       // Type of model (completion, chat, embedding)
	Provider        string     `json:"provider"`         // Provider name (ollama, openai, anthropic)
	Messages        []Message  `json:"messages"`         // Messages for chat models
	Prompt          string     `json:"prompt"`           // Prompt for completion models
	MaxTokens       int        `json:"max_tokens"`       // Maximum tokens to generate
	Temperature     float64    `json:"temperature"`      // Temperature for sampling (0.0-2.0)
	TopP            float64    `json:"top_p"`            // Top-p sampling (0.0-1.0)
	Context         []byte     `json:"context"`          // Context for the model (e.g., code snippets)
	StopSequences   []string   `json:"stop_sequences"`   // Sequences that stop generation
	Timeout         *time.Duration `json:"timeout"`      // Timeout for the request
	Stream          bool       `json:"stream"`           // Whether to stream the response
	FallbackToCloud bool       `json:"fallback_to_cloud"` // Whether to fallback to cloud if local fails
}

// AIResponse represents a response from the AI engine
type AIResponse struct {
	Text           string    `json:"text"`            // Generated text
	FinishReason   string    `json:"finish_reason"`   // Reason for finishing (e.g., "stop", "length")
	Usage          AIUsage   `json:"usage"`           // Token usage information
	SelectedModel  string    `json:"selected_model"`  // Model that was actually used
	SelectedProvider string  `json:"selected_provider"` // Provider that was actually used
	Latency        time.Duration `json:"latency"`     // Time taken to generate the response
	Error          error     `json:"error"`           // Error if any
	Messages       []Message `json:"messages"`        // Messages in the response (for chat models)
	Model          string    `json:"model"`           // Model used for generation
	Provider       string    `json:"provider"`        // Provider used for generation
}

// AIUsage represents token usage information
type AIUsage struct {
	PromptTokens     int `json:"prompt_tokens"`      // Tokens in the prompt
	CompletionTokens int `json:"completion_tokens"`  // Tokens in the completion
	TotalTokens      int `json:"total_tokens"`       // Total tokens used
}

// ModelInfo represents information about an AI model
type ModelInfo struct {
	Name        string       `json:"name"`         // Model name
	Provider    ModelProvider `json:"provider"`    // Model provider
	Type        ModelType    `json:"type"`         // Model type
	Description string       `json:"description"`  // Model description
	SizeBytes   int64        `json:"size_bytes"`   // Model size in bytes
	Installed   bool         `json:"installed"`    // Whether the model is installed locally
	Default     bool         `json:"default"`      // Whether this is a default model
}

// AIConfig represents the configuration for the AI engine
type AIConfig struct {
	LocalEnabled      bool          `json:"local_enabled"`
	LocalEndpoint     string        `json:"local_endpoint"`
	DefaultModels     []string      `json:"default_models"`
	FallbackToCloud   bool          `json:"fallback_to_cloud"`
	CloudProvider     string        `json:"cloud_provider"`
	RateLimit         int           `json:"rate_limit"`
	CacheTTL          time.Duration `json:"cache_ttl"`
	AIResponseTimeout time.Duration `json:"ai_response_timeout"`
	CloudAITimeout    time.Duration `json:"cloud_ai_timeout"`
}


