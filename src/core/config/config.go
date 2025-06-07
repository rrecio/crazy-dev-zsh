package config

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/viper"
)

// Config represents the application configuration
type Config struct {
	Core    CoreConfig    `mapstructure:"core"`
	AI      AIConfig      `mapstructure:"ai"`
	Plugins PluginsConfig `mapstructure:"plugins"`
	Stacks  StacksConfig  `mapstructure:"stacks"`
	UI      UIConfig      `mapstructure:"ui"`
	Sync    SyncConfig    `mapstructure:"sync"`
}

// CoreConfig contains core application settings
type CoreConfig struct {
	StartupTimeout    string       `mapstructure:"startup_timeout"`
	AIResponseTimeout string       `mapstructure:"ai_response_timeout"`
	CloudAITimeout    string       `mapstructure:"cloud_ai_timeout"`
	LogLevel          string       `mapstructure:"log_level"`
	LogFile           string       `mapstructure:"log_file"`
	Database          DatabaseConfig `mapstructure:"database"`
}

// DatabaseConfig contains database settings
type DatabaseConfig struct {
	Path           string `mapstructure:"path"`
	BackupInterval string `mapstructure:"backup_interval"`
}

// AIConfig contains AI engine settings
type AIConfig struct {
	Local   LocalAIConfig  `mapstructure:"local"`
	Cloud   CloudAIConfig  `mapstructure:"cloud"`
	Context ContextConfig  `mapstructure:"context"`
}

// LocalAIConfig contains local AI settings
type LocalAIConfig struct {
	Enabled         bool     `mapstructure:"enabled"`
	Endpoint        string   `mapstructure:"endpoint"`
	Models          []string `mapstructure:"models"`
	FallbackToCloud bool     `mapstructure:"fallback_to_cloud"`
}

// CloudAIConfig contains cloud AI settings
type CloudAIConfig struct {
	Provider  string `mapstructure:"provider"`
	RateLimit int    `mapstructure:"rate_limit"`
	CacheTTL  string `mapstructure:"cache_ttl"`
}

// ContextConfig contains context analysis settings
type ContextConfig struct {
	MaxFiles       int    `mapstructure:"max_files"`
	MaxFileSize    string `mapstructure:"max_file_size"`
	AnalysisCacheTTL string `mapstructure:"analysis_cache_ttl"`
}

// PluginsConfig contains plugin system settings
type PluginsConfig struct {
	Directories []string       `mapstructure:"directories"`
	Security    SecurityConfig `mapstructure:"security"`
	AutoLoad    bool           `mapstructure:"auto_load"`
	HotReload   bool           `mapstructure:"hot_reload"`
}

// SecurityConfig contains plugin security settings
type SecurityConfig struct {
	SandboxEnabled    bool     `mapstructure:"sandbox_enabled"`
	AllowedFilePatterns []string `mapstructure:"allowed_file_patterns"`
}

// StacksConfig contains tech stack module settings
type StacksConfig struct {
	Golang     StackConfig `mapstructure:"golang"`
	JavaScript StackConfig `mapstructure:"javascript"`
	Python     StackConfig `mapstructure:"python"`
	Flutter    StackConfig `mapstructure:"flutter"`
	Docker     StackConfig `mapstructure:"docker"`
}

// StackConfig contains settings for a tech stack
type StackConfig struct {
	Enabled    bool     `mapstructure:"enabled"`
	AutoDetect bool     `mapstructure:"auto_detect"`
	Tools      []string `mapstructure:"tools"`
}

// UIConfig contains user interface settings
type UIConfig struct {
	Theme    ThemeConfig    `mapstructure:"theme"`
	Terminal TerminalConfig `mapstructure:"terminal"`
	Voice    VoiceConfig    `mapstructure:"voice"`
}

// ThemeConfig contains theme settings
type ThemeConfig struct {
	Name        string `mapstructure:"name"`
	ColorScheme string `mapstructure:"color_scheme"`
	AccentColor string `mapstructure:"accent_color"`
}

// TerminalConfig contains terminal UI settings
type TerminalConfig struct {
	Animations   bool `mapstructure:"animations"`
	ProgressBars bool `mapstructure:"progress_bars"`
	Icons        bool `mapstructure:"icons"`
}

// VoiceConfig contains voice input settings
type VoiceConfig struct {
	Enabled   bool   `mapstructure:"enabled"`
	Language  string `mapstructure:"language"`
	WakeWord  string `mapstructure:"wake_word"`
}

// SyncConfig contains cloud sync settings
type SyncConfig struct {
	Enabled       bool     `mapstructure:"enabled"`
	Endpoint      string   `mapstructure:"endpoint"`
	Encryption    bool     `mapstructure:"encryption"`
	SyncInterval  string   `mapstructure:"sync_interval"`
	Include       []string `mapstructure:"include"`
	Exclude       []string `mapstructure:"exclude"`
}

// LoadConfig loads the configuration from file and environment variables
func LoadConfig(cfgFile string) (*Config, error) {
	v := viper.New()

	if cfgFile != "" {
		// Use config file from the flag
		v.SetConfigFile(cfgFile)
	} else {
		// Find home directory
		home, err := os.UserHomeDir()
		if err != nil {
			return nil, fmt.Errorf("error finding home directory: %w", err)
		}

		// Search for config in standard locations
		v.AddConfigPath(filepath.Join(home, ".crazy-dev"))
		v.AddConfigPath(".")
		v.SetConfigType("yaml")
		v.SetConfigName("config")
	}

	// Read environment variables
	v.AutomaticEnv()
	v.SetEnvPrefix("CRAZY")

	// Read the config file
	if err := v.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			return nil, fmt.Errorf("error reading config file: %w", err)
		}
	}

	var config Config
	if err := v.Unmarshal(&config); err != nil {
		return nil, fmt.Errorf("error unmarshaling config: %w", err)
	}

	return &config, nil
}

// GetDefaultConfig returns the default configuration
func GetDefaultConfig() *Config {
	return &Config{
		Core: CoreConfig{
			StartupTimeout:    "100ms",
			AIResponseTimeout: "2s",
			CloudAITimeout:    "5s",
			LogLevel:          "info",
			LogFile:           "~/.crazy-dev/logs/crazy-dev.log",
			Database: DatabaseConfig{
				Path:           "~/.crazy-dev/data/crazy-dev.db",
				BackupInterval: "24h",
			},
		},
		AI: AIConfig{
			Local: LocalAIConfig{
				Enabled:         true,
				Endpoint:        "http://localhost:11434",
				Models:          []string{"llama3.2", "codellama"},
				FallbackToCloud: true,
			},
			Cloud: CloudAIConfig{
				Provider:  "ollama",
				RateLimit: 60,
				CacheTTL:  "1h",
			},
			Context: ContextConfig{
				MaxFiles:        100,
				MaxFileSize:     "1MB",
				AnalysisCacheTTL: "30m",
			},
		},
		// Add other default configurations as needed
	}
}
