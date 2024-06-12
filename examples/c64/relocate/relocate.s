#include "c2/c64/c64.s"
#include "c2/mos/6502.s"

			// relocate

			var relocation = $0600
			
			basic_startup

			ldx #end_reloc - start_reloc - 1
:			lda start_reloc,x
			sta relocation,x
			dex
			bpl -
			jmp relocation

start_reloc:

			// First parameter is write location, second parameter is address location
			@ = @, relocation

			ldx #.textend - .text - 1
			
:			lda .text,x
			sta $0400,x
			lda #$01
			sta $d800,x
			dex
			bpl -

			rts
		
.text:		screencode "hello world of commodore 2022!"
.textend:
			// Restore address location to write location by assigning org to itself
			@ = @
end_reloc:

