#pragma once

macro init_raster_irq
{
		lda #$7f
		sta $dc0d
		sta $dd0d

		lda $dc0d
		lda $dd0d

		lda #$01
		sta $d01a
}

macro set_raster_irq #@line, @start
{
		lda #line
		sta $d012

		lda #start & 255
		sta $fffe
		lda #start >> 8
		sta $ffff
}

macro vsync
{
.vs1:
		lda $d011
		bpl .vs1
.vs2:
		lda $d011
		bmi .vs2
}

macro vsync_stable
{
		vsync

		ldx $d012			// Achieve an initial stable raster point
		inx					// using halve invariance method
.wait2:		cpx $d012
		bne .wait2
		ldy #$0a
.wait3:		dey
		bne .wait3
		inx
		cpx $d012
		nop
		beq .wait4
		nop
		bit $24
.wait4:		ldy #$09
.wait5:		dey
		bne .wait5
		nop
		nop
		inx
		cpx $d012
		nop
		beq .wait6
		bit $24
.wait6:		ldy #$0a
.wait7:		dey
		bne .wait7
		inx
		cpx $d012
		bne .wait8
.wait8:		ldx #$13
.wait9:		dex
		bne .wait9
		nop
		nop				// We are stable at this point, so start timer!

}

macro init_cia_sync
{
		lda #$00			// Disable all interferences
		sta $d015			// for a stable timer
		
		lda #$7f
		sta $dc0d
		bit $dc0d

		vsync_stable

		lda #$3e			// Start a continious timer
		sta $dc04			// with 63 ticks each loop
		sty $dc05
		lda #%00010001
		sta $dc0e
}

macro cia_sync
{
.start:
.cycleperfect:	sec
				sbc $dc04		// check against timer
				sta bplcode+1		// and act accordingly
.bplcode:		bpl bplcode1
.bplcode1:
				for(int r=0;r<48;r++)
				{
					lda #$a9
				}
				//lua { local i; for i=0, 48, 1 do asm("lda #$a9") end }
				lda #$a5
				nop
}
