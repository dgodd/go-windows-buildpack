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
	cmd := exec.Command("go", "build", "-o", "myapp.exe", ".")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Dir = f.Stager.BuildDir()
	cmd.Env = append(os.Environ(), "GOROOT="+f.Stager.DepDir())
	if err := f.Command.Run(cmd); err != nil {
		return err
	}
	return nil
}
