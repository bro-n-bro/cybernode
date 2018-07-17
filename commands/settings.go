package commands

import (
	"github.com/spf13/cobra"
	"fmt"
	"github.com/spf13/viper"
	"strings"
	"errors"
	"github.com/cybercongress/cybernode/common"
)

const CYBERNODE_DATA_FOLDER_DEFAULT = "/.cybernode/data"

var SettingsCmd = &cobra.Command{
	Use:  "settings",
	Long: "Current settings of cybernode",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Settings:")
		for _, settingPath := range viper.AllKeys() {
			setting := settings[settingPath]
			fmt.Println(setting.Path, "-", setting.Description, ":", viper.Get(settingPath))
		}
	},
}

var settings = map[string]common.Setting{
	"cybernode.data.path": {
		Path:                  "cybernode.data.path",
		Description:           "Place where cybernode stores all of its data",
		DefaultValue:          getHomeDir() + CYBERNODE_DATA_FOLDER_DEFAULT,
		AskUserInitOnFirstRun: true,
		UserInputHandler:      cybernodeDataPathUserValueHandler,
	},
}

func cybernodeDataPathUserValueHandler(userInput string) (interface{}, error) {

	var dataPathDir = userInput

	if strings.Compare(dataPathDir, "") == 0 {
		dataPathDir = getHomeDir() + CYBERNODE_DATA_FOLDER_DEFAULT
	}

	if err := createDirectoryIfNotExists(dataPathDir); err != nil {
		return nil, errors.New(err.Error() + "\nOops, seems that you've entered wrong path. Try again.")
	}

	fmt.Println("Set to ", dataPathDir, ". You could always change settings with cybernode settings command")

	return dataPathDir, nil
}
