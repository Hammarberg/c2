#include "c2/atari2600/atari2600.s"
#include "c2/atari2600/macro.s"

			// {title}

			@ = $f000
			// Start of execution
start:		jmp @

			@ = $fffa
			word start		// NMI
			word start		// RESET
			word start		// IRQ
