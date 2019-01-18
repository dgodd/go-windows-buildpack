package gowindowsbuildpack

import (
	"io"
	"os/exec"

	"github.com/cloudfoundry/libbuildpack"
)

type Stager interface {
	BuildDir() string
	CacheDir() string
	DepDir() string
}

type Manifest interface {
	DefaultVersion(string) (libbuildpack.Dependency, error)
}

type Installer interface {
	InstallOnlyVersion(string, string) error
}

type Command interface {
	Execute(string, io.Writer, io.Writer, string, ...string) error
	Run(*exec.Cmd) error
	// Output(dir string, program string, args ...string) (string, error)
}
