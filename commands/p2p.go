package commands

import (
	"github.com/spf13/cobra"
			"github.com/cybercongress/cybernode/common"
)

var p2pNodes = []common.DockerContainerSpec{
	{
		Name:             "ipfs",
		DockerImageName:  "ipfs/go-ipfs:latest",
		DockerDataFolder: "/data/ipfs",
		PortsToExpose:    map[int][]string{5001: {"tcp"}, 8080: {"tcp"}},
		CommonFlags:      map[string]string{},
		ModesFlags:       map[string]common.Mode{},
	},
}

var P2pCmd = &cobra.Command{Use: "p2p", Short: "Run p2p p2pNodes", Long: "Run p2p p2pNodes"}

func init() {

	for _, node := range p2pNodes {

		cmdDescription := "Run " + node.Name + " node"
		p2pNodeCmd := &cobra.Command{Use: node.Name, Short: cmdDescription, Long: cmdDescription}

		P2pCmd.AddCommand(p2pNodeCmd)

		p2pNodeCmd.AddCommand(startContainerCmd(node))
		p2pNodeCmd.AddCommand(stopContainerCmd(node))
	}

	P2pCmd.AddCommand(nodesStatusCmd("p2p nodes", p2pNodes))

}
