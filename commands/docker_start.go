package commands

import (
	"github.com/cybercongress/cybernode/common"
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

func startContainerCmd(spec common.DockerContainerSpec) *cobra.Command {
	return &cobra.Command{
		Use:  "start",
		Args: cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			pullOrUpdateImage(ctx, spec)

			dockerContainer, err := dockerClient.ContainerInspect(ctx, spec.FullContainerName())
			if err != nil {
				createContainer(spec, ctx)
			} else if dockerContainer.State.Running || dockerContainer.State.Restarting {
				log.Fatal(strings.Title(spec.Name), " already running")
			}

			startContainer(ctx, spec)
		},
	}
}

func startContainer(ctx context.Context, spec common.DockerContainerSpec) {
	if err := dockerClient.ContainerStart(ctx, spec.FullContainerName(), types.ContainerStartOptions{}); err != nil {
		log.Fatal(err)
	}
	fmt.Println(strings.Title(spec.Name), "started!")
}

func pullOrUpdateImage(ctx context.Context, spec common.DockerContainerSpec) {
	fmt.Println("Pulling docker image...")
	out, err := dockerClient.ImagePull(ctx, spec.DockerImageName, types.ImagePullOptions{})
	if err != nil {
		log.Fatal(err)
	}
	io.Copy(os.Stdout, out)
}

func createContainer(spec common.DockerContainerSpec, ctx context.Context) {
	config := &container.Config{
		Image:        spec.DockerImageName,
		Cmd:          spec.CmdList(nil),
		ExposedPorts: spec.ExposedPorts(),
	}
	hostConfig := &container.HostConfig{
		Binds:        spec.Binds(),
		PortBindings: spec.PortBindings(),
	}
	_, err := dockerClient.ContainerCreate(ctx, config, hostConfig, nil, spec.FullContainerName())
	if err != nil {
		log.Fatal(err)
	}
}
