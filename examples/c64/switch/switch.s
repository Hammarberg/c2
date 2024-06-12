#include "c2/c64/c64.s"
#include "c2/c64/kernal.s"
#include "c2/mos/6502.s"

			// Simple project specific switch example

			var message = "build with: c2 --message \"hello world\""

			c2_cmd.invoke("--message", [&](int arga, const char *argc[])
			{
				message = argc[0];
			},1);	// One argument expected
			
			basic_startup
			
			ldx #0
			
:			lda text,x
			jsr KERNAL_CHROUT
			inx
			cpx #text.end-text
			bne -

:			rts
		
text:		petscii message
.end:
