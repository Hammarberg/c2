#include "c64.s"

			// {title}
			
			basic_startup
			
			ldx #0
			
:			lda text,x
			beq +
			jsr $ffd2
			inx
			jmp -

:			rts		
		
text:		petscii "hello world",0
