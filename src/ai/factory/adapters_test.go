package factory

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"

	"github.com/rrecio/crazy-dev-zsh/src/ai/types"
)

// MockOllamaClient is a mock implementation of types.OllamaClient
type MockOllamaClient struct {
	mock.Mock
}

func (m *MockOllamaClient) Complete(ctx context.Context, model string, prompt string, opts types.CompletionOptions) (*types.AIResponse, error) {
	args := m.Called(ctx, model, prompt, opts)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockOllamaClient) Chat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions) (*types.AIResponse, error) {
	args := m.Called(ctx, model, messages, opts)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockOllamaClient) StreamChat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions, callback func(chunk string) error) (*types.AIResponse, error) {
	args := m.Called(ctx, model, messages, opts, callback)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockOllamaClient) ListModels(ctx context.Context) ([]types.ModelInfo, error) {
	args := m.Called(ctx)
	return args.Get(0).([]types.ModelInfo), args.Error(1)
}

func (m *MockOllamaClient) GetModelInfo(ctx context.Context, model string) (*types.ModelInfo, error) {
	args := m.Called(ctx, model)
	return args.Get(0).(*types.ModelInfo), args.Error(1)
}

func (m *MockOllamaClient) InstallModel(ctx context.Context, model string) error {
	args := m.Called(ctx, model)
	return args.Error(0)
}

// MockCloudClient is a mock implementation of types.CloudClient
type MockCloudClient struct {
	mock.Mock
}

func (m *MockCloudClient) Complete(ctx context.Context, model string, prompt string, opts types.CompletionOptions) (*types.AIResponse, error) {
	args := m.Called(ctx, model, prompt, opts)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockCloudClient) Chat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions) (*types.AIResponse, error) {
	args := m.Called(ctx, model, messages, opts)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockCloudClient) StreamChat(ctx context.Context, model string, messages []types.Message, opts types.ChatOptions, callback func(chunk string) error) (*types.AIResponse, error) {
	args := m.Called(ctx, model, messages, opts, callback)
	return args.Get(0).(*types.AIResponse), args.Error(1)
}

func (m *MockCloudClient) ListModels(ctx context.Context) ([]types.ModelInfo, error) {
	args := m.Called(ctx)
	return args.Get(0).([]types.ModelInfo), args.Error(1)
}

// MockPromptEngine is a mock implementation of types.PromptEngine
type MockPromptEngine struct {
	mock.Mock
}

func (m *MockPromptEngine) RegisterTemplate(name string, template string) error {
	args := m.Called(name, template)
	return args.Error(0)
}

func (m *MockPromptEngine) Render(templateName string, data interface{}) (string, error) {
	args := m.Called(templateName, data)
	return args.String(0), args.Error(1)
}

// Tests for aiEngineAdapter
func TestAIEngineAdapter_Chat(t *testing.T) {
	// Setup
	mockOllama := new(MockOllamaClient)
	mockCloud := new(MockCloudClient)
	mockPrompt := new(MockPromptEngine)

	adapter := &aiEngineAdapter{
		ollamaClient: mockOllama,
		cloudClient:  mockCloud,
		promptEngine: mockPrompt,
		config: &types.AIConfig{
			LocalEnabled:  true,
			LocalEndpoint: "http://localhost:11434",
			FallbackToCloud: true,
			CloudProvider: "openai",
		},
	}

	ctx := context.Background()
	req := types.AIRequest{
		Model:       "llama2",
		Provider:    "ollama",
		MaxTokens:   100,
		Temperature: 0.7,
		Messages: []types.Message{
			{Role: "system", Content: "You are a helpful assistant"},
			{Role: "user", Content: "Hello"},
		},
	}

	mockResponse := &types.AIResponse{
		Text:         "Hello! How can I help you today?",
		FinishReason: "stop",
		Usage: types.AIUsage{
			PromptTokens:     10,
			CompletionTokens: 8,
			TotalTokens:      18,
		},
		SelectedModel:    "llama2",
		SelectedProvider: "ollama",
		Latency:          100 * time.Millisecond,
	}

	// Expectations for Ollama client
	mockOllama.On("Chat", ctx, "llama2", req.Messages, types.ChatOptions{
		MaxTokens:   req.MaxTokens,
		Temperature: req.Temperature,
		TopP:        req.TopP,
	}).Return(mockResponse, nil)

	// Execute
	resp, err := adapter.Chat(ctx, req)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, resp)
	assert.Equal(t, mockResponse.Text, resp.Text)
	assert.Equal(t, mockResponse.SelectedModel, resp.SelectedModel)
	assert.Equal(t, mockResponse.SelectedProvider, resp.SelectedProvider)

	// Verify expectations
	mockOllama.AssertExpectations(t)
}

// Test with fallback to cloud
func TestAIEngineAdapter_Chat_WithFallback(t *testing.T) {
	// Setup
	mockOllama := new(MockOllamaClient)
	mockCloud := new(MockCloudClient)
	mockPrompt := new(MockPromptEngine)

	adapter := &aiEngineAdapter{
		ollamaClient: mockOllama,
		cloudClient:  mockCloud,
		promptEngine: mockPrompt,
		config: &types.AIConfig{
			LocalEnabled:    true,
			LocalEndpoint:   "http://localhost:11434",
			FallbackToCloud: true,
			CloudProvider:   "openai",
		},
	}

	ctx := context.Background()
	req := types.AIRequest{
		Model:       "llama2",
		Provider:    "ollama",
		MaxTokens:   100,
		Temperature: 0.7,
		Messages: []types.Message{
			{Role: "system", Content: "You are a helpful assistant"},
			{Role: "user", Content: "Hello"},
		},
	}

	// Local client error
	localError := assert.AnError
	mockOllama.On("Chat", ctx, "llama2", req.Messages, types.ChatOptions{
		MaxTokens:   req.MaxTokens,
		Temperature: req.Temperature,
		TopP:        req.TopP,
	}).Return((*types.AIResponse)(nil), localError)

	// Cloud client response
	cloudResponse := &types.AIResponse{
		Text:         "Hello from cloud!",
		FinishReason: "stop",
		Usage: types.AIUsage{
			PromptTokens:     10,
			CompletionTokens: 8,
			TotalTokens:      18,
		},
		SelectedModel:    "gpt-3.5-turbo",
		SelectedProvider: "openai",
		Latency:          200 * time.Millisecond,
	}

	// Cloud client expectation
	mockCloud.On("Chat", ctx, "gpt-3.5-turbo", req.Messages, types.ChatOptions{
		MaxTokens:   req.MaxTokens,
		Temperature: req.Temperature,
		TopP:        req.TopP,
	}).Return(cloudResponse, nil)

	// Execute
	resp, err := adapter.Chat(ctx, req)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, resp)
	assert.Equal(t, cloudResponse.Text, resp.Text)
	assert.Equal(t, cloudResponse.SelectedModel, resp.SelectedModel)
	assert.Equal(t, cloudResponse.SelectedProvider, resp.SelectedProvider)

	// Verify expectations
	mockOllama.AssertExpectations(t)
	mockCloud.AssertExpectations(t)
}

// Test for StreamChat
func TestAIEngineAdapter_StreamChat(t *testing.T) {
	// Setup
	mockOllama := new(MockOllamaClient)
	mockCloud := new(MockCloudClient)
	mockPrompt := new(MockPromptEngine)

	adapter := &aiEngineAdapter{
		ollamaClient: mockOllama,
		cloudClient:  mockCloud,
		promptEngine: mockPrompt,
		config: &types.AIConfig{
			LocalEnabled:    true,
			LocalEndpoint:   "http://localhost:11434",
			FallbackToCloud: true,
			CloudProvider:   "openai",
		},
	}

	ctx := context.Background()
	req := types.AIRequest{
		Model:       "llama2",
		Provider:    "ollama",
		MaxTokens:   100,
		Temperature: 0.7,
		Stream:      true,
		Messages: []types.Message{
			{Role: "system", Content: "You are a helpful assistant"},
			{Role: "user", Content: "Hello"},
		},
	}

	chunks := []string{}
	callback := func(chunk string) error {
		chunks = append(chunks, chunk)
		return nil
	}

	mockResponse := &types.AIResponse{
		Text:         "Hello! How can I help you today?",
		FinishReason: "stop",
		Usage: types.AIUsage{
			PromptTokens:     10,
			CompletionTokens: 8,
			TotalTokens:      18,
		},
		SelectedModel:    "llama2",
		SelectedProvider: "ollama",
		Latency:          100 * time.Millisecond,
	}

	// Expectations for Ollama client
	mockOllama.On("StreamChat", ctx, "llama2", req.Messages, types.ChatOptions{
		MaxTokens:   req.MaxTokens,
		Temperature: req.Temperature,
		TopP:        req.TopP,
	}, mock.AnythingOfType("func(string) error")).Return(mockResponse, nil).Run(func(args mock.Arguments) {
		cbFunc := args.Get(4).(func(chunk string) error)
		cbFunc("Hello")
		cbFunc("! How")
		cbFunc(" can I")
		cbFunc(" help you")
		cbFunc(" today?")
	})

	// Execute
	resp, err := adapter.StreamChat(ctx, req, callback)

	// Assert
	assert.NoError(t, err)
	assert.NotNil(t, resp)
	assert.Equal(t, mockResponse.Text, resp.Text)
	assert.Equal(t, mockResponse.SelectedModel, resp.SelectedModel)
	assert.Equal(t, mockResponse.SelectedProvider, resp.SelectedProvider)
	assert.Equal(t, 5, len(chunks))
	assert.Equal(t, "Hello! How can I help you today?", chunks[0]+chunks[1]+chunks[2]+chunks[3]+chunks[4])

	// Verify expectations
	mockOllama.AssertExpectations(t)
}
