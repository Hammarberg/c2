#include "c2/c64/c64.s"

			// macros

			macro memcpy @dst, @src, @size
			{
				if(!size)
				{
					//nothing to do
				}
				else if(size == 1)
				{
					lda src
					sta dst
				}
				else if(size <= 128)
				{
					ldy #size - 1
				:	lda src,y
					sta dst,y
					dey
					bpl -
				}
				else if(size <= 256)
				{
					ldy #$00
				:	lda src,y
					sta dst,y
					iny
					if(size != 256)
						cpy #size
					bne -
				}
				else
				{
					error("memcpy size out of range");
				}
			}

			macro pushall
			{
				pha
				txa
				pha
				tya
				pha
			}

			macro popall
			{
				pla
				tay
				pla
				tax
				pla
			}

			basic_startup

			ldy #2
			lda #0

			pushall
			memcpy $0400, text, text.end - text
			popall

			sta $d021
			sty $d020

			rts
		
text:
			screencode "                                        "
			screencode "     hello world of commodore 2022!     "
			screencode "                                        "
.end:
