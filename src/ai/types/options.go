// Package types provides shared types and interfaces for the AI engine
package types

// CompletionOptions contains options for completion requests
type CompletionOptions struct {
	MaxTokens   int     `json:"max_tokens"`   // Maximum tokens to generate
	Temperature float64 `json:"temperature"`  // Temperature for sampling (0.0-2.0)
	TopP        float64 `json:"top_p"`        // Top-p sampling (0.0-1.0)
	StopSequences []string `json:"stop_sequences"` // Sequences that stop generation
}

// ChatOptions contains options for chat requests
type ChatOptions struct {
	MaxTokens   int     `json:"max_tokens"`   // Maximum tokens to generate
	Temperature float64 `json:"temperature"`  // Temperature for sampling (0.0-2.0)
	TopP        float64 `json:"top_p"`        // Top-p sampling (0.0-1.0)
	StopSequences []string `json:"stop_sequences"` // Sequences that stop generation
}
