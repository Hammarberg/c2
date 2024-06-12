#include "c2/c64/c64.s"
#include "c2/c64/kernal.s"
#include "c2/mos/6502.s"
#include "c2/mos/6502_unintended.s"

			// {title}
			
			basic_startup
			
			ldx #0
			
:			lda text,x
			beq +
			jsr KERNAL_CHROUT
			inx
			jmp -

:			rts		
		
text:		petscii "hello world",0
