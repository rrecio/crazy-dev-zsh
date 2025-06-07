// Package factory provides factory functions for creating AI components
package factory

import (
	"context"
	"fmt"
	"time"
	
	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// NewAIEngine creates a new AI engine with the given configuration
func NewAIEngine(config types.AIConfig) (types.AIEngine, error) {
	// Create Ollama client
	ollamaClient, err := NewOllamaClient(config.LocalEndpoint)
	if err != nil {
		return nil, fmt.Errorf("failed to create Ollama client: %w", err)
	}

	// Create Cloud client
	cloudClient, err := NewCloudClient(config.CloudProvider)
	if err != nil {
		return nil, fmt.Errorf("failed to create Cloud client: %w", err)
	}

	// Create Prompt engine
	promptEngine := NewPromptEngine()

	// Create AI engine adapter
	return &aiEngineAdapter{
		ollamaClient: ollamaClient,
		cloudClient:  cloudClient,
		promptEngine: promptEngine,
		config:       config,
	}, nil
}

// LogWithLatency logs a message with latency information
func LogWithLatency(ctx context.Context, start time.Time, operation string, err error) {
	latency := time.Since(start)
	if err != nil {
		// Use structured logging with error
		fmt.Printf("Operation: %s, Latency: %s, Error: %v\n", operation, latency, err)
	} else {
		// Use structured logging for success
		fmt.Printf("Operation: %s, Latency: %s\n", operation, latency)
	}
}
