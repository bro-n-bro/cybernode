package commands

import (
	"github.com/cybercongress/cybernode/common"
	"github.com/spf13/cobra"
	"log"
	"golang.org/x/net/context"
	"strings"
)

func stopContainerCmd(spec common.DockerContainerSpec) *cobra.Command {
	return &cobra.Command{
		Use:  "stop",
		Args: cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			dockContainer, err := dockerClient.ContainerInspect(ctx, spec.FullContainerName())
			if err != nil {
				log.Fatal(err)
			}

			if dockContainer.State.Running {
				err := dockerClient.ContainerStop(ctx, dockContainer.ID, nil)
				if err != nil {
					log.Fatal(err)
				}
				log.Println(strings.Title(spec.Name), "stopped!")
			} else {
				log.Fatal("Container not running now")
			}

		},
	}
}
