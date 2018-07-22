package commands

import (
	"github.com/cybercongress/cybernode/common"
	"github.com/spf13/cobra"
	"log"
	"golang.org/x/net/context"
	"strings"
)

func stopNodeCmd(chain common.Chain) *cobra.Command {
	return &cobra.Command{
		Use: "stop",
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			dockContainer, err := dockerClient.ContainerInspect(ctx, chain.DockerContainerName)
			if err != nil {
				log.Fatal(err)
			}

			if dockContainer.State.Running {
				err := dockerClient.ContainerStop(ctx, dockContainer.ID, nil)
				if err != nil {
					log.Fatal(err)
				}
				log.Println(strings.Title(chain.Name), "stopped!")
			} else {
				log.Fatal("Container not running now")
			}

		},
	}
}
