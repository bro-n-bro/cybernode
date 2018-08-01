package commands

import (
	"github.com/spf13/cobra"
	"github.com/cybercongress/cybernode/common"
		)

var chains = []common.DockerContainerSpec{
	{
		Name:             "ethereum",
		DockerImageName:  "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.Mode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "ethereum_kovan",
		DockerImageName:  "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--chain":             "kovan",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.Mode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "ethereum_classic",
		DockerImageName:  "parity/parity:v1.11.7",
		DockerDataFolder: "/cyberdata",
		PortsToExpose:    map[int][]string{8180: {"tcp"}, 8545: {"tcp"}, 8456: {"tcp"}, 30303: {"tcp", "udp"},},
		CommonFlags: map[string]string{
			"--ui-interface":      "all",
			"--jsonrpc-interface": "all",
			"--chain":             "classic",
			"--db-path":           "/cyberdata",
		},
		ModesFlags: map[string]common.Mode{"light": {Flags: map[string]string{"--light": ""}}},
	},
	{
		Name:             "bitcoin",
		DockerImageName:  "ruimarinho/bitcoin-core:0.16.0",
		DockerDataFolder: "/home/bitcoin/.bitcoin",
		PortsToExpose:    map[int][]string{8332: {"tcp"}},
		CommonFlags: map[string]string{
			"-server":               "",
			"-rest":                 "",
			"-txindex":              "",
			"-rpcallowip=0.0.0.0/0": "",
			"-printtoconsole":       "",
		},
		ModesFlags: map[string]common.Mode{},
	},
}

var ChainsCmd = &cobra.Command{Use: "chains", Short: "Run chains nodes", Long: "Run chains nodes"}

func init() {

	for _, chain := range chains {

		cmdDescription := "Run " + chain.Name + " node"
		chainNodeCmd := &cobra.Command{Use: chain.Name, Short: cmdDescription, Long: cmdDescription}

		ChainsCmd.AddCommand(chainNodeCmd)

		chainNodeCmd.AddCommand(startContainerCmd(chain))
		chainNodeCmd.AddCommand(stopContainerCmd(chain))
	}

	ChainsCmd.AddCommand(nodesStatusCmd("chains", chains))

}
