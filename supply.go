package gowindowsbuildpack

import (
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/cloudfoundry/libbuildpack"
)

type Supplier struct {
	Manifest  Manifest
	Installer Installer
	Stager    Stager
	Command   Command
	Log       *libbuildpack.Logger
}

func (s *Supplier) Run() error {
	s.Log.BeginStep("Supplying go")

	if err := s.Installer.InstallOnlyVersion("go", s.Stager.DepDir()); err != nil {
		return err
	}
	files, err := ioutil.ReadDir(filepath.Join(s.Stager.DepDir(), "go"))
	if err != nil {
		return err
	}
	for _, file := range files {
		os.Remove(filepath.Join(s.Stager.DepDir(), file.Name()))
		if err := os.Rename(filepath.Join(s.Stager.DepDir(), "go", file.Name()), filepath.Join(s.Stager.DepDir(), file.Name())); err != nil {
			return err
		}
	}

	return os.Remove(filepath.Join(s.Stager.DepDir(), "go"))
}
