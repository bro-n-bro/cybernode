package commands

import (
	"github.com/cybercongress/cybernode/common"
	"github.com/spf13/cobra"
	"golang.org/x/net/context"
	"fmt"
	"strings"
)

func nodesStatusCmd(nodesGroupName string, nodeSpecs []common.DockerContainerSpec) *cobra.Command {

	return &cobra.Command{
		Use:   "status",
		Short: "Status of running " + nodesGroupName,
		Long:  "Status of running " + nodesGroupName,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			formatStr := "%-30s %s\n"
			fmt.Printf(formatStr, "Container", "Status")
			fmt.Printf(formatStr, "------------", "------------")

			for _, node := range nodeSpecs {

				dockerContainer, err := dockerClient.ContainerInspect(ctx, node.FullContainerName())
				nodeName := strings.ToUpper(node.Name)
				if err != nil {
					fmt.Printf(formatStr, nodeName, "not running, no container created")
				} else {
					fmt.Printf(formatStr, nodeName, dockerContainer.State.Status)
				}
			}

		},
	}
}
