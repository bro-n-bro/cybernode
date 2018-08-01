package common

import (
	"github.com/docker/go-connections/nat"
	"strconv"
	"github.com/spf13/viper"
	"strings"
)

type DockerContainerSpec struct {
	Name             string
	DockerImageName  string
	DockerDataFolder string
	PortsToExpose    map[int][]string
	CommonFlags      map[string]string
	ModesFlags       map[string]Mode
}

type Mode struct {
	Flags map[string]string
}

func (spec DockerContainerSpec) FullContainerName() string {
	return "cybernode_" + spec.Name
}

func (spec DockerContainerSpec) ExposedPorts() nat.PortSet {
	portSet := nat.PortSet{}
	for port, protocols := range spec.PortsToExpose {
		for _, protocol := range protocols {
			portSet[nat.Port(strconv.Itoa(port)+"/"+protocol)] = struct{}{}
		}
	}
	return portSet
}

func (spec DockerContainerSpec) DataFolder() string {
	return viper.GetString("cybernode.data.path") + "/" + strings.ToLower(spec.Name)
}

func (spec DockerContainerSpec) Binds() []string {
	dataPathBinding := spec.DataFolder() + ":" + spec.DockerDataFolder
	return []string{dataPathBinding}
}

func (spec DockerContainerSpec) PortBindings() nat.PortMap {
	portMap := nat.PortMap{}
	for portBinding := range spec.ExposedPorts() {
		portMap[portBinding] = []nat.PortBinding{
			{
				HostIP:   "0.0.0.0", // todo: crossplatform???
				HostPort: portBinding.Port(),
			},
		}
	}
	return portMap
}

func (spec DockerContainerSpec) CmdList(selectedMode *Mode) []string {
	var cmds []string

	for flag, value := range spec.CommonFlags {
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
