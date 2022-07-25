package methods

import (
	"fmt"
	"strconv"

	"github.com/rs/zerolog/log"
)

// Run a loop over 10 numbers
func Loop() (err error) {
	funcLog := log.With().
		Str("type", "module").
		Str("module", "functions").
		Str("function", "loop").
		Logger()

	funcLog.Debug().
		Msg("Running the function")

	funcLog.Debug().
		Msg("Start the loop")

	for i := 0; i < 10; i++ {
		funcLog.Debug().
			Int("i", i).
			Msg(fmt.Sprintf("New loop cycle is done, remaining loop: %s", strconv.Itoa(9-i)))
	}

	funcLog.Info().
		Msg("Function finished successfully")

	return
}
