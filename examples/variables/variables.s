#include "c2/c64/c64.s"

			// variables
			
			basic_startup
start:
			var screen_ram = $0400
			var color_ram = $d800
			var text_length = (text.end - text)
			var offset = (25 / 2) * 40 + 20 - text_length / 2
			var white = 1

			{
				// C scope!
				var white = 2
			}

			ldx #text_length - 1
:			lda text,x
			sta screen_ram + offset,x
			lda #white
			sta color_ram + offset,x
			dex
			bpl -


			var b = $0002	// Explicit 16 bit
			sta b			// Known by STA

			int x = $0002;		// C integer
			sta x
			sta var(x, 16)


			rts
		
text:		screencode "hello world of commodore 2022!"
.end:
