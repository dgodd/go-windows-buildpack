package gowindowsbuildpack

import (
	"os"
	"os/exec"

	"github.com/cloudfoundry/libbuildpack"
)

type Finalizer struct {
	Manifest Manifest
	Stager   Stager
	Command  Command
	Log      *libbuildpack.Logger
}

func (f *Finalizer) Run() error {
	f.Log.BeginStep("Go Build")
	cmd := exec.Command("go", "build", "-o", "myapp", ".")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Dir = f.Stager.BuildDir()
	cmd.Env = append(os.Environ(), "GOROOT="+f.Stager.DepDir())
	if err := f.Command.Run(cmd); err != nil {
		return err
	}

	f.Log.BeginStep("Configuring go")
	return f.WriteReleaseYAML()
}

func (f *Finalizer) WriteReleaseYAML() error {
	data := map[string]map[string]string{
		"default_process_types": map[string]string{
			"web": "./myapp",
		},
	}
	releasePath := "/tmp/go-buildpack-release-step.yml"
	if err := libbuildpack.NewYAML().Write(releasePath, data); err != nil {
		f.Log.Error("Error writing release YAML: %v", err)
		return err
	}

	return nil
}
