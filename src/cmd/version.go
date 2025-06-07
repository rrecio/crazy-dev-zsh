package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// Version information
var (
	Version   = "0.1.0"
	BuildDate = "2025-06-06"
	GitCommit = "development"
)

// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version number of Crazy Dev",
	Long:  `All software has versions. This is Crazy Dev's.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Crazy Dev v%s\n", Version)
		fmt.Printf("Build Date: %s\n", BuildDate)
		fmt.Printf("Git Commit: %s\n", GitCommit)
	},
}
