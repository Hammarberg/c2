#include "c64.s"

			// differences

			// This is a C++style comment
			/*
				This is C-style comment
			*/

			#if 0
				Pre-processor can also work as a comment

				The shock for some might be that:

				; Semicolon, these kind of comments doesn't work in c2!

			#endif
			
			// * = $0801
			@ = $0801	// @ is ORG instead of *

			// c2 for 6502 uses byte and word rather than dc.b or dc.w
			// if you really miss dc.b you could revive those with macros

			// Basic start line: 10 sys2061
			byte $0b, $08, $0a, $00, $9e, $32, $30, $36, $31, $00, $00, $00

			sei
			/*
			This is how many 8 bit assemblers handled low and high byte

			lda #<irq
			sta $0314
			lda #>irq
			sta $0315
			*/

			//Instead c2 uses C-syntax algebra and not limited to handle 16 bit addresses only

			lda #irq & $ff		//Mask lower 8 bits
			sta $0314
			lda #irq >> 8		//Shift right/down the upper 8 bits
			sta $0315

			cli

			ldx #0
			
:			lda text,x
			beq +
			jsr $ffd2
			inx
			jmp -

:			rts		
		
text:		petscii "hello world",0

irq:		inc $d020
			jmp $ea31
