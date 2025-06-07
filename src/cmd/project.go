package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// projectCmd represents the project command
var projectCmd = &cobra.Command{
	Use:   "project",
	Short: "Manage Crazy Dev projects",
	Long: `The project command allows you to manage Crazy Dev projects.
You can create, list, and switch between projects.

Examples:
  # Create a new project
  crazy project create my-project

  # List all projects
  crazy project list

  # Switch to a project
  crazy project use my-project`,
	Run: runProjectCommand,
}

// projectCreateCmd represents the project create subcommand
var projectCreateCmd = &cobra.Command{
	Use:   "create [name]",
	Short: "Create a new project",
	Long:  `Create a new Crazy Dev project with the specified name.`,
	Args:  cobra.ExactArgs(1),
	Run:   runProjectCreateCommand,
}

// projectListCmd represents the project list subcommand
var projectListCmd = &cobra.Command{
	Use:   "list",
	Short: "List all projects",
	Long:  `List all Crazy Dev projects.`,
	Run:   runProjectListCommand,
}

// projectUseCmd represents the project use subcommand
var projectUseCmd = &cobra.Command{
	Use:   "use [name]",
	Short: "Switch to a project",
	Long:  `Switch to the specified Crazy Dev project.`,
	Args:  cobra.ExactArgs(1),
	Run:   runProjectUseCommand,
}

func init() {
	rootCmd.AddCommand(projectCmd)
	
	// Add subcommands
	projectCmd.AddCommand(projectCreateCmd)
	projectCmd.AddCommand(projectListCmd)
	projectCmd.AddCommand(projectUseCmd)
	
	// Flags for the project create command
	projectCreateCmd.Flags().StringP("template", "t", "default", "Project template to use")
	projectCreateCmd.Flags().StringP("path", "p", "", "Path where to create the project")
	
	// Flags for the project list command
	projectListCmd.Flags().BoolP("all", "a", false, "Show all projects, including archived ones")
}

// runProjectCommand executes the project command
func runProjectCommand(cmd *cobra.Command, args []string) {
	// If no subcommand is provided, print help
	cmd.Help()
}

// runProjectCreateCommand executes the project create subcommand
func runProjectCreateCommand(cmd *cobra.Command, args []string) {
	projectName := args[0]
	template, _ := cmd.Flags().GetString("template")
	projectPath, _ := cmd.Flags().GetString("path")
	
	// If no path is provided, use the current directory
	if projectPath == "" {
		var err error
		projectPath, err = os.Getwd()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting current directory: %v\n", err)
			os.Exit(1)
		}
	}
	
	// Create project directory
	projectDir := filepath.Join(projectPath, projectName)
	if err := os.MkdirAll(projectDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating project directory: %v\n", err)
		os.Exit(1)
	}
	
	// Create project configuration file
	configFile := filepath.Join(projectDir, ".crazy-dev.yaml")
	f, err := os.Create(configFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating project configuration file: %v\n", err)
		os.Exit(1)
	}
	defer f.Close()
	
	// Write basic project configuration
	configContent := fmt.Sprintf(`# Crazy Dev Project Configuration
name: %s
created: %s
template: %s
`, projectName, viper.GetTime("now").Format("2006-01-02 15:04:05"), template)
	
	if _, err := f.WriteString(configContent); err != nil {
		fmt.Fprintf(os.Stderr, "Error writing project configuration: %v\n", err)
		os.Exit(1)
	}
	
	fmt.Printf("Project '%s' created successfully at %s\n", projectName, projectDir)
	fmt.Printf("Use 'cd %s' to navigate to your project\n", projectDir)
}

// runProjectListCommand executes the project list subcommand
func runProjectListCommand(cmd *cobra.Command, args []string) {
	showAll, _ := cmd.Flags().GetBool("all")
	
	// Get projects directory from configuration
	projectsDir := viper.GetString("core.projects_dir")
	if projectsDir == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting home directory: %v\n", err)
			os.Exit(1)
		}
		projectsDir = filepath.Join(home, ".crazy-dev", "projects")
	}
	
	// Check if projects directory exists
	if _, err := os.Stat(projectsDir); os.IsNotExist(err) {
		fmt.Println("No projects found")
		return
	}
	
	// List project directories
	projects, err := os.ReadDir(projectsDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading projects directory: %v\n", err)
		os.Exit(1)
	}
	
	if len(projects) == 0 {
		fmt.Println("No projects found")
		return
	}
	
	fmt.Println("Available projects:")
	for _, project := range projects {
		if project.IsDir() {
			// Check if project is archived
			isArchived := false
			archiveFile := filepath.Join(projectsDir, project.Name(), ".archived")
			if _, err := os.Stat(archiveFile); err == nil {
				isArchived = true
			}
			
			if !isArchived || showAll {
				status := ""
				if isArchived {
					status = " (archived)"
				}
				fmt.Printf("- %s%s\n", project.Name(), status)
			}
		}
	}
}

// runProjectUseCommand executes the project use subcommand
func runProjectUseCommand(cmd *cobra.Command, args []string) {
	projectName := args[0]
	
	// Get projects directory from configuration
	projectsDir := viper.GetString("core.projects_dir")
	if projectsDir == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting home directory: %v\n", err)
			os.Exit(1)
		}
		projectsDir = filepath.Join(home, ".crazy-dev", "projects")
	}
	
	// Check if project exists
	projectDir := filepath.Join(projectsDir, projectName)
	if _, err := os.Stat(projectDir); os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr, "Project '%s' not found\n", projectName)
		os.Exit(1)
	}
	
	// Set current project in configuration
	viper.Set("core.current_project", projectName)
	if err := viper.WriteConfig(); err != nil {
		fmt.Fprintf(os.Stderr, "Error saving configuration: %v\n", err)
		os.Exit(1)
	}
	
	fmt.Printf("Switched to project '%s'\n", projectName)
}
