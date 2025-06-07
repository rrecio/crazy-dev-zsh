// Package factory provides factory functions for creating AI components
package factory

import (
	"github.com/rrecio/crazy-dev-zsh/src/ai"
	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// ConvertAIConfigToTypes converts an internal ai.AIConfig to types.AIConfig
func ConvertAIConfigToTypes(internalConfig ai.AIConfig) types.AIConfig {
	return types.AIConfig{
		LocalEnabled:      internalConfig.LocalEnabled,
		LocalEndpoint:     internalConfig.LocalEndpoint,
		DefaultModels:     internalConfig.DefaultModels,
		FallbackToCloud:   internalConfig.FallbackToCloud,
		CloudProvider:     internalConfig.CloudProvider,
		RateLimit:         internalConfig.RateLimit,
		CacheTTL:          internalConfig.CacheTTL,
		AIResponseTimeout: internalConfig.AIResponseTimeout,
		CloudAITimeout:    internalConfig.CloudAITimeout,
	}
}

// ConvertTypesToAIConfig converts a types.AIConfig to an internal ai.AIConfig
func ConvertTypesToAIConfig(typesConfig types.AIConfig) ai.AIConfig {
	return ai.AIConfig{
		LocalEnabled:      typesConfig.LocalEnabled,
		LocalEndpoint:     typesConfig.LocalEndpoint,
		DefaultModels:     typesConfig.DefaultModels,
		FallbackToCloud:   typesConfig.FallbackToCloud,
		CloudProvider:     typesConfig.CloudProvider,
		RateLimit:         typesConfig.RateLimit,
		CacheTTL:          typesConfig.CacheTTL,
		AIResponseTimeout: typesConfig.AIResponseTimeout,
		CloudAITimeout:    typesConfig.CloudAITimeout,
	}
}
