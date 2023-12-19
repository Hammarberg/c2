#include "c2/c64/c64.s"
#include "c2/mos/6502_word.s"

			// picscroll

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

macro vsync
{
.vs1:
		lda $d011
		bpl .vs1
.vs2:
		lda $d011
		bmi .vs2
}

macro reset_vic
{
	lda #$1b
	sta $d011
	lda #$c8
	sta $d016
	lda #$15
	sta $d018
	set_bank_addr $0000
	lda #$00
	sta $d015
	sta $d017
	sta $d01b
	sta $d01c
	sta $d01d
}

macro set_bank_addr @n
{
	lda #3-(n>>14)
	sta $dd00
}

/*
vscroll		0-7 vertical scroll steps
rows25		0 for 24 rows, 1 for 25 rows
screen_on	0 for screen off, 1 for screen on
bitmap		0 for text, 1 for bitmap
extended	0 for normal, 1 for extended color mode
raster_hi	8th raster bit

Default set_d011 3, 1, 1, 0, 0, 0
*/
macro set_d011 @vscroll, @rows25, @screen_on, @bitmap, @extended ,@raster_hi
{
	lda #(vscroll&7) | ((rows25&1) << 3) | ((screen_on&1) << 4) | ((bitmap&1) << 5) | ((extended&1) << 6) | ((raster_hi&1) << 7)
	sta $d011
}

/*
hscroll		0-7 horizontal scroll steps
cols40		0 for 38 columns, 1 for 40 columns
multicolor	0 for single color, 1 for multicolor

Default set_d016 0, 1, 0
*/
macro set_d016 @hscroll, @cols40, @multicolor
{
	lda #(hscroll&7) | ((cols40&1) << 3) | ((multicolor&1) << 4)
	sta $d016
}

/*
font	font location within current bank or bitmap location within current bank in hires mode, must be divisable by $0800. $1000 and $9000 are occupied by ROM font
screen	screen location within current bank, must be divisable by $0400
Default: set_d018 $1000, $0400
*/
macro set_d018 @font, @screen
{
	lda # (((screen&$3fff)/$0400) << 4) | (((font&$3fff)/$0800) << 1)
	sta $d018
}

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
			@ = $0800
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

			reset_vic
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

