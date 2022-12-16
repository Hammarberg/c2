#include "c2/c64/c64.s"
#include "c2/c64/kernal.s"

			var zpsize = depack.exit-depack

			c2_info("Depacker lowmem size %d", int(copyend-copystart))
			c2_info("Can depack from $%04x", int(depack + copyend-copystart + zpsize))

			basic_startup

			sei
			lda #$34
			sta $01

			// Save affected zp to stack area
			ldx #zpsize - 1
:			lda depack,x
			sta depack.end,x
			dex
			bpl -

			// Move depacker to zp and beginning of stack
			ldx #copyend-copystart-1
:			lda copystart,x
			sta var(depack,16),x
			dex
			bpl -
			jmp depack.copydown

			/*
				Backwards depacking
				0 eof
				1-127 litteral bytes
				-1 = -127 rle
			*/
copystart:
			@ = @, $0100 - zpsize
depack:
.tmp:		byte 0
.copydown:
.csh:		ldx #0
.csl:		ldy #0
			beq .dx

.cs:		lda $0000,y
.cd:		sta $0000,y
			iny
			bne .cs
.dx:		dex
			bmi .reenter
			inc .cs+2
			inc .cd+2
			bne .cs		//bra sinse it always jumps

.rle:		clc
			sbc #0
			eor #$ff
			sta .tmp
			tay
			jsr .subdst
			jsr .pop
			dey
.da:		sta $ffff,y
			dey
			bpl -

.reenter:	jsr .pop
			bmi .rle
			beq .exit

			sta .tmp
			tay
			jsr .subsrc
			dey

.sa:		lda $ffff,y
			sta (.da+1),y
			dey
			bpl -
			bmi .reenter

.subsrc:	sec
			lda .sa+1
			sbc .tmp
			sta .sa+1
			bcs +
			dec .sa+2
.subdst:	sec
			lda .da+1
			sbc .tmp
			sta .da+1
			bcs +
			dec .da+2
:			rts
.pop:
			dec .sa+1
			bne +
			dec .sa+2
:			lda (.sa+1,x)
			rts
.exit:
			// Restore zp
			ldx #zpsize - 1
:			lda depack.end,x
			sta depack,x
			dex
			bpl -
			lda #$37
			sta $01
			cli
.jump:		jmp $ffff

.end:
			@ = @
copyend:
