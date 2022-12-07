#include "c64.s"

			// labels
			
			basic_startup

start:
			ldy #0
.loop:		jsr print
			iny
			cpy #100
			bne .loop

			jmp print.exit

print:		ldx #0

.loop:		lda text,x
			jsr $ffd2
			inx
			cpx #text.end - text
			bne .loop

.exit:		rts

text:		petscii "hello world of commodore 2022! "
.end:

