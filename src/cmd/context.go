package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"

	"github.com/rrecio/crazy-dev-zsh/src/core/context"
)

// contextCmd represents the context command
var contextCmd = &cobra.Command{
	Use:   "context",
	Short: "Analyze and manage project context",
	Long: `Analyze and manage project context.
This command helps you understand your project structure, dependencies, and technology stack.

Examples:
  # Analyze the current directory
  crazy-dev context

  # Analyze a specific directory
  crazy-dev context --path /path/to/project

  # Force a refresh of the analysis
  crazy-dev context --refresh

  # Output in JSON format
  crazy-dev context --output json`,
	Run: func(cmd *cobra.Command, args []string) {
		// Get flags
		path, _ := cmd.Flags().GetString("path")
		refresh, _ := cmd.Flags().GetBool("refresh")
		outputFormat, _ := cmd.Flags().GetString("output")
		verbose, _ := cmd.Flags().GetBool("verbose")

		// Get configuration
		maxFiles := viper.GetInt("core.context.maxFiles")
		if maxFiles <= 0 {
			maxFiles = 10000 // Default value
		}
		
		maxFileSize := viper.GetInt64("core.context.maxFileSize")
		if maxFileSize <= 0 {
			maxFileSize = 1024 * 1024 // Default: 1MB
		}

		// Create context analyzer
		analyzer := context.NewContextAnalyzer(maxFiles, maxFileSize)
		
		// Start analysis
		var result *context.AnalysisResult
		var err error
		
		if refresh {
			if verbose {
				fmt.Println("Refreshing context analysis...")
			}
			result, err = analyzer.RefreshAnalysis(path)
		} else {
			if verbose {
				fmt.Println("Analyzing project context...")
			}
			result, err = analyzer.Analyze(path)
		}
		
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error analyzing context: %v\n", err)
			os.Exit(1)
		}
		
		// Output the result
		switch outputFormat {
		case "json":
			// Output as JSON
			jsonData, err := json.MarshalIndent(result, "", "  ")
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error marshaling to JSON: %v\n", err)
				os.Exit(1)
			}
			fmt.Println(string(jsonData))
			
		default:
			// Output as human-readable text
			printAnalysisResult(result, verbose)
		}
	},
}

// printAnalysisResult prints the analysis result in a human-readable format
func printAnalysisResult(result *context.AnalysisResult, verbose bool) {
	fmt.Printf("Project: %s\n", result.ProjectName)
	fmt.Printf("Path: %s\n", result.ProjectPath)
	fmt.Printf("Analyzed at: %s\n", result.AnalyzedAt.Format(time.RFC1123))
	fmt.Printf("Analysis duration: %v\n", result.AnalysisDuration.Round(time.Millisecond))
	fmt.Println()
	
	// Git information
	fmt.Println("Git Repository:")
	if result.IsGitRepo {
		fmt.Printf("  Remote URL: %s\n", result.GitInfo.RemoteURL)
		fmt.Printf("  Current Branch: %s\n", result.GitInfo.CurrentBranch)
		fmt.Printf("  Default Branch: %s\n", result.GitInfo.DefaultBranch)
		fmt.Printf("  Last Commit: %s\n", result.GitInfo.LastCommit)
		
		if verbose && len(result.GitInfo.Contributors) > 0 {
			fmt.Println("  Contributors:")
			for _, contributor := range result.GitInfo.Contributors {
				fmt.Printf("    - %s\n", contributor)
			}
		}
	} else {
		fmt.Println("  Not a Git repository")
	}
	fmt.Println()
	
	// Tech stacks
	fmt.Println("Detected Tech Stacks:")
	if len(result.TechStacks) > 0 {
		for _, tech := range result.TechStacks {
			fmt.Printf("  - %s", tech.Name)
			if tech.Framework != "" {
				fmt.Printf(" (%s)", tech.Framework)
			}
			fmt.Printf(" [Confidence: %.2f]\n", tech.ConfidenceScore)
			
			if verbose && len(tech.DetectedFiles) > 0 {
				fmt.Println("    Detected files:")
				for i, file := range tech.DetectedFiles {
					if i >= 5 && !verbose {
						fmt.Println("    ... and more")
						break
					}
					fmt.Printf("    - %s\n", file)
				}
			}
		}
	} else {
		fmt.Println("  No tech stacks detected")
	}
	fmt.Println()
	
	// File statistics
	fmt.Println("File Statistics:")
	fmt.Printf("  Total Files: %d\n", result.FileStats.TotalFiles)
	fmt.Printf("  Total Size: %.2f MB\n", float64(result.FileStats.TotalSize)/(1024*1024))
	
	fmt.Println("  Files by Type:")
	for ext, count := range result.FileStats.FilesByType {
		if count > 0 {
			fmt.Printf("    %s: %d\n", ext, count)
		}
	}
	
	if verbose {
		fmt.Println("  Largest Files:")
		for i, file := range result.FileStats.LargestFiles {
			if i >= 5 && !verbose {
				break
			}
			fmt.Printf("    - %s (%.2f MB)\n", file.Path, float64(file.Size)/(1024*1024))
		}
	}
	fmt.Println()
	
	// Dependencies
	if len(result.Dependencies) > 0 {
		fmt.Println("Dependencies:")
		count := 0
		for name, version := range result.Dependencies {
			if count >= 10 && !verbose {
				fmt.Println("  ... and more")
				break
			}
			fmt.Printf("  %s: %s\n", name, version)
			count++
		}
	}
}

// contextAnalyzeCmd represents the analyze command
var contextAnalyzeCmd = &cobra.Command{
	Use:   "analyze [path]",
	Short: "Analyze project context",
	Long: `Analyze project context to understand structure and dependencies.
If no path is provided, the current directory will be analyzed.`,
	Run: func(cmd *cobra.Command, args []string) {
		// This is just an alias for the parent command
		contextCmd.Run(cmd, args)
	},
}

func init() {
	rootCmd.AddCommand(contextCmd)
	
	// Add subcommands
	contextCmd.AddCommand(contextAnalyzeCmd)

	// Flags for the context command
	contextCmd.Flags().BoolP("scan", "s", false, "Scan the current directory for project context")
	contextCmd.Flags().BoolP("refresh", "r", false, "Refresh the cached context")
	contextCmd.Flags().StringP("path", "p", ".", "Path to analyze")
}
