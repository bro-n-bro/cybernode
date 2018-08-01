package commands

import (
	"github.com/cybercongress/cybernode/common"
	"github.com/spf13/cobra"
	"log"
	"golang.org/x/net/context"
)

func nodesStatusCmd(nodesGroupName string, nodeSpecs []common.DockerContainerSpec) *cobra.Command {

	return &cobra.Command{
		Use:   "status",
		Short: "Status of running " + nodesGroupName,
		Long:  "Status of running " + nodesGroupName,
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			for _, node := range nodeSpecs {

				dockerContainer, err := dockerClient.ContainerInspect(ctx, node.FullContainerName())
				if err != nil {
					log.Println(node.Name, " not running, no container created")
				} else {
					log.Println(node.Name, dockerContainer.State.Status)
				}
			}

		},
	}
}
