package prompt

import (
	"bytes"
	"fmt"
	"strings"
	"text/template"

	"github.com/rrecio/crazy-dev-zsh/src/ai"
)

// PromptEngine handles prompt processing and template management
type PromptEngine struct {
	templates map[string]*template.Template
}

// PromptTemplate represents a template for generating prompts
type PromptTemplate struct {
	Name        string
	Description string
	Template    string
	Variables   map[string]string
}

// ContextData represents context data to be included in prompts
type ContextData struct {
	ProjectInfo   map[string]interface{}
	GitInfo       map[string]interface{}
	TechStacks    []map[string]interface{}
	FileStats     map[string]interface{}
	Dependencies  map[string]interface{}
	CurrentFile   string
	CurrentBranch string
	CurrentDir    string
	UserQuery     string
}

// NewPromptEngine creates a new prompt engine
func NewPromptEngine() *PromptEngine {
	return &PromptEngine{
		templates: make(map[string]*template.Template),
	}
}

// RegisterTemplate registers a template with the prompt engine
func (e *PromptEngine) RegisterTemplate(name string, templateStr string) error {
	tmpl, err := template.New(name).Parse(templateStr)
	if err != nil {
		return fmt.Errorf("failed to parse template: %w", err)
	}

	e.templates[name] = tmpl
	return nil
}

// ProcessPrompt processes a prompt with the given context
func (e *PromptEngine) ProcessPrompt(prompt string, context []byte) (string, error) {
	// If no context is provided, return the prompt as is
	if len(context) == 0 {
		return prompt, nil
	}

	// Process the prompt with the context
	return e.addContextToPrompt(prompt, context)
}

// ProcessMessages processes chat messages with the given context
func (e *PromptEngine) ProcessMessages(messages []ai.Message, context []byte) ([]ai.Message, error) {
	// If no context is provided, return the messages as is
	if len(context) == 0 {
		return messages, nil
	}

	// Process each message with the context
	processedMessages := make([]ai.Message, len(messages))
	for i, msg := range messages {
		if msg.Role == "system" {
			// Add context to system messages
			processedContent, err := e.addContextToPrompt(msg.Content, context)
			if err != nil {
				return nil, fmt.Errorf("failed to process system message: %w", err)
			}
			processedMessages[i] = ai.Message{
				Role:    msg.Role,
				Content: processedContent,
			}
		} else {
			// Leave other messages unchanged
			processedMessages[i] = msg
		}
	}

	return processedMessages, nil
}

// ExecuteTemplate executes a template with the given data
func (e *PromptEngine) ExecuteTemplate(name string, data interface{}) (string, error) {
	tmpl, ok := e.templates[name]
	if !ok {
		return "", fmt.Errorf("template not found: %s", name)
	}

	var buf bytes.Buffer
	if err := tmpl.Execute(&buf, data); err != nil {
		return "", fmt.Errorf("failed to execute template: %w", err)
	}

	return buf.String(), nil
}

// addContextToPrompt adds context to a prompt
func (e *PromptEngine) addContextToPrompt(prompt string, context []byte) (string, error) {
	// Simple concatenation for now
	// In a more advanced implementation, this would parse the context and
	// intelligently integrate it with the prompt
	contextStr := string(context)
	
	// Limit context size to avoid token limits
	if len(contextStr) > 4000 {
		contextStr = contextStr[:4000] + "...[truncated]"
	}
	
	return fmt.Sprintf("Context:\n%s\n\nPrompt:\n%s", contextStr, prompt), nil
}

// DefaultTemplates returns a map of default templates
func DefaultTemplates() map[string]PromptTemplate {
	return map[string]PromptTemplate{
		"code_completion": {
			Name:        "Code Completion",
			Description: "Template for code completion",
			Template: `You are an AI coding assistant. Complete the following code:

{{.Code}}

`,
			Variables: map[string]string{
				"Code": "The code to complete",
			},
		},
		"code_explanation": {
			Name:        "Code Explanation",
			Description: "Template for explaining code",
			Template: `You are an AI coding assistant. Explain the following code:

{{.Code}}

`,
			Variables: map[string]string{
				"Code": "The code to explain",
			},
		},
		"error_diagnosis": {
			Name:        "Error Diagnosis",
			Description: "Template for diagnosing errors",
			Template: `You are an AI coding assistant. Diagnose the following error:

Error: {{.Error}}

Code:
{{.Code}}

`,
			Variables: map[string]string{
				"Error": "The error message",
				"Code":  "The code that produced the error",
			},
		},
		"git_help": {
			Name:        "Git Help",
			Description: "Template for Git help",
			Template: `You are an AI assistant for Git. Help with the following Git task:

{{.Query}}

Current branch: {{.CurrentBranch}}
Git status:
{{.GitStatus}}

`,
			Variables: map[string]string{
				"Query":         "The user's query",
				"CurrentBranch": "The current Git branch",
				"GitStatus":     "The output of git status",
			},
		},
		"project_context": {
			Name:        "Project Context",
			Description: "Template for providing project context",
			Template: `You are an AI assistant for development. You have the following context about the project:

Project: {{.ProjectName}}
{{if .Description}}Description: {{.Description}}{{end}}
{{if .TechStacks}}Tech Stacks: {{range .TechStacks}}{{.Name}} ({{.Confidence}}%), {{end}}{{end}}
{{if .Dependencies}}Dependencies: {{range $key, $value := .Dependencies}}{{$key}}@{{$value}}, {{end}}{{end}}
{{if .GitInfo}}Git: {{.GitInfo.RemoteURL}}, Branch: {{.GitInfo.CurrentBranch}}{{end}}

User query: {{.Query}}

`,
			Variables: map[string]string{
				"ProjectName":  "The name of the project",
				"Description":  "The project description",
				"TechStacks":   "The detected tech stacks",
				"Dependencies": "The project dependencies",
				"GitInfo":      "Git repository information",
				"Query":        "The user's query",
			},
		},
		"command_suggestion": {
			Name:        "Command Suggestion",
			Description: "Template for suggesting commands",
			Template: `You are an AI assistant for the terminal. Suggest commands for the following task:

{{.Query}}

Current directory: {{.CurrentDir}}
{{if .FileList}}Files in directory:
{{.FileList}}{{end}}

`,
			Variables: map[string]string{
				"Query":      "The user's query",
				"CurrentDir": "The current directory",
				"FileList":   "List of files in the directory",
			},
		},
	}
}

// LoadDefaultTemplates loads the default templates into the prompt engine
func (e *PromptEngine) LoadDefaultTemplates() error {
	templates := DefaultTemplates()
	for name, tmpl := range templates {
		if err := e.RegisterTemplate(name, tmpl.Template); err != nil {
			return fmt.Errorf("failed to register template %s: %w", name, err)
		}
	}
	return nil
}

// FormatContextData formats context data for inclusion in prompts
func FormatContextData(data ContextData) string {
	var sb strings.Builder

	// Project info
	if len(data.ProjectInfo) > 0 {
		sb.WriteString("## Project Info\n")
		for k, v := range data.ProjectInfo {
			sb.WriteString(fmt.Sprintf("%s: %v\n", k, v))
		}
		sb.WriteString("\n")
	}

	// Git info
	if len(data.GitInfo) > 0 {
		sb.WriteString("## Git Info\n")
		for k, v := range data.GitInfo {
			sb.WriteString(fmt.Sprintf("%s: %v\n", k, v))
		}
		sb.WriteString("\n")
	}

	// Tech stacks
	if len(data.TechStacks) > 0 {
		sb.WriteString("## Tech Stacks\n")
		for _, stack := range data.TechStacks {
			name, _ := stack["name"].(string)
			confidence, _ := stack["confidence"].(float64)
			sb.WriteString(fmt.Sprintf("- %s (%.1f%%)\n", name, confidence))
		}
		sb.WriteString("\n")
	}

	// File stats
	if len(data.FileStats) > 0 {
		sb.WriteString("## File Stats\n")
		for k, v := range data.FileStats {
			sb.WriteString(fmt.Sprintf("%s: %v\n", k, v))
		}
		sb.WriteString("\n")
	}

	// Dependencies
	if len(data.Dependencies) > 0 {
		sb.WriteString("## Dependencies\n")
		for k, v := range data.Dependencies {
			sb.WriteString(fmt.Sprintf("- %s: %v\n", k, v))
		}
		sb.WriteString("\n")
	}

	// Current context
	if data.CurrentFile != "" || data.CurrentBranch != "" || data.CurrentDir != "" {
		sb.WriteString("## Current Context\n")
		if data.CurrentFile != "" {
			sb.WriteString(fmt.Sprintf("File: %s\n", data.CurrentFile))
		}
		if data.CurrentBranch != "" {
			sb.WriteString(fmt.Sprintf("Branch: %s\n", data.CurrentBranch))
		}
		if data.CurrentDir != "" {
			sb.WriteString(fmt.Sprintf("Directory: %s\n", data.CurrentDir))
		}
		sb.WriteString("\n")
	}

	return sb.String()
}
