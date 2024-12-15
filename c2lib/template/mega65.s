#include "c2/mega65/mega65.s"
#include "c2/mega65/kernal.s"
#include "c2/mega65/45gs02.s"

			// {title}
			
			basic_startup
			
			ldx #0
			
:			lda text,x
			beq +
			jsr KERNAL_BSOUT
			inx
			jmp -

:			rts		
		
text:		petscii "hello world",0
