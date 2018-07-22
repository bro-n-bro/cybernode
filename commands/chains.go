package commands

import (
	"github.com/spf13/cobra"
	"github.com/cybercongress/cybernode/common"
	"log"
	"github.com/docker/docker/client"
	)

var dockerClient *client.Client

var chains = []common.Chain{
	{
		Name:                "ethereum",
		DockerImage:         "parity/parity:v1.11.7",
		DockerContainerName: "cybernode-ethereum", //todo: move to function
		DataFolderFlagName:  "--db-path",
		PortsToExpose:       map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags:         map[string]string{"--ui-interface": "all", "--jsonrpc-interface": "all"},
		ModesFlags:          map[string]common.ChainMode{"light": {Flags: []string{"--light"}}},
	},
	{
		Name:                "ethereum_kovan",
		DockerImage:         "parity/parity:v1.11.7",
		DockerContainerName: "cybernode-ethereum-kovan", //todo: move to function
		DataFolderFlagName:  "--db-path",
		PortsToExpose:       map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags:         map[string]string{"--ui-interface": "all", "--jsonrpc-interface": "all", "--chain": "kovan"},
		ModesFlags:          map[string]common.ChainMode{"light": {Flags: []string{"--light"}}},
	},
	{
		Name:                "ethereum_classic",
		DockerImage:         "parity/parity:v1.11.7",
		DockerContainerName: "cybernode-ethereum-classic", //todo: move to function
		DataFolderFlagName:  "--db-path",
		PortsToExpose:       map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags:         map[string]string{"--ui-interface": "all", "--jsonrpc-interface": "all", "--chain": "classic"},
		ModesFlags:          map[string]common.ChainMode{"light": {Flags: []string{"--light"}}},
	},
}

var ChainsCmd = &cobra.Command{Use: "chains", Short: "Run chains nodes", Long: "Run chains nodes"}

func init() {

	cli, err := client.NewClientWithOpts(client.WithVersion("1.37"))
	dockerClient = cli

	if err != nil {
		log.Fatal(err)
	}

	for _, chain := range chains {

		cmdDescription := "Run " + chain.Name + " node"
		chainNodeCmd := &cobra.Command{Use: chain.Name, Short: cmdDescription, Long: cmdDescription}

		ChainsCmd.AddCommand(chainNodeCmd)

		chainNodeCmd.AddCommand(startNodeCmd(chain))
		chainNodeCmd.AddCommand(stopNodeCmd(chain))
	}

	ChainsCmd.AddCommand(ChainsStatusCmd)

}
