#include "c2/c64/c64.s"
#include "c2/mos/6502.s"

#define PI 3.14159265359



		var addrZeropage = $10
		var addrCharset = $2000
		var addrScreen = $2400




		// --- gfxmode  ----------------------------------------------------------------------------------------------------
						// SCROLY Vertical Fine Scrolling and Control Register
		var d011SCROLY = %01011011	// Bits -2:  Fine scroll display vertically by X scan lines (0-7)
						// Bit 3:  Select a 24-row or 25-row text display (1=25 rows, =24 rows)
						// Bit 4:  Blank the entire screen to the same color as the background (0=blank)
						// Bit 5:  Enable bitmap graphics mode (1=enable)
						// Bit 6:  Enable extended color text mode (1=enable)
						// Bit 7:  High bit (Bit 8) of raster compare register at 53266 ($D012)

						// SCROLX Horizontal Fine Scrolling and Control Register		
		var d016SCROLX = %00001000	// Bits -2: Fine scroll display horizontally by X dot positions (0-7)
						// Bit 3: Select a 38-column or 40-column text display (1=40 columns,0=38 columns)
						// Bit 4: Enable multicolor text or multicolor bitmap mode (1= multicolor on, =multicolor off)
						// Bit 5: Video chip reset (O=normal operation, 1= video completely off)
						// Bits 6-7: Unused
							




		// --- plasma variables ----------------------------------------------------------------------------------------------------

		var yStart = 0
		var yStop = 25
		
		var xStart = 3
		var xStop = 37
				
		var centerX = 20
		var centerY = 12

		var colourSet = { 0, 11, 12, 15, 1, 15, 12, 11 }
		var colourSet2 = { 0, 6, 3, 13, 1, 7, 10, 2 }




		// --- macros ----------------------------------------------------------------------------------------------------

macro fillbyte @d, @l
{
	for (int i=0; i<l; i++)
		byte d
}

macro move8 #@i, @d
{
	lda #i
	sta d
}

macro move8 @i, @d
{
	lda i
	sta d
}

macro move16 #@i, @d
{
	lda #i&255
	sta d
	lda #i>>8
	sta d+1
}

macro enterIRQ
{
	pha
	txa
	pha
	tya
	pha
}

macro exitIRQ
{
	pla
	tay
	pla
	tax
	pla
}

macro lbne @a
{
	beq +
	jmp a
:
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

		// --- zero page ------------------------------------------------------------------------------------------------------

		@ = addrZeropage

		ZPraster:	byte 0





		// --------------------------------------------------------------------------------------------------------------------

		basic_startup

		jmp codeStart





		// --- charset --------------------------------------------------------------------------------------------------------

		@ = addrCharset

		word $0000,$0000,$0000,$0000,$0010,$0000,$0010,$0000,$0010,$0004,$0010,$0004,$0010,$8004,$0010,$8004
		word $0210,$8004,$0210,$8004,$2210,$8004,$2210,$8004,$2210,$8204,$2210,$8204,$2210,$8214,$2210,$8214
		word $2250,$8214,$2250,$8214,$2250,$8215,$2250,$8215,$2a50,$8215,$2a50,$8215,$2a50,$a215,$2a50,$a215
		word $2a51,$a215,$2a51,$a215,$2a51,$aa15,$2a51,$aa15,$aa51,$aa15,$aa51,$aa15,$aa55,$aa15,$aa55,$aa15
		word $aa55,$aa55,$aa55,$aa55,$aa5d,$aa55,$aa5d,$aa55,$aa5d,$ea55,$aa5d,$ea55,$aa5d,$ea57,$aa5d,$ea57
		word $ab5d,$ea57,$ab5d,$ea57,$abdd,$ea57,$abdd,$ea57,$abdd,$ea5f,$abdd,$ea5f,$afdd,$ea5f,$afdd,$ea5f
		word $afdd,$fa5f,$afdd,$fa5f,$afdd,$fb5f,$afdd,$fb5f,$efdd,$fb5f,$efdd,$fb5f,$efdd,$fb7f,$efdd,$fb7f
		word $efdf,$fb7f,$efdf,$fb7f,$ffdf,$fb7f,$ffdf,$fb7f,$ffdf,$fbff,$ffdf,$fbff,$ffff,$fbff,$ffff,$fbff
		word $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$fffe,$ffff,$ffff,$ffff,$ff00,$ffff,$ffff,$ffff,$ff7f
		word $7f7f,$7f7f,$7f7f,$7f7f,$7fff,$ffff,$ffff,$ffff,$00ff,$ffff,$ffff,$ffff,$feff,$ffff,$ffff,$ffff
		word $fefe,$fefe,$fefe,$fefe





		// --- screen ---------------------------------------------------------------------------------------------------------

		@ = addrScreen

		fillbyte 0, 1000





		// --- CODE STARTS HERE -----------------------------------------------------------------------------------------------

codeStart:	sei

		move8 #$35, $01

		lda #$7f
		sta $dc0d
		sta $dd0d
		lda $dc0d		// ACK any pending interrupts
		lda $dd0d

		move8 #$2f, ZPraster	// start line for second IRQ

		move8 #0, $d020		// some colours could cheer things up right ?
		move8 #colourSet[0], $d021
		move8 #colourSet[2], $d022
		move8 #colourSet[4], $d023
		move8 #colourSet[6], $d024

		vsync			// wait for a VBLANK

		move8 #d011SCROLY, $d011
		move8 #d016SCROLX, $d016
		move8 #3-(addrScreen>>14), $dd00	// no need to set the VICbank maybe...?
		move8 #(((addrScreen&$3fff)/$0400)<<4) | ((addrCharset&$3fff)/$0400), $d018

		move8 #1, $d01a
		move8 #$2c, $d012
		move16 #IRQmain, $fffe
		lsr $d019
		cli



		// --- MAINLOOP (outside IRQ) --------------------------------------------------------------------------------------------

mainLoop:	dey	// main counter
		
		for (int y=yStart; y<yStop; y++)
		{
			for (int x=xStart; x<xStop; x++)
			{
				int radius = (int) (sqrt((x-centerX)*(x-centerX) + (y-centerY)*(y-centerY))*1.5);
				int angle = atan2(x-centerX, y-centerY)*21;
		
				// c = angle*2+sinus[radius+sinus[(radius+counter)]]

				tya
				adc #radius
				tax
				lda tbl_sinPlasma,x
				adc #radius
				tax
				lda tbl_sinPlasma,x			
				adc #angle*2
		
				tax
				lda tbl_colours,x
				sta $d800+x+y*40
				lda tbl_chars,x			// maybe someone can do this in a more clever way?
				sta addrScreen+x+y*40
			}
		}

		jmp mainLoop



		// --- IRQ ------------------------------------------------------------------------------------------------------------

IRQmain:	enterIRQ

		move8 #d011SCROLY, $d011 	// set normal screen

		lda ZPraster
		cmp #$fe
		lbne .noChange

		// --- change colours ---------

		lda #colourSet2[1]
		ldx #colourSet2[3]
		ldy #colourSet2[5]
		
		for(int i=0; i<64; i++)
		{
			sta tbl_colours+i
			stx tbl_colours+i+64
			sty tbl_colours+i+128
		}

		lda #colourSet2[7]

		for(int i=0; i<64; i++)
			sta tbl_colours+i+192

		move8 #colourSet2[0], $d021
		move8 #colourSet2[2], $d022
		move8 #colourSet2[4], $d023
		move8 #colourSet2[6], $d024



		// ----------------------------

.noChange:	ldx ZPraster
		lda tbl_sinFade,x
		
		cpx #$ff 		// are we done ?
		beq +

		inc ZPraster		// move it, move it

:		sta $d012
		move16 #IRQlast, $fffe
		
		lsr $d019
		exitIRQ
		rti

		

		// second IRQ, moving rasterline

IRQlast:	enterIRQ

		lda $d012		// wait for the next raster line
:		cmp $d012		// seems to make it slighty smoother...
		beq -

		move8 #%01111000, $d011 // blank the screen (both ECM and bitmap mode enabled)

		move8 #$2c, $d012
		move16 #IRQmain, $fffe
		lsr $d019

		exitIRQ
		rti



		// --- Tables ---------------------------------------------------------------------------------------------------------

		align 256

		// conversion table for the chars, maybe this can be done in a smarter way by rearranging something?
tbl_chars:	byte 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31		
		byte 95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64
		byte 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95
		byte 159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,134,133,132,131,130,129,128
		byte 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159
		byte 223,222,221,220,219,218,217,216,215,214,213,212,211,210,209,208,207,206,205,204,203,202,201,200,199,198,197,196,195,194,193,192
		byte 192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223
		byte 31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0



		// colour table used for colourRAM
tbl_colours:	fillbyte colourSet[1], 64
		fillbyte colourSet[3], 64
		fillbyte colourSet[5], 64
		fillbyte colourSet[7], 64
		

		// sinus used for the plasma
tbl_sinPlasma:	for(int i=0; i<256; i++)
			byte (int) (sin(2*i*2*PI/256)*80)
		
		// sinus used for the "fade in"
tbl_sinFade:	for(int i=0; i<256; i++)
			byte (int) (i+sin(6*i*2*PI/256)*25)

