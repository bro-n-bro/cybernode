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
		Name:             "ethereum",
		DockerImage:      "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.ChainMode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "ethereum_kovan",
		DockerImage:      "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--chain":             "kovan",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.ChainMode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "ethereum_classic",
		DockerImage:      "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--chain":             "classic",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.ChainMode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "bitcoin",
		DockerImage:      "ruimarinho/bitcoin-core:0.16.0",
		DockerDataFolder: "/home/bitcoin/.bitcoin",
		PortsToExpose:    map[int][]string{8332: {"tcp"}},
		CommonFlags: map[string]string{
			"-server":               "",
			"-testnet":              "",
			"-rest":                 "",
			"-txindex":              "",
			"-rpcallowip=0.0.0.0/0": "",
			"-printtoconsole":       "",
		},
		ModesFlags: map[string]common.ChainMode{},
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
