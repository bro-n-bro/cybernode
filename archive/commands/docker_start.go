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
	startCmd := &cobra.Command{
		Use:  "start",
		Args: cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {

			ctx := context.Background()

			pullOrUpdateImage(ctx, spec)

			autoStartup := cmd.Flags().Changed("autostartup")

			selectedMode := parseMode(spec, cmd)

			dockerContainer, err := dockerClient.ContainerInspect(ctx, spec.FullContainerName())
			if err != nil {
				createContainer(spec, selectedMode, autoStartup, ctx)
			} else if dockerContainer.State.Running || dockerContainer.State.Restarting {
				log.Fatal(strings.Title(spec.Name), " already running")
			}

			startContainer(ctx, spec)
		},
	}

	startCmd.Flags().Bool("autostartup", false, "autorun node after system reboot")
	for modeFlag, mode := range spec.ModesFlags {
		startCmd.Flags().Bool(modeFlag, false, mode.Description)
	}
	return startCmd
}

func parseMode(spec common.DockerContainerSpec, cmd *cobra.Command) common.Mode {
	for modeFlag, mode := range spec.ModesFlags {
		if cmd.Flags().Changed(modeFlag) {
			return mode
		}
	}
	return spec.DefaultMode
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

func createContainer(spec common.DockerContainerSpec, mode common.Mode, autoStartup bool, ctx context.Context) {
	config := &container.Config{
		Image:        spec.DockerImageName,
		Cmd:          spec.CmdList(&mode),
		ExposedPorts: spec.ExposedPorts(),
	}
	hostConfig := &container.HostConfig{
		Binds:         spec.Binds(),
		PortBindings:  spec.PortBindings(),
		RestartPolicy: container.RestartPolicy{Name: restartPolicyName(autoStartup)},
	}
	_, err := dockerClient.ContainerCreate(ctx, config, hostConfig, nil, spec.FullContainerName())
	if err != nil {
		log.Fatal(err)
	}
}

func restartPolicyName(autoStartup bool) string {
	if autoStartup {
		return "always"
	}
	return "no"
}
