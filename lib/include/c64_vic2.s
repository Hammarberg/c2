#pragma once

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

macro set_bank @n
{
	//lda $dd00
	//and #%11111100
	//ora #n & %00000011
	lda #n
	sta $dd00
}

macro set_bank_addr @n
{
	lda #3-(n>>14)
	sta $dd00
}

macro reset_vic_open
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

macro reset_vic_close
{
	lda #$0b
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
