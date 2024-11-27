#include "c2/c64/c64.s"
#include "c2/c64/kernal.s"
#include "c2/wdc/65816.s"

			// {title}
			
			basic_startup
			
			sei

			cpu nat
			reg x16,a16
			_x16
			_a16

			// Native mode, 16 bit acc and index registers here

			cpu emu
			_x8
			_a8

			cli
:			rts
