package context

import (
	"fmt"
	"os"
	"path/filepath"
	"time"
)

// AnalysisResult represents the result of a project context analysis
type AnalysisResult struct {
	ProjectPath    string            `json:"project_path"`
	ProjectName    string            `json:"project_name"`
	IsGitRepo      bool              `json:"is_git_repo"`
	GitInfo        GitInfo           `json:"git_info,omitempty"`
	TechStacks     []TechStack       `json:"tech_stacks"`
	FileStats      FileStats         `json:"file_stats"`
	Dependencies   map[string]string `json:"dependencies"`
	AnalyzedAt     time.Time         `json:"analyzed_at"`
	AnalysisDuration time.Duration   `json:"analysis_duration"`
}

// GitInfo contains information about the Git repository
type GitInfo struct {
	RemoteURL     string   `json:"remote_url,omitempty"`
	DefaultBranch string   `json:"default_branch,omitempty"`
	CurrentBranch string   `json:"current_branch,omitempty"`
	LastCommit    string   `json:"last_commit,omitempty"`
	Contributors  []string `json:"contributors,omitempty"`
}

// TechStack represents a detected technology stack
type TechStack struct {
	Name           string   `json:"name"`
	Type           string   `json:"type"`
	ConfidenceScore float64 `json:"confidence_score"`
	DetectedFiles  []string `json:"detected_files,omitempty"`
	Framework      string   `json:"framework,omitempty"`
	Version        string   `json:"version,omitempty"`
}

// FileStats contains statistics about the project files
type FileStats struct {
	TotalFiles      int               `json:"total_files"`
	TotalSize       int64             `json:"total_size"`
	FilesByType     map[string]int    `json:"files_by_type"`
	SizeByType      map[string]int64  `json:"size_by_type"`
	LargestFiles    []FileInfo        `json:"largest_files"`
	DirectoryTree   map[string]int    `json:"directory_tree"`
}

// FileInfo contains information about a file
type FileInfo struct {
	Path string `json:"path"`
	Size int64  `json:"size"`
	Type string `json:"type"`
}

// Analyzer is the interface for project context analysis
type Analyzer interface {
	// Analyze analyzes a project directory and returns the analysis result
	Analyze(path string) (*AnalysisResult, error)
	
	// GetCachedAnalysis returns a cached analysis result if available
	GetCachedAnalysis(path string) (*AnalysisResult, bool)
	
	// RefreshAnalysis forces a refresh of the analysis
	RefreshAnalysis(path string) (*AnalysisResult, error)
}

// ContextAnalyzer implements the Analyzer interface
type ContextAnalyzer struct {
	gitAnalyzer     GitAnalyzer
	techDetector    TechStackDetector
	fileAnalyzer    FileAnalyzer
	cacheManager    CacheManager
	maxFilesToScan  int
	maxFileSize     int64
}

// NewContextAnalyzer creates a new context analyzer
func NewContextAnalyzer(maxFiles int, maxFileSize int64) *ContextAnalyzer {
	return &ContextAnalyzer{
		gitAnalyzer:    NewGitAnalyzer(),
		techDetector:   NewTechStackDetector(),
		fileAnalyzer:   NewFileAnalyzer(),
		cacheManager:   NewCacheManager(),
		maxFilesToScan: maxFiles,
		maxFileSize:    maxFileSize,
	}
}

// Analyze analyzes a project directory and returns the analysis result
func (ca *ContextAnalyzer) Analyze(path string) (*AnalysisResult, error) {
	// Check if we have a cached result
	if cached, found := ca.GetCachedAnalysis(path); found {
		return cached, nil
	}
	
	// Start timing the analysis
	startTime := time.Now()
	
	// Resolve the absolute path
	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil, fmt.Errorf("failed to resolve absolute path: %w", err)
	}
	
	// Check if the path exists
	if _, err := os.Stat(absPath); os.IsNotExist(err) {
		return nil, fmt.Errorf("path does not exist: %s", absPath)
	}
	
	// Initialize the result
	result := &AnalysisResult{
		ProjectPath: absPath,
		ProjectName: filepath.Base(absPath),
		TechStacks:  []TechStack{},
		Dependencies: make(map[string]string),
		AnalyzedAt:  time.Now(),
	}
	
	// Analyze Git repository
	gitInfo, isGitRepo, err := ca.gitAnalyzer.AnalyzeRepository(absPath)
	if err != nil {
		// Non-fatal error, continue with analysis
		fmt.Fprintf(os.Stderr, "Warning: Git analysis error: %v\n", err)
	}
	result.IsGitRepo = isGitRepo
	if isGitRepo {
		result.GitInfo = gitInfo
	}
	
	// Analyze files
	fileStats, err := ca.fileAnalyzer.AnalyzeFiles(absPath, ca.maxFilesToScan, ca.maxFileSize)
	if err != nil {
		return nil, fmt.Errorf("file analysis error: %w", err)
	}
	result.FileStats = fileStats
	
	// Detect tech stacks
	techStacks, err := ca.techDetector.DetectTechStacks(absPath, fileStats)
	if err != nil {
		return nil, fmt.Errorf("tech stack detection error: %w", err)
	}
	result.TechStacks = techStacks
	
	// Extract dependencies based on detected tech stacks
	for _, tech := range techStacks {
		deps, err := ca.techDetector.ExtractDependencies(absPath, tech)
		if err != nil {
			// Non-fatal error, continue with analysis
			fmt.Fprintf(os.Stderr, "Warning: Dependency extraction error for %s: %v\n", tech.Name, err)
			continue
		}
		
		// Merge dependencies
		for k, v := range deps {
			result.Dependencies[k] = v
		}
	}
	
	// Calculate analysis duration
	result.AnalysisDuration = time.Since(startTime)
	
	// Cache the result
	ca.cacheManager.StoreAnalysis(absPath, result)
	
	return result, nil
}

// GetCachedAnalysis returns a cached analysis result if available
func (ca *ContextAnalyzer) GetCachedAnalysis(path string) (*AnalysisResult, bool) {
	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil, false
	}
	
	return ca.cacheManager.GetAnalysis(absPath)
}

// RefreshAnalysis forces a refresh of the analysis
func (ca *ContextAnalyzer) RefreshAnalysis(path string) (*AnalysisResult, error) {
	absPath, err := filepath.Abs(path)
	if err != nil {
		return nil, fmt.Errorf("failed to resolve absolute path: %w", err)
	}
	
	// Remove from cache
	ca.cacheManager.InvalidateAnalysis(absPath)
	
	// Re-analyze
	return ca.Analyze(absPath)
}
