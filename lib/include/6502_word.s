#pragma once

//-------------------------------------------------------------------------------
// 16 bit macros
//-------------------------------------------------------------------------------

// (d) = (s)
macro move16 @s, @d {
	lda s
	sta d
	lda s+1
	sta d+1
}

// (d+X) = (s)
macro move16 @s, @d,x {
	lda s
	sta d,x
	lda s+1
	sta d+1,x
}

// (d+Y) = (s)
macro move16 @s, @d,y {
	lda s
	sta d,y
	lda s+1
	sta d+1,y
}

// (d) = (s+X)
macro move16 @s,x , @d {
	lda s,x
	sta d
	lda s+1,x
	sta d+1
}

// (d+X) = (s+X)
macro move16 @s,x , @d,x {
	lda s,x
	sta d,x
	lda s+1,x
	sta d+1,x
}

// (d+Y) = (s+X)
macro move16 @s,x , @d,y {
	lda s,x
	sta d,y
	lda s+1,x
	sta d+1,y
}

// (d) = (s+Y)
macro move16 @s,y , @d {
	lda s,y
	sta d
	lda s+1,y
	sta d+1
}

// (d+X) = (s+Y)
macro move16 @s,y , @d,x {
	lda s,y
	sta d,x
	lda s+1,y
	sta d+1,x
}

// (d+Y) = (s+Y)
macro move16 @s,y , @d,y {
	lda s,y
	sta d,y
	lda s+1,y
	sta d+1,y
}

// (d) = (s) using X
macro move16x @s, @d {
	ldx s
	stx d
	ldx s+1
	stx d+1
}

// (d) = i
macro move16 #@i, @d {
	lda #i&255
	sta d
	lda #i>>8
	sta d+1
}

// (d+X) = i
macro move16 #@i, @d,x {
	lda #i&255
	sta d,x
	lda #i>>8
	sta d+1,x
}

// (d+Y) = i
macro move16 #@i, @d,y {
	lda #i&255
	sta d,y
	lda #i>>8
	sta d+1,y
}

// (d) = i using X
macro move16x #@i, @d {
	ldx #i&255
	stx d
	ldx #i>>8
	stx d+1
}

// (d) = (d) + 1
macro inc16 @d {
	inc d
	bne .br
	inc d+1
.br:
}

// (d) = (d) - 1
macro dec16 @d {
	lda d
	bne .br
	dec d+1
.br:
	dec d
}

// (d) = (d) + (s)
macro add16 @s, @d {
	lda s
	adc d
	sta d
	lda s+1
	adc d+1
	sta d+1
}

// (d) = (d) + i
macro add16 #@i, @d {
	lda #i&255
	adc d
	sta d
	lda #i>>8
	adc d+1
	sta d+1
}

// (d) = (d) + A
macro adda16 @d {
	adc d
	sta d
	lda #0
	adc d+1
	sta d+1
}

// (d) = (d) - (s)
macro sub16 @s, @d {
	lda d
	sbc s
	sta d
	lda d+1
	sbc s+1
	sta d+1
}

// (o) = (d) - (s)
macro sub16 @s, @d, @o {
	lda d
	sbc s
	sta o
	lda d+1
	sbc s+1
	sta o+1
}

// (d) = (d) - i
macro sub16 #@i, @d {
	lda d
	sbc #i&
	sta d
	bcs .br1
	dec d+1
.br1:
}

// (d) = (d) - i, branch to br if high byte is unaffected
macro sub16 #@i, @d, br:16 {
	lda d
	sbc #i
	sta d
	bcs br
	dec d+1
}

// Macro overload for 16 bit immidiate value
// (d) = (d) - i
macro sub16 #i:16, @d {
	lda d
	sbc #i&255
	sta d
	lda d+1
	sbc #i>>8
	sta d+1
}

// (d) = (d) - A
macro suba16 @d {
	eor #$ff
	adc d
	sta d
	bcs .br1
	dec d+1
.br1:
}

// (d) = (d) - A, branch to br if high byte is unaffected
macro suba16 @d, br:16 {
	eor #$ff
	adc d
	sta d
	bcs br
	dec d+1
}

// (d) exchange value with (s) via stack
macro swap16 @s, @d {
	lda d
	pha
	lda s
	sta d
	pla
	sta s
	lda d+1
	pha
	lda s+1
	sta d+1
	pla
	sta s+1
}

// (d) exchange value with (s), garbage X
macro swap16x @s, @d {
	ldx d
	lda s
	sta d
	stx s
	ldx d+1
	lda s+1
	sta d+1
	stx s+1
}

// (d) != (s), branch to br if not equal
macro cmp16bne @s, @d, br:16 {
	lda s
	cmp d
	bne br
	lda s+1
	cmp d+1
	bne br
}

// (d) != i, branch to br if not equal
macro cmp16bne #@i, @d, br:16 {
	lda #i&255
	cmp d
	bne br
	lda #i>>8
	cmp d+1
	bne br
}

// (d) == (s), branch to br if equal
macro cmp16beq @s, @d, br:16 {
	lda s
	cmp d
	bne .br
	lda s+1
	cmp d+1
	beq br
.br:
}

// (d) == (s), branch to br if equal
macro cmp16beq #@i, @d, br:16 {
	lda #i&255
	cmp d
	bne .br
	lda #i>>8
	cmp d+1
	beq br
.br:
}

// Uses 8 bits of (s) and 16 bits of (d)
// (d) = (d) * (s), uses one byte at (tmp), garbage X
macro mul16 @s, @d, tmp:0 {
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
macro push16 #i:16
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

