#include "c2/wdc/65816.s"

			// {title}

			@ = $1000
start:		cpu nat			// Enable 65c816 mode
			reg x16,m16		// Enable 16 bit acc and index registers
			_m16				// Let c2 know to assemble 16 bit immediate acc instructions
			_i16				// Let c2 know to assemble 16 bit immediate index instructions

			bra @			// Loop forever
