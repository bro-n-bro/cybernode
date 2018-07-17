package common

import (
	"bufio"
	"os"
	"fmt"
	"strings"
)

type Setting struct {
	Path                  string
	Description           string
	DefaultValue          interface{}
	AskUserInitOnFirstRun bool
	UserInputHandler      func(userInput string) (interface{}, error)
}

func (s Setting) getValueFromUserInput() interface{} {
	reader := bufio.NewReader(os.Stdin)

	for {

		fmt.Print("Enter ", s.Path, " (or leave it empty to use default value ", s.DefaultValue, "): ")

		userInput, _ := reader.ReadString('\n')
		userInput = strings.Replace(userInput, "\n", "", -1)

		value, err := s.UserInputHandler(userInput)

		if err != nil {
			fmt.Println(err)
		} else {
			return value
		}
	}
}

func (s Setting) GetFirstRunValue() interface{} {
	if s.AskUserInitOnFirstRun {
		return s.getValueFromUserInput()
	} else {
		return s.DefaultValue
	}
}
