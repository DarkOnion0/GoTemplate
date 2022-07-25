package config

import (
	"flag"
)

func init() {
	flag.Parse()
}

var (
	Debug = flag.String("debug", "false", "Sets log level to debug")
)
