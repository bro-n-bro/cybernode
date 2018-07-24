package commands

import (
	"../common"
	"github.com/spf13/cobra"
	"github.com/docker/docker/api/types"
	"log"
	"io"
	"os"
	"github.com/docker/docker/api/types/container"
	"fmt"
	"golang.org/x/net/context"
	"strings"
)

func startNodeCmd(chain common.Chain) *cobra.Command {
	return &cobra.Command{
		Use: "start",
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			pullOrUpdateImage(ctx, chain)

			dockerContainer, err := dockerClient.ContainerInspect(ctx, chain.DockerContainerName())
			if err != nil {
				createContainer(chain, ctx)
			} else if dockerContainer.State.Running || dockerContainer.State.Restarting {
				log.Fatal(strings.Title(chain.Name), " already running")
			}

			startContainer(ctx, chain)
		},
	}
}

func startContainer(ctx context.Context, chain common.Chain) {
	if err := dockerClient.ContainerStart(ctx, chain.DockerContainerName(), types.ContainerStartOptions{}); err != nil {
		log.Fatal(err)
	}
	fmt.Println(strings.Title(chain.Name), "started!")
}

func pullOrUpdateImage(ctx context.Context, chain common.Chain) {
	fmt.Println("Pulling docker image...")
	out, err := dockerClient.ImagePull(ctx, chain.DockerImage, types.ImagePullOptions{})
	if err != nil {
		log.Fatal(err)
	}
	io.Copy(os.Stdout, out)
}

func createContainer(chain common.Chain, ctx context.Context) {
	config := &container.Config{
		Image:        chain.DockerImage,
		Cmd:          chain.DockerCmdList(nil),
		ExposedPorts: chain.DockerExposedPorts(),
	}
	hostConfig := &container.HostConfig{
		Binds:        chain.DockerBinds(),
		PortBindings: chain.DockerPortBindings(),
	}
	_, err := dockerClient.ContainerCreate(ctx, config, hostConfig, nil, chain.DockerContainerName())
	if err != nil {
		log.Fatal(err)
	}
}
