#include "c64.s"

			// advbasic

			@ = $0801
			basic("10 for r=0 to 10\n20print \"hello world from basic \";\n30 next\n40 sys %d : rem hello world\n", int(start));
			
start:
			ldy #0
.loopy:		ldx #0
			
.loopx:		lda text,x
			beq .next
			jsr $ffd2
			inx
			jmp .loopx

.next:		iny
			cpy #10
			bne .loopy

			rts
		
text:		petscii "hello world from assembly ",0
