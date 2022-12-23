/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "6502.s"

#define C2_6502_WORD

//-------------------------------------------------------------------------------
// 16 bit macros
//-------------------------------------------------------------------------------

// (d) = (s)
macro move16 @s, @d
{
	lda s
	sta d
	lda s+1
	sta d+1
}

// (d+X) = (s)
macro move16 @s, @d,x
{
	lda s
	sta d,x
	lda s+1
	sta d+1,x
}

// (d+Y) = (s)
macro move16 @s, @d,y
{
	lda s
	sta d,y
	lda s+1
	sta d+1,y
}

// (d) = (s+X)
macro move16 @s,x , @d
{
	lda s,x
	sta d
	lda s+1,x
	sta d+1
}

// (d+X) = (s+X)
macro move16 @s,x , @d,x
{
	lda s,x
	sta d,x
	lda s+1,x
	sta d+1,x
}

// (d+Y) = (s+X)
macro move16 @s,x , @d,y
{
	lda s,x
	sta d,y
	lda s+1,x
	sta d+1,y
}

// (d) = (s+Y)
macro move16 @s,y , @d
{
	lda s,y
	sta d
	lda s+1,y
	sta d+1
}

// (d+X) = (s+Y)
macro move16 @s,y , @d,x
{
	lda s,y
	sta d,x
	lda s+1,y
	sta d+1,x
}

// (d+Y) = (s+Y)
macro move16 @s,y , @d,y
{
	lda s,y
	sta d,y
	lda s+1,y
	sta d+1,y
}

// (d) = (s) using X
macro move16x @s, @d
{
	ldx s
	stx d
	ldx s+1
	stx d+1
}

// (d) = i
macro move16 #@i, @d
{
	lda #i&255
	sta d
	lda #i>>8
	sta d+1
}

// (d+X) = i
macro move16 #@i, @d,x
{
	lda #i&255
	sta d,x
	lda #i>>8
	sta d+1,x
}

// (d+Y) = i
macro move16 #@i, @d,y
{
	lda #i&255
	sta d,y
	lda #i>>8
	sta d+1,y
}

// (d) = i using X
macro move16x #@i, @d
{
	ldx #i&255
	stx d
	ldx #i>>8
	stx d+1
}

// (d) = (d) + 1
macro inc16 @d
{
	inc d
	bne +
	inc d+1
:
}

// (d) = (d) - 1
macro dec16 @d
{
	lda d
	bne +
	dec d+1
:
	dec d
}

// (d) = (d) + (s)
macro add16 @s, @d
{
	lda s
	adc d
	sta d
	lda s+1
	adc d+1
	sta d+1
}

// (d) = (d) + i
macro add16 #@i, @d
{
	lda #i&255
	adc d
	sta d
	lda #i>>8
	adc d+1
	sta d+1
}

// (d) = (d) + A
macro adda16 @d
{
	adc d
	sta d
	lda #0
	adc d+1
	sta d+1
}

// (d) = (d) - (s)
macro sub16 @s, @d
{
	lda d
	sbc s
	sta d
	lda d+1
	sbc s+1
	sta d+1
}

// (o) = (d) - (s)
macro sub16 @s, @d, @o
{
	lda d
	sbc s
	sta o
	lda d+1
	sbc s+1
	sta o+1
}

// (d) = (d) - i
macro sub16 #@i, @d
{
    if(i.bits() <= 8)
    {
		lda d
		sbc #i
		sta d
		bcs +
		dec d+1
:
	}
	else
	{
		lda d
		sbc #i&255
		sta d
		lda d+1
		sbc #i>>8
		sta d+1
	}
}

// (d) = (d) - i, branch to br if high byte is unaffected
macro sub16 #@i, @d, @br
{
    if(i.bits() <= 8)
    {
		lda d
		sbc #i
		sta d
		bcs br
		dec d+1
	}
	else
	{
		lda d
		sbc #i&255
		sta d
		lda d+1
		sbc #i>>8
		sta d+1
	}
}

// (d) = (d) - A
macro suba16 @d
{
	eor #$ff
	adc d
	sta d
	bcs +
	dec d+1
:
}

// (d) = (d) - A, branch to br if high byte is unaffected
macro suba16 @d, @br
{
	eor #$ff
	adc d
	sta d
	bcs br
	dec d+1
}

// (d) != (s), branch to br if not equal
macro cmp16bne @s, @d, @br
{
	lda s
	cmp d
	bne br
	lda s+1
	cmp d+1
	bne br
}

// (d) != i, branch to br if not equal
macro cmp16bne #@i, @d, @br
{
	lda #i&255
	cmp d
	bne br
	lda #i>>8
	cmp d+1
	bne br
}

// (d) == (s), branch to br if equal
macro cmp16beq @s, @d, @br
{
	lda s
	cmp d
	bne +
	lda s+1
	cmp d+1
	beq br
:
}

// (d) == (s), branch to br if equal
macro cmp16beq #@i, @d, @br
{
	lda #i&255
	cmp d
	bne +
	lda #i>>8
	cmp d+1
	beq br
:
}

// Uses 8 bits of (s) and 16 bits of (d)
// (d) = (d) * (s), uses one byte at (tmp), garbage X
macro mul16 @s, @d, @tmp
{
	lda s
	sta tmp
	lda #$00
	tax
	beq .enter
.doadd:
	clc
	adc d
	pha
	txa
	adc d+1
	tax
	pla
.loop:
	asl d
	rol d+1
.enter:
	lsr tmp
	bcs .doadd
	bne .loop
	sta d
	stx d+1
}

// (Stack) = (s)
macro push16 @s
{
	lda s
	pha
	lda s+1
	pha
}

// (Stack) = i
macro push16 #@i
{
	lda #i & 255
	pha
	lda #i >> 8
	pha
}

// (d) = (Stack)
macro pop16 @d
{
	pla
	sta d+1
	pla
	sta d
}

macro asl16 @s
{
	asl s
	rol s+1
}

macro lsr16 @s
{
	lsr s+1
	ror s
}

