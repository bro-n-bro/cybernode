package commands

import (
	"github.com/spf13/cobra"
	"fmt"
	"github.com/spf13/viper"
	"strings"
	"errors"
	"github.com/cybercongress/cybernode/common"
	"github.com/spf13/pflag"
	"log"
)

const CYBERNODE_DATA_FOLDER_DEFAULT = "/.cybernode/data"

var cybernodeDataPath string

var SettingsCmd = &cobra.Command{
	Use:  "settings",
	Short: "Settings of cybernode",
	Long: "If some flags with settings specified command will set new value to those settings. Otherwise list all settings",
	Args: cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {

		cmd.Flags().Visit(parseSettingFlag)

		if cmd.Flags().NFlag() == 0 {
			fmt.Println("Settings:")
			for _, settingPath := range viper.AllKeys() {
				setting := settings[settingPath]
				fmt.Println(setting.Path, "-", setting.Description, ":", viper.Get(settingPath))
			}
		}
	},
}

func init() {
	SettingsCmd.Flags().StringVar(&cybernodeDataPath, "cybernode.data.path", "", "Path to data folder")
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

	fmt.Println("cybernode.data.path set to", dataPathDir, ". You could always change settings with cybernode settings command")

	return dataPathDir, nil
}

func parseSettingFlag(flag *pflag.Flag) {
	setting, ok := settings[flag.Name]
	if ok && flag.Value.String() != "" {
		value, err := setting.UserInputHandler(flag.Value.String())
		if err != nil {
			log.Fatal(err)
		}
		viper.Set(flag.Name, value)
		viper.WriteConfigAs(getSettingsFilePath())
	}
}
