#include "c2/dragon/dragon.s"

			// hello
#define key $852b
#define cls $ba77

			// Start address and a Dragon/CoCo binary DOS header
			dosheader $4000
			
			ldx		#$0400
			lda		#0
:			sta		,x+
			inca
			cmpx		#$600
			bne		-

			ldx		#$0500 - 32 + (32 - (text.textend-text)) / 2			// Text screen start, centered
			leay		text,pcr
:			lda		,y+
			beq		+
			sta		,x+
			bra		-

:			jsr		key             // Wait for key press
			jmp		cls             // Done

text:		screencode "  hello c2 world!  "
.textend:	byte 0
