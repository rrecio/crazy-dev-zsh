package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

// completionCmd represents the completion command
var completionCmd = &cobra.Command{
	Use:   "completion [bash|zsh|fish|powershell]",
	Short: "Generate shell completion scripts",
	Long: `Generate shell completion scripts for Crazy Dev CLI.
To load completions:

Bash:
  $ source <(crazy completion bash)

  # To load completions for each session, execute once:
  # Linux:
  $ crazy completion bash > /etc/bash_completion.d/crazy
  # macOS:
  $ crazy completion bash > $(brew --prefix)/etc/bash_completion.d/crazy

Zsh:
  # If shell completion is not already enabled in your environment,
  # you will need to enable it. You can execute the following once:

  $ echo "autoload -U compinit; compinit" >> ~/.zshrc

  # To load completions for each session, execute once:
  $ crazy completion zsh > "${fpath[1]}/_crazy"

  # You will need to start a new shell for this setup to take effect.

Fish:
  $ crazy completion fish > ~/.config/fish/completions/crazy.fish

PowerShell:
  PS> crazy completion powershell | Out-String | Invoke-Expression

  # To load completions for every new session, run:
  PS> crazy completion powershell > crazy.ps1
  # and source this file from your PowerShell profile.
`,
	DisableFlagsInUseLine: true,
	ValidArgs:             []string{"bash", "zsh", "fish", "powershell"},
	Args:                  cobra.ExactValidArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		switch args[0] {
		case "bash":
			cmd.Root().GenBashCompletion(os.Stdout)
		case "zsh":
			cmd.Root().GenZshCompletion(os.Stdout)
		case "fish":
			cmd.Root().GenFishCompletion(os.Stdout, true)
		case "powershell":
			cmd.Root().GenPowerShellCompletionWithDesc(os.Stdout)
		}
	},
}

func init() {
	rootCmd.AddCommand(completionCmd)
}
