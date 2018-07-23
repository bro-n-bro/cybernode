package commands

import (
	"github.com/spf13/cobra"
	"golang.org/x/net/context"
	"log"
)

var ChainsStatusCmd = &cobra.Command{
	Use:   "status",
	Short: "Status of running chains",
	Long:  "Status of running chains",
	Run: func(cmd *cobra.Command, args []string) {

		ctx := context.Background()

		for _, chain := range chains {

			dockerContainer, err := dockerClient.ContainerInspect(ctx, chain.DockerContainerName)
			if err != nil {
				log.Println(chain.Name, " not running, no container created")
			} else {
				log.Println(chain.Name, dockerContainer.State.Status)
			}
		}

	},
}
