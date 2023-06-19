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
    BYTE $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    BYTE $01, $7C, $42, $42, $42, $42, $3E, $80, $FE, $FE, $FC, $FC, $FC, $FC, $C0, $00
    BYTE $00, $62, $52, $52, $4A, $4A, $44, $00, $00, $72, $52, $5A, $5A, $4A, $4E, $00
    BYTE $00, $3E, $40, $78, $40, $40, $3E, $00, $00, $7E, $40, $78, $40, $40, $7E, $00
    BYTE $00, $3E, $40, $3C, $02, $02, $7C, $00, $00, $7E, $40, $7E, $02, $02, $7E, $00
    BYTE $3C, $4E, $B7, $A7, $CF, $F9, $72, $3C, $00, $30, $78, $78, $30, $00, $00, $00


