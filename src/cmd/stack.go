package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// stackCmd represents the stack command
var stackCmd = &cobra.Command{
	Use:   "stack",
	Short: "Manage technology stacks",
	Long: `The stack command allows you to manage technology stacks.
You can list, install, and configure technology stacks for your projects.

Examples:
  # List available stacks
  crazy stack list

  # Install a stack
  crazy stack install go

  # Get information about a stack
  crazy stack info go`,
	Run: runStackCommand,
}

// stackListCmd represents the stack list subcommand
var stackListCmd = &cobra.Command{
	Use:   "list",
	Short: "List available technology stacks",
	Long:  `List all available technology stacks.`,
	Run:   runStackListCommand,
}

// stackInstallCmd represents the stack install subcommand
var stackInstallCmd = &cobra.Command{
	Use:   "install [stack]",
	Short: "Install a technology stack",
	Long:  `Install a technology stack for use in your projects.`,
	Args:  cobra.ExactArgs(1),
	Run:   runStackInstallCommand,
}

// stackInfoCmd represents the stack info subcommand
var stackInfoCmd = &cobra.Command{
	Use:   "info [stack]",
	Short: "Get information about a technology stack",
	Long:  `Get detailed information about a technology stack.`,
	Args:  cobra.ExactArgs(1),
	Run:   runStackInfoCommand,
}

func init() {
	rootCmd.AddCommand(stackCmd)
	
	// Add subcommands
	stackCmd.AddCommand(stackListCmd)
	stackCmd.AddCommand(stackInstallCmd)
	stackCmd.AddCommand(stackInfoCmd)
	
	// Flags for the stack list command
	stackListCmd.Flags().BoolP("installed", "i", false, "Show only installed stacks")
	stackListCmd.Flags().StringP("category", "c", "", "Filter stacks by category")
	
	// Flags for the stack install command
	stackInstallCmd.Flags().BoolP("global", "g", false, "Install stack globally")
	stackInstallCmd.Flags().StringP("version", "v", "latest", "Version to install")
}

// runStackCommand executes the stack command
func runStackCommand(cmd *cobra.Command, args []string) {
	// If no subcommand is provided, print help
	cmd.Help()
}

// runStackListCommand executes the stack list subcommand
func runStackListCommand(cmd *cobra.Command, args []string) {
	installedOnly, _ := cmd.Flags().GetBool("installed")
	category, _ := cmd.Flags().GetString("category")
	
	// Get stacks directory from configuration
	stacksDir := viper.GetString("core.stacks_dir")
	if stacksDir == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting home directory: %v\n", err)
			os.Exit(1)
		}
		stacksDir = filepath.Join(home, ".crazy-dev", "stacks")
	}
	
	// Define available stacks (in a real implementation, this would come from a registry)
	stacks := []struct {
		Name        string
		Description string
		Category    string
		Installed   bool
	}{
		{"go", "Go programming language stack", "backend", true},
		{"nodejs", "Node.js stack with TypeScript support", "fullstack", true},
		{"python", "Python stack with virtual environments", "backend", false},
		{"react", "React frontend framework", "frontend", false},
		{"vue", "Vue.js frontend framework", "frontend", false},
		{"django", "Django web framework", "backend", false},
		{"flask", "Flask micro web framework", "backend", false},
		{"postgres", "PostgreSQL database", "database", true},
		{"mongodb", "MongoDB NoSQL database", "database", false},
		{"docker", "Docker containerization", "devops", true},
		{"kubernetes", "Kubernetes container orchestration", "devops", false},
	}
	
	// Filter stacks based on flags
	filteredStacks := make([]struct {
		Name        string
		Description string
		Category    string
		Installed   bool
	}, 0)
	
	for _, stack := range stacks {
		if installedOnly && !stack.Installed {
			continue
		}
		
		if category != "" && stack.Category != category {
			continue
		}
		
		filteredStacks = append(filteredStacks, stack)
	}
	
	// Print stacks
	if len(filteredStacks) == 0 {
		fmt.Println("No stacks found matching your criteria")
		return
	}
	
	fmt.Println("Available technology stacks:")
	
	// Group stacks by category
	categories := make(map[string][]struct {
		Name        string
		Description string
		Category    string
		Installed   bool
	})
	
	for _, stack := range filteredStacks {
		categories[stack.Category] = append(categories[stack.Category], stack)
	}
	
	// Print stacks by category
	for category, stacks := range categories {
		fmt.Printf("\n%s:\n", category)
		for _, stack := range stacks {
			status := ""
			if stack.Installed {
				status = " [installed]"
			}
			fmt.Printf("  - %s: %s%s\n", stack.Name, stack.Description, status)
		}
	}
}

// runStackInstallCommand executes the stack install subcommand
func runStackInstallCommand(cmd *cobra.Command, args []string) {
	stackName := args[0]
	global, _ := cmd.Flags().GetBool("global")
	version, _ := cmd.Flags().GetString("version")
	
	// In a real implementation, this would install the stack
	// For now, just print a message
	scope := "project"
	if global {
		scope = "global"
	}
	
	fmt.Printf("Installing %s stack version %s (%s scope)...\n", stackName, version, scope)
	fmt.Println("Stack installation not yet implemented")
	fmt.Println("This will be part of STACK-001: Technology Stack Management")
}

// runStackInfoCommand executes the stack info subcommand
func runStackInfoCommand(cmd *cobra.Command, args []string) {
	stackName := args[0]
	
	// Define stack information (in a real implementation, this would come from a registry)
	stacks := map[string]struct {
		Name        string
		Description string
		Category    string
		Versions    []string
		Website     string
		Docs        string
	}{
		"go": {
			Name:        "Go",
			Description: "Go programming language stack",
			Category:    "backend",
			Versions:    []string{"1.20", "1.19", "1.18", "1.17"},
			Website:     "https://golang.org",
			Docs:        "https://golang.org/doc",
		},
		"nodejs": {
			Name:        "Node.js",
			Description: "Node.js stack with TypeScript support",
			Category:    "fullstack",
			Versions:    []string{"18.16.0", "16.20.0", "14.21.3"},
			Website:     "https://nodejs.org",
			Docs:        "https://nodejs.org/docs",
		},
	}
	
	// Check if stack exists
	stack, ok := stacks[stackName]
	if !ok {
		fmt.Fprintf(os.Stderr, "Stack '%s' not found\n", stackName)
		os.Exit(1)
	}
	
	// Print stack information
	fmt.Printf("Stack: %s\n", stack.Name)
	fmt.Printf("Description: %s\n", stack.Description)
	fmt.Printf("Category: %s\n", stack.Category)
	fmt.Printf("Website: %s\n", stack.Website)
	fmt.Printf("Documentation: %s\n", stack.Docs)
	
	fmt.Println("\nAvailable versions:")
	for _, version := range stack.Versions {
		fmt.Printf("  - %s\n", version)
	}
}
