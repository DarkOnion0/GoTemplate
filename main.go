package main

import (
	"os"

	"github.com/DarkOnion0/GoTemplate/config"
	"github.com/DarkOnion0/GoTemplate/methods"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func init() {
	// enable or not the debug level (default is Info)
	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	if *config.Debug == "true" {
		zerolog.SetGlobalLevel(zerolog.DebugLevel)
	}

	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
	log.Logger = log.With().Caller().Logger()
	// activate the pretty logger for dev purpose only if the debug mode is enabled
	if *config.Debug == "true" {
		log.Logger = log.With().Caller().Logger().Output(zerolog.ConsoleWriter{Out: os.Stderr})
	}

	log.Info().
		Str("type", "main").
		Str("function", "init").
		Msg("Logger is configured!")

	log.Debug().
		Str("type", "main").
		Str("function", "init").
		Msg("Debug mode is enabled!")
}

func main() {
	funcLog := log.With().
		Str("type", "main").
		Str("function", "main").
		Logger()

	err0 := methods.Loop()

	if err0 != nil {
		funcLog.Fatal().
			Err(err0).
			Msg("Something bad append to the Loop function")
	}

	funcLog.Warn().
		Msg(config.MESSAGE)

	funcLog.Info().
		Msg("Function finished successfully")
}
