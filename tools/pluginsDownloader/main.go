package main

import (
	"encoding/json"
	"github.com/pkg/errors"
	"io"
	"log"
	"net/http"
	"os"
)

type Plugin struct {
	Name string `json:"name"`
	URL  string `json:"url"`
}


func checkVariable(variable string) (string, error) {
	if variable, ok := os.LookupEnv(variable); ok {
		return variable, nil
	}
	return "", errors.New("Please provide " + variable +  "env variable")

}

func getPluginsDir() (string, error) {
	dir, err := checkVariable("PLUGINS_DIR")
	return dir, err
}

func getPluginsConfig() ([]Plugin, error) {
	var plugins []Plugin

	pluginsConfig, err := checkVariable("PLUGINS_LIST")
	if err != nil {
		return plugins, err
	}
	err = json.Unmarshal([]byte(pluginsConfig), &plugins)
	if err != nil {
		return plugins, err
	}
	return plugins, err
}

func downloadFile(filepath string, url string) error {
	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	return err
}

func main() {
	dir, err := getPluginsDir()
	if err != nil {
		log.Fatal(err)
	}
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		log.Printf("Directory %s does not exist. Creating...", dir)
		err = os.MkdirAll(dir, os.ModePerm)
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("Done")
	} else {
		log.Printf("Directory %s already existt exist. Skipping...", dir)
	}

	plugins, err := getPluginsConfig()
	if err != nil {
		log.Fatal(err)
	}

	for _, plugin := range plugins {
		filePath := dir+"/"+plugin.Name+".zip"
		if _, err := os.Stat(filePath); err == nil {
			log.Printf("Plugin %s already exist. Skipping download.", plugin.Name)
		} else {
			log.Printf("Plugin %s does not exist. Downloading...", plugin.Name)
			err := downloadFile(filePath, plugin.URL)
			if err != nil {
				log.Fatal(err)
			}
			log.Println("Done")
		}
	}
	log.Println("Successfully")
}
