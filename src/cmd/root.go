package cmd

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var (
	// Used for flags
	cfgFile     string
	userLicense string

	rootCmd = &cobra.Command{
		Use:   "crazy",
		Short: "Crazy Dev - AI-powered developer terminal",
		Long: `Crazy Dev is an AI-powered developer terminal that enhances your
development workflow with context-aware suggestions, project analysis,
and intelligent automation.

Complete documentation is available at https://crazy-dev.io`,
		Run: func(cmd *cobra.Command, args []string) {
			// If no subcommand is provided, print help
			cmd.Help()
		},
	}
)

// Execute executes the root command.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	cobra.OnInitialize(initConfig)

	// Global flags
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.crazy-dev/config.yaml)")
	rootCmd.PersistentFlags().StringP("output", "o", "text", "output format (text, json, yaml)")
	rootCmd.PersistentFlags().BoolP("verbose", "v", false, "verbose output")
	rootCmd.PersistentFlags().BoolP("quiet", "q", false, "suppress output")

	// Local flags
	rootCmd.Flags().BoolP("version", "V", false, "display version information")
	rootCmd.Flags().Bool("completion", false, "generate shell completion script")

	// Bind flags to viper
	viper.BindPFlag("output", rootCmd.PersistentFlags().Lookup("output"))
	viper.BindPFlag("verbose", rootCmd.PersistentFlags().Lookup("verbose"))
	viper.BindPFlag("quiet", rootCmd.PersistentFlags().Lookup("quiet"))

	// Add commands
	rootCmd.AddCommand(versionCmd)
	
	// Handle the version flag directly in the root command
	rootCmd.Run = func(cmd *cobra.Command, args []string) {
		showVersion, _ := cmd.Flags().GetBool("version")
		if showVersion {
			fmt.Printf("Crazy Dev v%s\n", Version)
			fmt.Printf("Build Date: %s\n", BuildDate)
			fmt.Printf("Git Commit: %s\n", GitCommit)
			return
		}
		
		// If no subcommand is provided, print help
		cmd.Help()
	}
}

// initConfig reads in config file and ENV variables if set.
// setDefaults sets default configuration values
func setDefaults() {
	// Core settings
	viper.SetDefault("core.context.maxFiles", 10000)
	viper.SetDefault("core.context.maxFileSize", 1048576) // 1MB
	viper.SetDefault("core.context.ignoreDirs", []string{".git", "node_modules", "vendor", ".venv"})
	viper.SetDefault("core.context.ignoreExts", []string{".log", ".tmp"})
	viper.SetDefault("core.ai_response_timeout", "30s")
	viper.SetDefault("core.cloud_ai_timeout", "60s")
	
	// AI engine settings
	viper.SetDefault("ai.local.enabled", true)
	viper.SetDefault("ai.local.endpoint", "http://localhost:11434")
	viper.SetDefault("ai.local.models", []string{"llama3.2", "codellama"})
	viper.SetDefault("ai.local.fallback_to_cloud", true)
	viper.SetDefault("ai.cloud.provider", "openai")
	viper.SetDefault("ai.cloud.rate_limit", 20)
	viper.SetDefault("ai.cloud.cache_ttl", "24h")
	viper.SetDefault("ai.cloud.models", []string{"gpt-4", "claude-3-opus"})
	
	// UI settings
	viper.SetDefault("ui.theme", "default")
	viper.SetDefault("ui.animations", true)
	viper.SetDefault("ui.icons", true)
	viper.SetDefault("ui.colors.primary", "#4285F4")
	viper.SetDefault("ui.colors.secondary", "#34A853")
	viper.SetDefault("ui.colors.accent", "#FBBC05")
	viper.SetDefault("ui.colors.error", "#EA4335")
	
	// Plugin settings
	viper.SetDefault("plugins.enabled", true)
	viper.SetDefault("plugins.auto_update", true)
	viper.SetDefault("plugins.registry", "https://registry.crazy-dev.io")
	viper.SetDefault("plugins.cache_dir", "~/.crazy-dev/plugins")
}

func initConfig() {
	// Set default configuration values
	setDefaults()
	
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)

		// Search config in home directory with name ".crazy-dev" (without extension).
		viper.AddConfigPath(filepath.Join(home, ".crazy-dev"))
		viper.AddConfigPath(".")
		viper.AddConfigPath("/etc/crazy-dev")
		
		// Also look for the default config file in the application directory
		execDir, err := os.Executable()
		if err == nil {
			viper.AddConfigPath(filepath.Dir(execDir))
		}
		
		viper.SetConfigType("yaml")
		viper.SetConfigName("config")
	}

	viper.AutomaticEnv() // read in environment variables that match
	viper.SetEnvPrefix("CRAZY") // prefix for environment variables
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_")) // replace dots with underscores in env vars

	// Try to read the user config file
	if err := viper.ReadInConfig(); err == nil {
		if viper.GetBool("verbose") {
			fmt.Fprintln(os.Stderr, "Using config file:", viper.ConfigFileUsed())
		}
	} else {
		// If user config not found, try to read the default config
		viper.SetConfigName("config-default")
		if err := viper.MergeInConfig(); err == nil {
			if viper.GetBool("verbose") {
				fmt.Fprintln(os.Stderr, "Using default config file:", viper.ConfigFileUsed())
			}
		}
	}
}
