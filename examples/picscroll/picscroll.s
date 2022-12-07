#include "c64.s"
#include "c64_vic2.s"
#include "c64_irq.s"

			// picscroll

macro move16 #@i, @d
{
	lda #i&255
	sta d
	lda #i>>8
	sta d+1
}

macro inc16 @d
{
	inc d
	bne .br
	inc d+1
.br:
}

macro tile_sprites_x @num, @width, @left
{
	int high = 0, x = left;
	for(int r=0;r<num;r++)
	{
		lda #x&255
		sta $d000+2*r
		high |= (x >> 8) << r;
		x += width;
	}

	lda #high
	sta $d010
}


#define SCREEN $0400
#define COLOR $d800
#define FONT $d000

#define SPRITE_EXPAND 1

#define TAU (3.14159265359*2)
#define SINELENGTH (256)
#define CHARHEIGHT (8 + (8 * SPRITE_EXPAND))

#define KOALA "dark_faces.kla"

			var sid_init
			var sid_play

			loadsid("Think_Twice_III.sid", sid_init, sid_play);

			@ = $0002
zp_start:
zp_rol:		byte 0
zp_frol:	word 0

zp_end:
			@ = $0801
start:
			sei

			vsync

			ldx #$ff
			txs
			lda #$35
			sta $01

			// Clear zp addresses
			lda #0
			ldx #zp_end-zp_start-1
:			sta zp_start,x
			dex
			bpl -

			reset_vic_open
			set_d011 3, 1, 1, 1, 0, 0
			set_d016 0, 1, 1
			set_d018 $2000, $0400

			lda #loadvar(KOALA, 2+10000, 1)
			sta $d020
			sta $d021

			ldx #0
:			lda koala_screen + 256 * 0,x
			sta SCREEN       + 256 * 0,x
			lda koala_screen + 256 * 1,x
			sta SCREEN       + 256 * 1,x
			lda koala_screen + 256 * 2,x
			sta SCREEN       + 256 * 2,x
			lda koala_screen + 256 * 3,x
			sta SCREEN       + 256 * 3,x
			lda koala_color  + 256 * 0,x
			sta COLOR        + 256 * 0,x
			lda koala_color  + 256 * 1,x
			sta COLOR        + 256 * 1,x
			lda koala_color  + 256 * 2,x
			sta COLOR        + 256 * 2,x
			lda koala_color  + 256 * 3,x
			sta COLOR        + 256 * 3,x
			inx
			bne -

			lda #%01111111
			sta $d015
			sta $d01d
#if SPRITE_EXPAND == 1
			sta $d017
#endif

			ldy #(sprites&$3fff)/64
			ldx #0

:			lda #1
			sta $d027,x
			tya
			sta $07f8,x
			iny
			inx
			cpx #7
			bne -

			tile_sprites_x 7, 48, 24

			init_raster_irq
			set_raster_irq #$ff, irq1
			inc $d019
			cli

			lda #0
			jsr sid_init

			jmp @

			rts
irq1:
			//inc $d020
			jsr sid_play
			jsr scroll
			jsr spritey
			//dec $d020

			inc $d019
			rti

scroll:		lda zp_rol
			and #7
			bne .roller

			clc
.read:		lda text
			bne +
			move16 #text, .read+1
			jmp .read

:			adc #(FONT>>3)&255
			sta zp_frol+0
			lda #0
			adc #(FONT>>3)>>8
			sta zp_frol+1

			// Mul 8
			asl zp_frol+0
			rol zp_frol+1
			asl zp_frol+0
			rol zp_frol+1
			asl zp_frol+0
			rol zp_frol+1

			ldy #0
			ldx #0

			lda #$33
			sta $01

:			lda (zp_frol),y
			sta sprites + 64*6+2,x
			inx
			inx
			inx
			iny
			cpy #8
			bne -

			lda #$35
			sta $01

			inc16 .read+1

.roller:
			ldx #0

:			asl sprites + 64 * 6 + 2,x
			rol sprites + 64 * 6 + 1,x
			rol sprites + 64 * 6 + 0,x

			rol sprites + 64 * 5 + 2,x
			rol sprites + 64 * 5 + 1,x
			rol sprites + 64 * 5 + 0,x

			rol sprites + 64 * 4 + 2,x
			rol sprites + 64 * 4 + 1,x
			rol sprites + 64 * 4 + 0,x

			rol sprites + 64 * 3 + 2,x
			rol sprites + 64 * 3 + 1,x
			rol sprites + 64 * 3 + 0,x

			rol sprites + 64 * 2 + 2,x
			rol sprites + 64 * 2 + 1,x
			rol sprites + 64 * 2 + 0,x

			rol sprites + 64 * 1 + 2,x
			rol sprites + 64 * 1 + 1,x
			rol sprites + 64 * 1 + 0,x

			rol sprites + 64 * 0 + 2,x
			rol sprites + 64 * 0 + 1,x
			rol sprites + 64 * 0 + 0,x

			inx
			inx
			inx

			cpx #3 * 8
			bne -

			dec zp_rol

			rts
spritey:
.read:		lda siny
			cmp #$ff
			bne +

			move16 #siny, .read+1
			jmp -


:			ldx #0
:			sta $d001,x
			inx
			inx
			cpx #7*2
			bne -

			inc16 .read+1

			rts

siny:
			for(int r=0;r<SINELENGTH;r++)
			{
				byte int(50 + 100 - CHARHEIGHT/2 + (sin((r/double(SINELENGTH)) * TAU) * (100-CHARHEIGHT/2)) + 0.5)
			}

			byte $ff	// end marker


			align 64
sprites:
			for(int r=0;r<7*64;r++)
				byte $00


			@ = $2000
koala_bitmap:
			incprg KOALA, 0, 8000
koala_screen:
			incprg KOALA, 8000, 1000
koala_color:
			incprg KOALA, 9000, 1000

text:		screencode "upon request by bryan pope. "
			screencode "lorem ipsum dolor sit amet, consectetur adipiscing elit. duis feugiat, ligula at dignissim maximus, tellus nibh porttitor nulla, a vulputate diam felis at ligula. cras quis iaculis lorem. pellentesque venenatis feugiat nisl, ut imperdiet velit consectetur non. nulla rhoncus vestibulum felis. pellentesque sodales euismod imperdiet. aenean eu commodo purus. ut tempus neque ut arcu sollicitudin, sed ullamcorper mi bibendum. phasellus tempor velit et velit accumsan, sed ultrices urna mollis.",0

