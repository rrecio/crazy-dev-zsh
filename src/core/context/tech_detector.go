package context

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
)

// TechStackDetector detects technology stacks in a project
type TechStackDetector interface {
	// DetectTechStacks detects technology stacks in a project
	DetectTechStacks(path string, fileStats FileStats) ([]TechStack, error)
	
	// ExtractDependencies extracts dependencies for a specific tech stack
	ExtractDependencies(path string, tech TechStack) (map[string]string, error)
}

// TechStackDetectorImpl implements the TechStackDetector interface
type TechStackDetectorImpl struct {
	techSignatures map[string][]TechSignature
}

// TechSignature defines a signature for detecting a technology
type TechSignature struct {
	Type           string
	FilePatterns   []string
	ContentPattern string
	Framework      string
	Weight         float64
}

// NewTechStackDetector creates a new tech stack detector
func NewTechStackDetector() TechStackDetector {
	detector := &TechStackDetectorImpl{
		techSignatures: make(map[string][]TechSignature),
	}
	
	// Initialize tech signatures
	detector.initSignatures()
	
	return detector
}

// initSignatures initializes the technology signatures
func (td *TechStackDetectorImpl) initSignatures() {
	// Go signatures
	td.techSignatures["Go"] = []TechSignature{
		{
			Type:         "language",
			FilePatterns: []string{"go.mod", "go.sum"},
			Weight:       0.9,
		},
		{
			Type:           "language",
			FilePatterns:   []string{"*.go"},
			ContentPattern: "package\\s+\\w+",
			Weight:         0.7,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"go.mod"},
			ContentPattern: "github.com/gin-gonic/gin",
			Framework:    "Gin",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"go.mod"},
			ContentPattern: "github.com/gorilla/mux",
			Framework:    "Gorilla",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"go.mod"},
			ContentPattern: "github.com/labstack/echo",
			Framework:    "Echo",
			Weight:       0.8,
		},
	}
	
	// JavaScript/TypeScript signatures
	td.techSignatures["JavaScript"] = []TechSignature{
		{
			Type:         "language",
			FilePatterns: []string{"package.json", "package-lock.json", "yarn.lock", "pnpm-lock.yaml"},
			Weight:       0.9,
		},
		{
			Type:         "language",
			FilePatterns: []string{"*.js", "*.jsx", "*.ts", "*.tsx"},
			Weight:       0.7,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"package.json"},
			ContentPattern: "\"react\":",
			Framework:    "React",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"package.json"},
			ContentPattern: "\"vue\":",
			Framework:    "Vue",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"package.json"},
			ContentPattern: "\"angular\":",
			Framework:    "Angular",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"package.json"},
			ContentPattern: "\"next\":",
			Framework:    "Next.js",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"package.json"},
			ContentPattern: "\"nuxt\":",
			Framework:    "Nuxt.js",
			Weight:       0.8,
		},
	}
	
	// Python signatures
	td.techSignatures["Python"] = []TechSignature{
		{
			Type:         "language",
			FilePatterns: []string{"requirements.txt", "setup.py", "pyproject.toml", "Pipfile", "Pipfile.lock"},
			Weight:       0.9,
		},
		{
			Type:         "language",
			FilePatterns: []string{"*.py"},
			Weight:       0.7,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"requirements.txt", "setup.py", "pyproject.toml"},
			ContentPattern: "django",
			Framework:    "Django",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"requirements.txt", "setup.py", "pyproject.toml"},
			ContentPattern: "flask",
			Framework:    "Flask",
			Weight:       0.8,
		},
		{
			Type:         "framework",
			FilePatterns: []string{"requirements.txt", "setup.py", "pyproject.toml"},
			ContentPattern: "fastapi",
			Framework:    "FastAPI",
			Weight:       0.8,
		},
	}
	
	// Flutter signatures
	td.techSignatures["Flutter"] = []TechSignature{
		{
			Type:         "language",
			FilePatterns: []string{"pubspec.yaml", "pubspec.lock"},
			Weight:       0.9,
		},
		{
			Type:         "language",
			FilePatterns: []string{"*.dart"},
			ContentPattern: "import 'package:flutter",
			Weight:       0.8,
		},
	}
	
	// Docker signatures
	td.techSignatures["Docker"] = []TechSignature{
		{
			Type:         "tool",
			FilePatterns: []string{"Dockerfile", "docker-compose.yml", "docker-compose.yaml"},
			Weight:       0.9,
		},
		{
			Type:         "tool",
			FilePatterns: []string{".dockerignore"},
			Weight:       0.7,
		},
	}
	
	// Kubernetes signatures
	td.techSignatures["Kubernetes"] = []TechSignature{
		{
			Type:         "tool",
			FilePatterns: []string{"*.yaml", "*.yml"},
			ContentPattern: "apiVersion:\\s+v\\d+|kind:\\s+Deployment|kind:\\s+Service|kind:\\s+Pod",
			Weight:       0.8,
		},
		{
			Type:         "tool",
			FilePatterns: []string{"kustomization.yaml", "kustomization.yml"},
			Weight:       0.9,
		},
	}
}

// DetectTechStacks detects technology stacks in a project
func (td *TechStackDetectorImpl) DetectTechStacks(path string, fileStats FileStats) ([]TechStack, error) {
	techScores := make(map[string]float64)
	techFiles := make(map[string][]string)
	techFrameworks := make(map[string]string)
	
	// Check for tech signatures in the file stats
	for ext, count := range fileStats.FilesByType {
		// Check file extensions
		switch ext {
		case ".go":
			techScores["Go"] += float64(count) * 0.1
			techFiles["Go"] = append(techFiles["Go"], fmt.Sprintf("%d Go files", count))
		case ".js", ".jsx":
			techScores["JavaScript"] += float64(count) * 0.1
			techFiles["JavaScript"] = append(techFiles["JavaScript"], fmt.Sprintf("%d JavaScript files", count))
		case ".ts", ".tsx":
			techScores["TypeScript"] += float64(count) * 0.1
			techFiles["TypeScript"] = append(techFiles["TypeScript"], fmt.Sprintf("%d TypeScript files", count))
		case ".py":
			techScores["Python"] += float64(count) * 0.1
			techFiles["Python"] = append(techFiles["Python"], fmt.Sprintf("%d Python files", count))
		case ".dart":
			techScores["Flutter"] += float64(count) * 0.1
			techFiles["Flutter"] = append(techFiles["Flutter"], fmt.Sprintf("%d Dart files", count))
		}
	}
	
	// Check for specific files that indicate tech stacks
	err := filepath.Walk(path, func(filePath string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // Skip files that can't be accessed
		}
		
		// Skip directories
		if info.IsDir() {
			// Skip common directories to ignore
			dirName := info.Name()
			if dirName == ".git" || dirName == "node_modules" || dirName == "vendor" {
				return filepath.SkipDir
			}
			return nil
		}
		
		fileName := info.Name()
		
		// Check for specific files
		for tech, signatures := range td.techSignatures {
			for _, sig := range signatures {
				for _, pattern := range sig.FilePatterns {
					matched, err := filepath.Match(pattern, fileName)
					if err != nil {
						continue
					}
					
					if matched {
						// Check content pattern if specified
						if sig.ContentPattern != "" {
							// Only read files smaller than 1MB to avoid performance issues
							if info.Size() > 1024*1024 {
								continue
							}
							
							content, err := ioutil.ReadFile(filePath)
							if err != nil {
								continue
							}
							
							re, err := regexp.Compile(sig.ContentPattern)
							if err != nil {
								continue
							}
							
							if !re.Match(content) {
								continue
							}
						}
						
						techScores[tech] += sig.Weight
						relPath, _ := filepath.Rel(path, filePath)
						techFiles[tech] = append(techFiles[tech], relPath)
						
						// Record framework if detected
						if sig.Framework != "" {
							techFrameworks[tech] = sig.Framework
						}
						
						break
					}
				}
			}
		}
		
		return nil
	})
	
	if err != nil {
		return nil, fmt.Errorf("error walking directory: %w", err)
	}
	
	// Convert scores to tech stacks
	var techStacks []TechStack
	for tech, score := range techScores {
		// Only include tech stacks with a score above 0.5
		if score > 0.5 {
			techStack := TechStack{
				Name:           tech,
				Type:           "language", // Default type
				ConfidenceScore: score,
				DetectedFiles:  techFiles[tech],
			}
			
			// Set framework if detected
			if framework, ok := techFrameworks[tech]; ok {
				techStack.Framework = framework
			}
			
			techStacks = append(techStacks, techStack)
		}
	}
	
	// Sort tech stacks by confidence score (highest first)
	sort.Slice(techStacks, func(i, j int) bool {
		return techStacks[i].ConfidenceScore > techStacks[j].ConfidenceScore
	})
	
	return techStacks, nil
}

// ExtractDependencies extracts dependencies for a specific tech stack
func (td *TechStackDetectorImpl) ExtractDependencies(path string, tech TechStack) (map[string]string, error) {
	dependencies := make(map[string]string)
	
	switch tech.Name {
	case "Go":
		// Extract Go dependencies from go.mod
		goModPath := filepath.Join(path, "go.mod")
		if _, err := os.Stat(goModPath); err == nil {
			content, err := ioutil.ReadFile(goModPath)
			if err != nil {
				return dependencies, err
			}
			
			// Simple regex to extract dependencies
			re := regexp.MustCompile(`(?m)^\s*([a-zA-Z0-9_\.\-\/]+)\s+v([0-9\.\-\+]+)`)
			matches := re.FindAllStringSubmatch(string(content), -1)
			
			for _, match := range matches {
				if len(match) >= 3 {
					dependencies[match[1]] = match[2]
				}
			}
		}
		
	case "JavaScript", "TypeScript":
		// Extract JS/TS dependencies from package.json
		packagePath := filepath.Join(path, "package.json")
		if _, err := os.Stat(packagePath); err == nil {
			content, err := ioutil.ReadFile(packagePath)
			if err != nil {
				return dependencies, err
			}
			
			var packageJSON struct {
				Dependencies    map[string]string `json:"dependencies"`
				DevDependencies map[string]string `json:"devDependencies"`
			}
			
			if err := json.Unmarshal(content, &packageJSON); err != nil {
				return dependencies, err
			}
			
			// Add regular dependencies
			for name, version := range packageJSON.Dependencies {
				dependencies[name] = version
			}
			
			// Add dev dependencies
			for name, version := range packageJSON.DevDependencies {
				dependencies["dev:"+name] = version
			}
		}
		
	case "Python":
		// Extract Python dependencies from requirements.txt
		reqPath := filepath.Join(path, "requirements.txt")
		if _, err := os.Stat(reqPath); err == nil {
			content, err := ioutil.ReadFile(reqPath)
			if err != nil {
				return dependencies, err
			}
			
			lines := strings.Split(string(content), "\n")
			for _, line := range lines {
				line = strings.TrimSpace(line)
				if line == "" || strings.HasPrefix(line, "#") {
					continue
				}
				
				// Handle version specifiers
				parts := strings.Split(line, "==")
				if len(parts) >= 2 {
					dependencies[parts[0]] = parts[1]
				} else {
					parts = strings.Split(line, ">=")
					if len(parts) >= 2 {
						dependencies[parts[0]] = ">=" + parts[1]
					} else {
						dependencies[line] = "latest"
					}
				}
			}
		}
		
	case "Flutter":
		// Extract Flutter dependencies from pubspec.yaml
		pubspecPath := filepath.Join(path, "pubspec.yaml")
		if _, err := os.Stat(pubspecPath); err == nil {
			content, err := ioutil.ReadFile(pubspecPath)
			if err != nil {
				return dependencies, err
			}
			
			// Simple regex to extract dependencies
			re := regexp.MustCompile(`(?m)^\s{2}([a-zA-Z0-9_]+):\s*(\^?[0-9\.\+]+)`)
			matches := re.FindAllStringSubmatch(string(content), -1)
			
			for _, match := range matches {
				if len(match) >= 3 {
					dependencies[match[1]] = match[2]
				}
			}
		}
	}
	
	return dependencies, nil
}
