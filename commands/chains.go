package commands

import (
	"github.com/spf13/cobra"
	"fmt"
	)

var ChainsCmd = &cobra.Command{
	Use: "chains",
	Long: "Running chains",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Running chains")
	},
}
