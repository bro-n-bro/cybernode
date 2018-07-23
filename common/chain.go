package common

import (
	"github.com/docker/go-connections/nat"
	"strconv"
	"github.com/spf13/viper"
)

type Chain struct {
	Name                string
	DockerImage         string
	DockerContainerName string
	DataFolderFlagName  string
	PortsToExpose       map[int][]string
	CommonFlags         map[string]string
	ModesFlags          map[string]ChainMode
}

type ChainMode struct {
	Flags map[string]string
}

func (c Chain) DockerExposedPorts() nat.PortSet {
	portSet := nat.PortSet{}
	for port, protocols := range c.PortsToExpose {
		for _, protocol := range protocols {
			portSet[nat.Port(strconv.Itoa(port)+"/"+protocol)] = struct{}{}
		}
	}
	return portSet
}

func (c Chain) DockerPortBindings() nat.PortMap {
	portMap := nat.PortMap{}
	for portBinding := range c.DockerExposedPorts() {
		portMap[portBinding] = []nat.PortBinding{
			{
				HostIP:   "0.0.0.0", // todo: crossplatform???
				HostPort: portBinding.Port(),
			},
		}
	}
	return portMap
}

func (c Chain) DockerCmdList(selectedMode *ChainMode) []string {
	cmds := []string{c.DataFolderFlagName, viper.GetString("cybernode.data.path")} // todo: move to const

	for flag, value := range c.CommonFlags {
		cmds = appendFlag(cmds, flag, value)
	}

	if selectedMode != nil {
		for flag, value := range selectedMode.Flags {
			cmds = appendFlag(cmds, flag, value)
		}
	}

	return cmds
}

func appendFlag(cmds []string, flag string, value string) []string {
	cmds = append(cmds, flag)
	if value != "" {
		cmds = append(cmds, value)
	}
	return cmds
}
