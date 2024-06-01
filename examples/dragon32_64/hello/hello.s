#include "c2/dragon/dragon.s"

			// hello
#define key $852b
#define cls $ba77

			@ = $4000 - (start - head)

head:
			byte $55
			byte $02
			word start
			word end-start
			word start
			byte $aa



start:		ldx		#$0400
			lda		#0
:			sta		,x+
			inca

			cmpx	#$600
			bne		-

			ldx     #$0500 - 32 + (32 - (text.textend-text)) / 2			// Text screen start, centered
			ldy		#text
:			lda		,y+
			beq		+
			sta		,x+
			bra		-

:			jsr     key             // Wait for key press
			jmp     cls             // Done

text:		screencode "  hello c2 world!  "
.textend:	byte 0

end:
