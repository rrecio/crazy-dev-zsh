package context

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// FileAnalyzer analyzes project files
type FileAnalyzer interface {
	// AnalyzeFiles analyzes files in a directory and returns statistics
	AnalyzeFiles(path string, maxFiles int, maxFileSize int64) (FileStats, error)
}

// FileAnalyzerImpl implements the FileAnalyzer interface
type FileAnalyzerImpl struct {
	ignoreDirs  []string
	ignoreFiles []string
}

// NewFileAnalyzer creates a new file analyzer
func NewFileAnalyzer() FileAnalyzer {
	return &FileAnalyzerImpl{
		ignoreDirs: []string{
			".git", "node_modules", "vendor", "dist", "build", ".idea", ".vscode",
			"__pycache__", "venv", "env", ".env", ".pytest_cache", ".next", "target",
		},
		ignoreFiles: []string{
			".DS_Store", "Thumbs.db", ".gitignore", ".gitattributes",
		},
	}
}

// AnalyzeFiles analyzes files in a directory and returns statistics
func (fa *FileAnalyzerImpl) AnalyzeFiles(path string, maxFiles int, maxFileSize int64) (FileStats, error) {
	stats := FileStats{
		FilesByType:   make(map[string]int),
		SizeByType:    make(map[string]int64),
		LargestFiles:  []FileInfo{},
		DirectoryTree: make(map[string]int),
	}

	fileCount := 0
	err := filepath.Walk(path, func(filePath string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // Skip files that can't be accessed
		}

		// Skip ignored directories
		if info.IsDir() {
			dirName := info.Name()
			for _, ignoreDir := range fa.ignoreDirs {
				if dirName == ignoreDir {
					return filepath.SkipDir
				}
			}
			
			// Count files in directory
			relPath, err := filepath.Rel(path, filePath)
			if err == nil && relPath != "." {
				stats.DirectoryTree[relPath] = 0
			}
			
			return nil
		}

		// Skip ignored files
		fileName := info.Name()
		for _, ignoreFile := range fa.ignoreFiles {
			if fileName == ignoreFile {
				return nil
			}
		}

		// Check if we've reached the maximum number of files to scan
		if fileCount >= maxFiles {
			return filepath.SkipDir
		}

		// Skip files that are too large
		if info.Size() > maxFileSize {
			return nil
		}

		fileCount++
		stats.TotalFiles++
		stats.TotalSize += info.Size()

		// Get file extension
		ext := strings.ToLower(filepath.Ext(filePath))
		if ext == "" {
			ext = "(no extension)"
		}

		// Update file type statistics
		stats.FilesByType[ext]++
		stats.SizeByType[ext] += info.Size()

		// Update directory count
		dirPath := filepath.Dir(filePath)
		relDirPath, err := filepath.Rel(path, dirPath)
		if err == nil && relDirPath != "." {
			stats.DirectoryTree[relDirPath]++
		}

		// Track largest files
		fileInfo := FileInfo{
			Path: filePath,
			Size: info.Size(),
			Type: ext,
		}
		
		// Keep track of the top 10 largest files
		if len(stats.LargestFiles) < 10 {
			stats.LargestFiles = append(stats.LargestFiles, fileInfo)
			// Sort by size in descending order
			sort.Slice(stats.LargestFiles, func(i, j int) bool {
				return stats.LargestFiles[i].Size > stats.LargestFiles[j].Size
			})
		} else if fileInfo.Size > stats.LargestFiles[len(stats.LargestFiles)-1].Size {
			// Replace the smallest file in the list if this one is larger
			stats.LargestFiles[len(stats.LargestFiles)-1] = fileInfo
			// Re-sort
			sort.Slice(stats.LargestFiles, func(i, j int) bool {
				return stats.LargestFiles[i].Size > stats.LargestFiles[j].Size
			})
		}

		return nil
	})

	if err != nil {
		return stats, fmt.Errorf("error walking directory: %w", err)
	}

	return stats, nil
}
