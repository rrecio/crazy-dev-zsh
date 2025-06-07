package ollama

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/rrecio/crazy-dev-zsh/src/ai"
)

// OllamaClient implements the interface for interacting with Ollama API
type OllamaClient struct {
	endpoint string
	client   *http.Client
}

// NewClient creates a new Ollama client
func NewClient(endpoint string) (*OllamaClient, error) {
	if endpoint == "" {
		endpoint = "http://localhost:11434"
	}
	
	return &OllamaClient{
		endpoint: endpoint,
		client: &http.Client{
			Timeout: 60 * time.Second,
		},
	}, nil
}

// OllamaGenerateRequest represents a request to the Ollama generate API
type OllamaGenerateRequest struct {
	Model       string   `json:"model"`
	Prompt      string   `json:"prompt"`
	System      string   `json:"system,omitempty"`
	Template    string   `json:"template,omitempty"`
	Context     []int    `json:"context,omitempty"`
	Stream      bool     `json:"stream"`
	Raw         bool     `json:"raw,omitempty"`
	Format      string   `json:"format,omitempty"`
	Options     Options  `json:"options,omitempty"`
	Messages    []Message `json:"messages,omitempty"`
}

// OllamaChatRequest represents a request to the Ollama chat API
type OllamaChatRequest struct {
	Model       string   `json:"model"`
	Messages    []Message `json:"messages"`
	Stream      bool     `json:"stream"`
	Options     Options  `json:"options,omitempty"`
	Format      string   `json:"format,omitempty"`
}

// OllamaEmbeddingRequest represents a request to the Ollama embedding API
type OllamaEmbeddingRequest struct {
	Model   string `json:"model"`
	Prompt  string `json:"prompt"`
	Options Options `json:"options,omitempty"`
}

// Message represents a message in a chat conversation
type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

// Options represents options for Ollama API requests
type Options struct {
	Temperature      float64 `json:"temperature,omitempty"`
	TopP             float64 `json:"top_p,omitempty"`
	TopK             int     `json:"top_k,omitempty"`
	NumPredict       int     `json:"num_predict,omitempty"`
	NumCtx           int     `json:"num_ctx,omitempty"`
	Stop             []string `json:"stop,omitempty"`
	RepeatPenalty    float64 `json:"repeat_penalty,omitempty"`
	PresencePenalty  float64 `json:"presence_penalty,omitempty"`
	FrequencyPenalty float64 `json:"frequency_penalty,omitempty"`
	Seed             int     `json:"seed,omitempty"`
	Mirostat         int     `json:"mirostat,omitempty"`
	MirostatTau      float64 `json:"mirostat_tau,omitempty"`
	MirostatEta      float64 `json:"mirostat_eta,omitempty"`
}

// OllamaGenerateResponse represents a response from the Ollama generate API
type OllamaGenerateResponse struct {
	Model     string  `json:"model"`
	Response  string  `json:"response"`
	Context   []int   `json:"context,omitempty"`
	Done      bool    `json:"done"`
	TotalDuration int64 `json:"total_duration,omitempty"`
	LoadDuration   int64 `json:"load_duration,omitempty"`
	PromptEvalCount int  `json:"prompt_eval_count,omitempty"`
	EvalCount      int   `json:"eval_count,omitempty"`
	EvalDuration   int64 `json:"eval_duration,omitempty"`
}

// OllamaChatResponse represents a response from the Ollama chat API
type OllamaChatResponse struct {
	Model     string  `json:"model"`
	Message   Message `json:"message"`
	Done      bool    `json:"done"`
	TotalDuration int64 `json:"total_duration,omitempty"`
	LoadDuration   int64 `json:"load_duration,omitempty"`
	PromptEvalCount int  `json:"prompt_eval_count,omitempty"`
	EvalCount      int   `json:"eval_count,omitempty"`
	EvalDuration   int64 `json:"eval_duration,omitempty"`
}

// OllamaEmbeddingResponse represents a response from the Ollama embedding API
type OllamaEmbeddingResponse struct {
	Embedding []float32 `json:"embedding"`
}

// OllamaModelInfo represents information about an Ollama model
type OllamaModelInfo struct {
	Name       string `json:"name"`
	Size       int64  `json:"size"`
	ModifiedAt string `json:"modified_at"`
	Digest     string `json:"digest"`
	Details    ModelDetails `json:"details"`
}

// ModelDetails represents details about an Ollama model
type ModelDetails struct {
	Format        string    `json:"format"`
	Family        string    `json:"family"`
	Families      []string  `json:"families"`
	ParameterSize string    `json:"parameter_size"`
	QuantizationLevel string `json:"quantization_level"`
}

// OllamaListModelsResponse represents a response from the Ollama list models API
type OllamaListModelsResponse struct {
	Models []OllamaModelInfo `json:"models"`
}

// NewOllamaClient creates a new Ollama client
func NewOllamaClient(endpoint string) (*OllamaClient, error) {
	if endpoint == "" {
		endpoint = "http://localhost:11434"
	}

	return &OllamaClient{
		endpoint: endpoint,
		client: &http.Client{
			Timeout: 30 * time.Second,
		},
	}, nil
}

// Complete generates a completion for the given prompt
func (c *OllamaClient) Complete(ctx context.Context, req ai.AIRequest) (*ai.AIResponse, error) {
	startTime := time.Now()

	// Create Ollama request
	ollamaReq := OllamaGenerateRequest{
		Model:  req.Model,
		Prompt: req.Prompt,
		Stream: false,
		Options: Options{
			Temperature: req.Temperature,
			TopP:        req.TopP,
			Stop:        req.StopSequences,
			NumPredict:  req.MaxTokens,
		},
	}

	// Add system message if present
	for _, msg := range req.Messages {
		if msg.Role == "system" {
			ollamaReq.System = msg.Content
			break
		}
	}

	// Set request timeout
	var cancel context.CancelFunc
	if req.Timeout != nil {
		ctx, cancel = context.WithTimeout(ctx, *req.Timeout)
		defer cancel()
	}

	// Make API request
	reqBody, err := json.Marshal(ollamaReq)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.endpoint+"/api/generate", bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	// Parse response
	var ollamaResp OllamaGenerateResponse
	if err := json.NewDecoder(resp.Body).Decode(&ollamaResp); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	// Create AI response
	aiResp := &ai.AIResponse{
		Text:            ollamaResp.Response,
		FinishReason:    "stop",
		SelectedModel:   req.Model,
		SelectedProvider: string(ai.ProviderOllama),
		Latency:         time.Since(startTime),
		Usage: ai.AIUsage{
			PromptTokens:     ollamaResp.PromptEvalCount,
			CompletionTokens: ollamaResp.EvalCount,
			TotalTokens:      ollamaResp.PromptEvalCount + ollamaResp.EvalCount,
		},
	}

	return aiResp, nil
}

// Chat generates a response for the given chat messages
func (c *OllamaClient) Chat(ctx context.Context, req ai.AIRequest) (*ai.AIResponse, error) {
	startTime := time.Now()

	// Convert AI messages to Ollama messages
	var ollamaMessages []Message
	for _, msg := range req.Messages {
		ollamaMessages = append(ollamaMessages, Message{
			Role:    msg.Role,
			Content: msg.Content,
		})
	}

	// Create Ollama request
	ollamaReq := OllamaChatRequest{
		Model:    req.Model,
		Messages: ollamaMessages,
		Stream:   false,
		Options: Options{
			Temperature: req.Temperature,
			TopP:        req.TopP,
			Stop:        req.StopSequences,
			NumPredict:  req.MaxTokens,
		},
	}

	// Set request timeout
	var cancel context.CancelFunc
	if req.Timeout != nil {
		ctx, cancel = context.WithTimeout(ctx, *req.Timeout)
		defer cancel()
	}

	// Make API request
	reqBody, err := json.Marshal(ollamaReq)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.endpoint+"/api/chat", bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	// Parse response
	var ollamaResp OllamaChatResponse
	if err := json.NewDecoder(resp.Body).Decode(&ollamaResp); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	// Create AI response
	aiResp := &ai.AIResponse{
		Text:            ollamaResp.Message.Content,
		FinishReason:    "stop",
		SelectedModel:   req.Model,
		SelectedProvider: string(ai.ProviderOllama),
		Latency:         time.Since(startTime),
		Usage: ai.AIUsage{
			PromptTokens:     ollamaResp.PromptEvalCount,
			CompletionTokens: ollamaResp.EvalCount,
			TotalTokens:      ollamaResp.PromptEvalCount + ollamaResp.EvalCount,
		},
	}

	return aiResp, nil
}

// StreamChat streams a chat response token by token
func (c *OllamaClient) StreamChat(ctx context.Context, req ai.AIRequest, callback func(chunk string) error) (*ai.AIResponse, error) {
	startTime := time.Now()

	// Convert AI messages to Ollama messages
	var ollamaMessages []Message
	for _, msg := range req.Messages {
		ollamaMessages = append(ollamaMessages, Message{
			Role:    msg.Role,
			Content: msg.Content,
		})
	}

	// Create Ollama request
	ollamaReq := OllamaChatRequest{
		Model:    req.Model,
		Messages: ollamaMessages,
		Stream:   true,
		Options: Options{
			Temperature: req.Temperature,
			TopP:        req.TopP,
			Stop:        req.StopSequences,
			NumPredict:  req.MaxTokens,
		},
	}

	// Set request timeout
	var cancel context.CancelFunc
	if req.Timeout != nil {
		ctx, cancel = context.WithTimeout(ctx, *req.Timeout)
		defer cancel()
	}

	// Make API request
	reqBody, err := json.Marshal(ollamaReq)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.endpoint+"/api/chat", bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	// Process streaming response
	decoder := json.NewDecoder(resp.Body)
	var fullText string
	var promptEvalCount, evalCount int

	for {
		var ollamaResp OllamaChatResponse
		if err := decoder.Decode(&ollamaResp); err != nil {
			if err == io.EOF {
				break
			}
			return nil, fmt.Errorf("failed to decode response: %w", err)
		}

		// Update counts
		promptEvalCount = ollamaResp.PromptEvalCount
		evalCount += ollamaResp.EvalCount

		// Send chunk to callback
		if err := callback(ollamaResp.Message.Content); err != nil {
			return nil, fmt.Errorf("callback error: %w", err)
		}

		fullText += ollamaResp.Message.Content

		if ollamaResp.Done {
			break
		}
	}

	// Create AI response
	aiResp := &ai.AIResponse{
		Text:            fullText,
		FinishReason:    "stop",
		SelectedModel:   req.Model,
		SelectedProvider: string(ai.ProviderOllama),
		Latency:         time.Since(startTime),
		Usage: ai.AIUsage{
			PromptTokens:     promptEvalCount,
			CompletionTokens: evalCount,
			TotalTokens:      promptEvalCount + evalCount,
		},
	}

	return aiResp, nil
}

// GetEmbedding generates embeddings for the given text
func (c *OllamaClient) GetEmbedding(ctx context.Context, text string, model string) ([]float32, error) {
	// Create Ollama request
	ollamaReq := OllamaEmbeddingRequest{
		Model:  model,
		Prompt: text,
	}

	// Make API request
	reqBody, err := json.Marshal(ollamaReq)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal request: %w", err)
	}

	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.endpoint+"/api/embeddings", bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	// Parse response
	var ollamaResp OllamaEmbeddingResponse
	if err := json.NewDecoder(resp.Body).Decode(&ollamaResp); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	return ollamaResp.Embedding, nil
}

// ListModels lists available models from Ollama
func (c *OllamaClient) ListModels(ctx context.Context) ([]ai.ModelInfo, error) {
	// Make API request
	httpReq, err := http.NewRequestWithContext(ctx, "GET", c.endpoint+"/api/tags", nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	// Parse response
	var ollamaResp OllamaListModelsResponse
	if err := json.NewDecoder(resp.Body).Decode(&ollamaResp); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	// Convert to AI model info
	var models []ai.ModelInfo
	for _, model := range ollamaResp.Models {
		modelType := ai.ModelTypeChat
		if model.Details.Family == "embedding" {
			modelType = ai.ModelTypeEmbedding
		}

		models = append(models, ai.ModelInfo{
			Name:        model.Name,
			Provider:    ai.ProviderOllama,
			Type:        modelType,
			Description: fmt.Sprintf("%s (%s, %s)", model.Details.Family, model.Details.ParameterSize, model.Details.QuantizationLevel),
			SizeBytes:   model.Size,
			Installed:   true,
			Default:     false,
		})
	}

	return models, nil
}

// CheckModelAvailability checks if a model is available in Ollama
func (c *OllamaClient) CheckModelAvailability(ctx context.Context, model string) (bool, error) {
	models, err := c.ListModels(ctx)
	if err != nil {
		return false, fmt.Errorf("failed to list models: %w", err)
	}

	for _, m := range models {
		if m.Name == model {
			return true, nil
		}
	}

	return false, nil
}

// InstallModel installs a model in Ollama
func (c *OllamaClient) InstallModel(ctx context.Context, model string) error {
	// Create request body
	reqBody, err := json.Marshal(map[string]string{"name": model})
	if err != nil {
		return fmt.Errorf("failed to marshal request: %w", err)
	}

	// Make API request
	httpReq, err := http.NewRequestWithContext(ctx, "POST", c.endpoint+"/api/pull", bytes.NewBuffer(reqBody))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.client.Do(httpReq)
	if err != nil {
		return fmt.Errorf("failed to send request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("API error: %s, %s", resp.Status, string(body))
	}

	return nil
}
