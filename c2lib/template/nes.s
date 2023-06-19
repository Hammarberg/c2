//
//	NOTE 
//	this is bare minimum NES example. 
//	check out www.nesdev.org for more tutorials. 
//	

#include "c2/nes/nes.s"

	NES_HEADER MAPPER_HORIZONTAL,NES,NTSC,2,1
	@ = ROM_START 

//	pretty much NES boilerplate
onReset:
	ldx #$40
	stx IO.Input_0      // disable APU frame IRQ

	//  small stack because we have very little memory 
	ldx #$3f
	txs 
	//  clear PPU 
	//  switch display off
	ldx #$00 
	stx PPU.Control 
	stx PPU.Mask
	stx IO.DMC_freq

	PPU_vwait
// We now have about 30,000 cycles to burn before the PPU stabilizes.
// One thing we can do with this time is put RAM in a known state.
	ldx #$00
	lda #$00 
.clrmem:
	sta $000,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne .clrmem
	
	//	setup PPU state 
	//	and upload tiles and colors 
	PPU_setaddr #$2000

	//	set the top VRAM address to tile 1
	lda #$1 
	sta PPU.Data

	//	setup PPU state to colors 
	PPU_setaddr #$3f00

	lda #$F 	//	black
	sta PPU.Data
	lda #$0 	//	dark grey
	sta PPU.Data
	lda #$10 	//	mid grey 
	sta PPU.Data
	lda #$30 	//	white 
	sta PPU.Data


	//  Reset Scroll 
	//  NES can really freak out when writing to PPU so make sure to reset
	lda #$0
	sta PPU.Scroll
	sta PPU.Scroll

	//  enable NMI
	lda #CTRL_NMI_ON
	sta PPU.Control
	//  switch display back on 
	lda #Mask_BG_ON | Mask_SP_ON | %110
	sta PPU.Mask

.done: 
	jmp .done


onNMI:
{
	pha
	txa
	pha
	tya
	pha

	lda #OAM_BUFFER>>8      // update OAM
	sta IO.OAM_DMA

	pla
	tay
	pla
	tax
	pla 
}

onIRQ:
	rti

//	NO CODE or DATA after this, besides IRQ vectors and CHRROM 
//  IRQ vectors
	@ = $FFFA           
	WORD onNMI      //     NMI
	WORD onReset    //     RESET
	WORD onIRQ      //     IRQ

//  CHRROM Data
//	example tile data is limited purposefully

	@ = $10000
	//	blank
	BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	//	metalic brick type
	BYTE $01, $7C, $42, $42, $42, $42, $3E, $80, $FE, $FE, $FC, $FC, $FC, $FC, $C0, $00



