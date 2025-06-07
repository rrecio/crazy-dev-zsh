package main

import (
	"fmt"
	"os"

	"github.com/rrecio/crazy-dev-zsh/src/cmd"
)

func main() {
	// Execute the root command
	if err := cmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
