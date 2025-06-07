package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"gopkg.in/yaml.v3"
)

// configCmd represents the config command
var configCmd = &cobra.Command{
	Use:   "config",
	Short: "Manage Crazy Dev configuration",
	Long: `The config command allows you to manage your Crazy Dev configuration.
You can view, set, and reset configuration values.

Examples:
  # View all configuration
  crazy config

  # View a specific configuration value
  crazy config get ai.local.enabled

  # Set a configuration value
  crazy config set ai.local.endpoint http://localhost:11434

  # Reset a configuration value to default
  crazy config reset ai.local.endpoint`,
	Run: runConfigCommand,
}

// getCmd represents the config get subcommand
var configGetCmd = &cobra.Command{
	Use:   "get [key]",
	Short: "Get a configuration value",
	Long:  `Get the value of a specific configuration key.`,
	Args:  cobra.ExactArgs(1),
	Run:   runConfigGetCommand,
}

// setCmd represents the config set subcommand
var configSetCmd = &cobra.Command{
	Use:   "set [key] [value]",
	Short: "Set a configuration value",
	Long:  `Set the value of a specific configuration key.`,
	Args:  cobra.ExactArgs(2),
	Run:   runConfigSetCommand,
}

// resetCmd represents the config reset subcommand
var configResetCmd = &cobra.Command{
	Use:   "reset [key]",
	Short: "Reset a configuration value to default",
	Long:  `Reset the value of a specific configuration key to its default value.`,
	Args:  cobra.ExactArgs(1),
	Run:   runConfigResetCommand,
}

func init() {
	rootCmd.AddCommand(configCmd)
	
	// Add subcommands
	configCmd.AddCommand(configGetCmd)
	configCmd.AddCommand(configSetCmd)
	configCmd.AddCommand(configResetCmd)
	
	// Flags for the config command
	configCmd.PersistentFlags().StringP("format", "f", "text", "Output format (text, json, yaml)")
}

// runConfigCommand executes the config command
func runConfigCommand(cmd *cobra.Command, args []string) {
	format, _ := cmd.Flags().GetString("format")
	
	switch format {
	case "json":
		settings := viper.AllSettings()
		jsonData, err := json.MarshalIndent(settings, "", "  ")
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error marshaling to JSON: %v\n", err)
			os.Exit(1)
		}
		fmt.Println(string(jsonData))
		
	case "yaml":
		settings := viper.AllSettings()
		yamlData, err := yaml.Marshal(settings)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error marshaling to YAML: %v\n", err)
			os.Exit(1)
		}
		fmt.Println(string(yamlData))
		
	default:
		// Print in a human-readable format
		settings := viper.AllSettings()
		printConfigMap("", settings)
		
		// Show config file location
		if viper.ConfigFileUsed() != "" {
			fmt.Printf("\nConfig file: %s\n", viper.ConfigFileUsed())
		} else {
			fmt.Printf("\nNo config file in use. Default settings applied.\n")
			fmt.Printf("Create a config file at: %s\n", getDefaultConfigPath())
		}
	}
}

// runConfigGetCommand executes the config get subcommand
func runConfigGetCommand(cmd *cobra.Command, args []string) {
	key := args[0]
	
	if !viper.IsSet(key) {
		fmt.Printf("Configuration key '%s' not found\n", key)
		os.Exit(1)
	}
	
	value := viper.Get(key)
	fmt.Printf("%s = %v\n", key, value)
}

// runConfigSetCommand executes the config set subcommand
func runConfigSetCommand(cmd *cobra.Command, args []string) {
	key := args[0]
	value := args[1]
	
	// Set the value in viper
	viper.Set(key, value)
	
	// Save to config file
	if err := saveConfig(); err != nil {
		fmt.Fprintf(os.Stderr, "Error saving configuration: %v\n", err)
		os.Exit(1)
	}
	
	fmt.Printf("Set %s = %s\n", key, value)
}

// runConfigResetCommand executes the config reset subcommand
func runConfigResetCommand(cmd *cobra.Command, args []string) {
	key := args[0]
	
	// Check if the key exists
	if !viper.IsSet(key) {
		fmt.Printf("Configuration key '%s' not found\n", key)
		os.Exit(1)
	}
	
	// Reset by removing the key from the config
	viper.Set(key, nil)
	
	// Save to config file
	if err := saveConfig(); err != nil {
		fmt.Fprintf(os.Stderr, "Error saving configuration: %v\n", err)
		os.Exit(1)
	}
	
	fmt.Printf("Reset %s to default value\n", key)
}

// saveConfig saves the current configuration to the config file
func saveConfig() error {
	configFile := viper.ConfigFileUsed()
	
	// If no config file is set, create one in the default location
	if configFile == "" {
		configFile = getDefaultConfigPath()
		
		// Ensure directory exists
		configDir := filepath.Dir(configFile)
		if err := os.MkdirAll(configDir, 0755); err != nil {
			return fmt.Errorf("could not create config directory: %w", err)
		}
	}
	
	return viper.WriteConfig()
}

// getDefaultConfigPath returns the default path for the config file
func getDefaultConfigPath() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return ".crazy-dev/config.yaml"
	}
	return filepath.Join(home, ".crazy-dev", "config.yaml")
}

// printConfigMap prints a map of configuration values recursively
func printConfigMap(prefix string, configMap map[string]interface{}) {
	for key, value := range configMap {
		fullKey := key
		if prefix != "" {
			fullKey = prefix + "." + key
		}
		
		// If value is a map, recurse
		if nestedMap, ok := value.(map[string]interface{}); ok {
			printConfigMap(fullKey, nestedMap)
		} else {
			fmt.Printf("%s = %v\n", fullKey, value)
		}
	}
}
