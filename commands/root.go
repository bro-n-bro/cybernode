package commands

import (
	"fmt"
	"github.com/spf13/cobra"
	"os/exec"
	"os"
	"github.com/mitchellh/go-homedir"
	"log"
	"github.com/spf13/viper"
	"github.com/docker/docker/client"
)

const CONFIG_FILE_NAME = "settings.yaml"
const CYBERNODE_SETTINGS_FOLDER = "/.cybernode/"
const DOCKER_CLIENT_VERSION = "1.37"

var RootCmd = &cobra.Command{Use: "cybernode"}

var dockerClient *client.Client

func init() {
	cobra.OnInitialize(findDocker, createCybernodeDirectory, initSettings, initDockerClient)
	RootCmd.AddCommand(SettingsCmd, ChainsCmd, P2pCmd, nodesStatusCmd("cyber nodes", append(chains, p2pNodes...)))
}

func findDocker() {
	_, err := exec.LookPath("docker")
	if err != nil {
		log.Fatal("You should install docker in order to use cybernode. Please visit https://docs.docker.com/install/ for more info")
	}
}

func initSettings() {

	settingsFilePath := getSettingsFilePath()

	if _, err := os.Stat(settingsFilePath); err != nil {

		if os.IsNotExist(err) {

			fmt.Println("Seems that you're running cybernode for the first time. Please, enter some settings")

			for _, setting := range settings {
				viper.SetDefault(setting.Path, setting.FirstRunValue())
			}

			if err := viper.WriteConfigAs(settingsFilePath); err != nil {
				log.Fatal(err)
			}

		} else {
			log.Fatal(err)
		}

	} else {

		viper.SetConfigFile(settingsFilePath)
		viper.ReadInConfig()
	}

}

func initDockerClient() {
	cli, err := client.NewClientWithOpts(client.WithVersion(DOCKER_CLIENT_VERSION))
	dockerClient = cli

	if err != nil {
		log.Fatal(err)
	}
}

func getSettingsFilePath() string {
	return getHomeDir() + CYBERNODE_SETTINGS_FOLDER + CONFIG_FILE_NAME
}

func createCybernodeDirectory() {
	cybernodeDirectoryPath := getHomeDir() + CYBERNODE_SETTINGS_FOLDER
	if err := createDirectoryIfNotExists(cybernodeDirectoryPath); err != nil {
		log.Fatal("Cannot create ", cybernodeDirectoryPath, " directory. ", err)
	}
}

func getHomeDir() string {
	home, err := homedir.Dir()
	if err != nil {
		log.Fatal("Cannot find home directory")
	}
	return home
}

func createDirectoryIfNotExists(path string) error {
	err := os.MkdirAll(path, os.ModePerm)
	if err != nil {
		if !os.IsExist(err) {
			return err
		}
	}
	return nil
}
