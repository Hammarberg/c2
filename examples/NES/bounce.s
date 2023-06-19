//
//	NOTE 
//	this is bare minimum NES example. 
//	check out www.nesdev.org for more tutorials. 
//	

#include "c2/nes/nes.s"


macro FILL @n
{
    for(int r=0;r<n;r++)
    {
        BYTE 0
    }
}

#define MAX_Sprites 24

//  define ZP usage
                    @ = $0
zpSource:       word 0
//  fits in ZP 
Sprites:
.id:                fill MAX_Sprites
.attr:          fill MAX_Sprites
.xmove:         fill MAX_Sprites
.ymove:         fill MAX_Sprites
//.yposition:   fill MAX_Sprites
//.xposition:   fill MAX_Sprites

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
.clrmem:
	lda #$00 
	sta $000,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	lda $8020,x
	sta $700,x
	inx
	bne .clrmem
	
	jsr SpritePositionSetup
	jsr PPU_CopyExampleData
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

SpritePositionSetup:
//  set up default move 
//  we're just grabbing ROM data and mapping it to -1 or 1 
	ldx #$00 
.resetSpr:
	lda $8001,x 
	and #1 
	tay 
	lda Data.Directions,y 
	sta Sprites.xmove,x

	lda $801f,x 
	and #1 
	tay 
	lda Data.Directions,y 
	sta Sprites.ymove,x 

	//  make the sprite ID the ball 
	lda #$5
	sta Sprites.id,x
	inx 
	cpx #MAX_Sprites
	bne .resetSpr

	rts

PPU_CopyExampleData:
//  copy NAMETABLE
	lda #Data.NameTable&255
	sta zpSource
	lda #Data.NameTable>>8
	sta zpSource+1
	//  to $2000 in the PPU
	PPU_setaddr #$2000
	//  4 pages
	ldx #$04
	ldy #$00 
.ppu_copy:
	lda (zpSource),y
	sta PPU.Data
	iny 
	bne .ppu_copy
	inc zpSource+1
	dex 
	bne .ppu_copy 

	PPU_vwait

//  copy colors to $3f00 in the PPU 
	PPU_setaddr #$3f00
	ldx #$00 
.pal_copy:
	lda Data.Palette,x 
	sta PPU.Data 
	inx 
	cpx #$10 
	bne .pal_copy
	//  copy same palette to Sprites ( and BG color )
	//  copy colors to $3f10 in the PPU 
	ldx #$00 
.pal_copy2:
	lda Data.Palette,x 
	sta PPU.Data 
	inx 
	cpx #$10 
	bne .pal_copy2
	rts

onNMI:
{
	pha
	txa
	pha
	tya
	pha


	//  update the Sprites
	ldy #$00  
	ldx #$00 
.sprCopy:   
	clc
	lda OAM_BUFFER,y 
	adc Sprites.ymove,x
	sta OAM_BUFFER,y 
	cmp #240
	bcc .nbounceY 
	lda Sprites.ymove,x 
	eor #$ff
	adc #0 
	sta Sprites.ymove,x
.nbounceY:

	lda Sprites.id,x 
	sta OAM_BUFFER+1,y 
	lda Sprites.attr,x 
	sta OAM_BUFFER+2,y 
	clc
	lda OAM_BUFFER+3,y 
	adc Sprites.xmove,x 
	sta OAM_BUFFER+3,y
	cmp #0 
	bne .nbounceX 
	lda Sprites.xmove,x 
	eor #$ff 
	adc #0 
	sta Sprites.xmove,x
.nbounceX:

	iny 
	iny 
	iny 
	iny 
	inx 
	cpx #MAX_Sprites
	bne .sprCopy 

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


//  in code ROM space
Data:
.Directions:
    BYTE $ff,1

.NameTable:
    //  screenData
    BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$02,$03,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    BYTE $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
    //  attribs
    BYTE $14,$0e,$04,$0e,$04,$0e,$04,$0e
    BYTE $32,$00,$00,$00,$00,$00,$00,$84
    BYTE $10,$00,$00,$00,$00,$00,$00,$0c
    BYTE $32,$00,$00,$00,$00,$00,$00,$84
    BYTE $10,$00,$00,$00,$00,$00,$00,$0c
    BYTE $32,$00,$00,$00,$00,$00,$00,$84
    BYTE $10,$00,$00,$00,$00,$00,$00,$0c
    BYTE $0e,$04,$0e,$04,$0e,$04,$03,$05

.Palette:
    byte $0f,$00,$10,$30,$0f,$01,$21,$31,$0f,$06,$16,$38,$0f,$09,$19,$3a

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





