#include "c2/motorola/6809.s"

/*
	6809 opcode test inspired by lwtools tests/opcodes6809.pl

	http://www.lwtools.ca/

	These tests determine if the opcodes for each instruction, in each
	addressing mode, are correct.
*/

	// optest

	macro analyze @size
	{
		repeat(size)
		{
			var a = c2_peek(opstart+c2repn);
			var b = c2_peek(opstart+size+c2repn);
			if(a != b)
			{
				c2_info("a %02x b %02x", int(a), int(b));
				c2_error("assembled opcode doesn't match expected");
			}
		}
		opstart = @;
	}

	@ = $0000
	var opstart = @

	// 1: assembly text
	// 2: expected opcodes in byte statement
	// 3: analyze with expected opcode size

	stb <0
	byte $D7, $00
	analyze 2

	stb ,x
	byte $E7, $84
	analyze 2

	stb >0
	byte $F7, $00, $00
	analyze 3

	leas ,x
	byte $32, $84
	analyze 2

	lbls @
	byte $10, $23, $FF, $FC
	analyze 4

	jmp <0
	byte $0E, $00
	analyze 2

	jmp >0
	byte $7E, $00, $00
	analyze 3

	jmp ,x
	byte $6E, $84
	analyze 2

	deca
	byte $4A
	analyze 1

	puls cc
	byte $35, $01
	analyze 2

	bhs @
	byte $24, $FE
	analyze 2

	dec <0
	byte $0A, $00
	analyze 2

	dec >0
	byte $7A, $00, $00
	analyze 3

	dec ,x
	byte $6A, $84
	analyze 2

	lbgt @
	byte $10, $2E, $FF, $FC
	analyze 4

	ora #0
	byte $8A, $00
	analyze 2

	ora <0
	byte $9A, $00
	analyze 2

	ora ,x
	byte $AA, $84
	analyze 2

	ora >0
	byte $BA, $00, $00
	analyze 3

	subd #0
	byte $83, $00, $00
	analyze 3

	subd <0
	byte $93, $00
	analyze 2

	subd ,x
	byte $A3, $84
	analyze 2

	subd >0
	byte $B3, $00, $00
	analyze 3

	beq @
	byte $27, $FE
	analyze 2

	andb #0
	byte $C4, $00
	analyze 2

	andb <0
	byte $D4, $00
	analyze 2

	andb ,x
	byte $E4, $84
	analyze 2

	andb >0
	byte $F4, $00, $00
	analyze 3

	lbmi @
	byte $10, $2B, $FF, $FC
	analyze 4

	adda #0
	byte $8B, $00
	analyze 2

	adda <0
	byte $9B, $00
	analyze 2

	adda ,x
	byte $AB, $84
	analyze 2

	adda >0
	byte $BB, $00, $00
	analyze 3

	bne @
	byte $26, $FE
	analyze 2

	comb
	byte $53
	analyze 1

	lbge @
	byte $10, $2C, $FF, $FC
	analyze 4

	rorb
	byte $56
	analyze 1

	ldx #0
	byte $8E, $00, $00
	analyze 3

	ldx <0
	byte $9E, $00
	analyze 2

	ldx ,x
	byte $AE, $84
	analyze 2

	ldx >0
	byte $BE, $00, $00
	analyze 3

	std <0
	byte $DD, $00
	analyze 2

	std ,x
	byte $ED, $84
	analyze 2

	std >0
	byte $FD, $00, $00
	analyze 3

	incb
	byte $5C
	analyze 1

	lsrb
	byte $54
	analyze 1

	lbvs @
	byte $10, $29, $FF, $FC
	analyze 4

	pshs cc
	byte $34, $01
	analyze 2

	bgt @
	byte $2E, $FE
	analyze 2

	leax ,x
	byte $30, $84
	analyze 2

	negb
	byte $50
	analyze 1

	tst <0
	byte $0D, $00
	analyze 2

	tst >0
	byte $7D, $00, $00
	analyze 3

	tst ,x
	byte $6D, $84
	analyze 2

	ldu #0
	byte $CE, $00, $00
	analyze 3

	ldu <0
	byte $DE, $00
	analyze 2

	ldu ,x
	byte $EE, $84
	analyze 2

	ldu >0
	byte $FE, $00, $00
	analyze 3

	bitb #0
	byte $C5, $00
	analyze 2

	bitb <0
	byte $D5, $00
	analyze 2

	bitb ,x
	byte $E5, $84
	analyze 2

	bitb >0
	byte $F5, $00, $00
	analyze 3

	bcc @
	byte $24, $FE
	analyze 2

	tsta
	byte $4D
	analyze 1

	tfr a,a
	byte $1F, $88
	analyze 2

	adca #0
	byte $89, $00
	analyze 2

	adca <0
	byte $99, $00
	analyze 2

	adca ,x
	byte $A9, $84
	analyze 2

	adca >0
	byte $B9, $00, $00
	analyze 3

	cmpu #0
	byte $11, $83, $00, $00
	analyze 4

	cmpu <0
	byte $11, $93, $00
	analyze 3

	cmpu ,x
	byte $11, $A3, $84
	analyze 3

	cmpu >0
	byte $11, $B3, $00, $00
	analyze 4

	lds #0
	byte $10, $CE, $00, $00
	analyze 4

	lds <0
	byte $10, $DE, $00
	analyze 3

	lds ,x
	byte $10, $EE, $84
	analyze 3

	lds >0
	byte $10, $FE, $00, $00
	analyze 4

	bls @
	byte $23, $FE
	analyze 2

	ldy #0
	byte $10, $8E, $00, $00
	analyze 4

	ldy <0
	byte $10, $9E, $00
	analyze 3

	ldy ,x
	byte $10, $AE, $84
	analyze 3

	ldy >0
	byte $10, $BE, $00, $00
	analyze 4

	bvs @
	byte $29, $FE
	analyze 2

	rts
	byte $39
	analyze 1

	addd #0
	byte $C3, $00, $00
	analyze 3

	addd <0
	byte $D3, $00
	analyze 2

	addd ,x
	byte $E3, $84
	analyze 2

	addd >0
	byte $F3, $00, $00
	analyze 3

	bge @
	byte $2C, $FE
	analyze 2

	jsr <0
	byte $9D, $00
	analyze 2

	jsr ,x
	byte $AD, $84
	analyze 2

	jsr >0
	byte $BD, $00, $00
	analyze 3

	daa
	byte $19
	analyze 1

	swi2
	byte $10, $3F
	analyze 2

	eora #0
	byte $88, $00
	analyze 2

	eora <0
	byte $98, $00
	analyze 2

	eora ,x
	byte $A8, $84
	analyze 2

	eora >0
	byte $B8, $00, $00
	analyze 3

	suba #0
	byte $80, $00
	analyze 2

	suba <0
	byte $90, $00
	analyze 2

	suba ,x
	byte $A0, $84
	analyze 2

	suba >0
	byte $B0, $00, $00
	analyze 3

	swi3
	byte $11, $3F
	analyze 2

	lbeq @
	byte $10, $27, $FF, $FC
	analyze 4

	lbrn @
	byte $10, $21, $FF, $FC
	analyze 4

	asra
	byte $47
	analyze 1

	sbca #0
	byte $82, $00
	analyze 2

	sbca <0
	byte $92, $00
	analyze 2

	sbca ,x
	byte $A2, $84
	analyze 2

	sbca >0
	byte $B2, $00, $00
	analyze 3

	swi
	byte $3F
	analyze 1

	asr <0
	byte $07, $00
	analyze 2

	asr >0
	byte $77, $00, $00
	analyze 3

	asr ,x
	byte $67, $84
	analyze 2

	clrb
	byte $5F
	analyze 1

	rol <0
	byte $09, $00
	analyze 2

	rol >0
	byte $79, $00, $00
	analyze 3

	rol ,x
	byte $69, $84
	analyze 2

	cmpb #0
	byte $C1, $00
	analyze 2

	cmpb <0
	byte $D1, $00
	analyze 2

	cmpb ,x
	byte $E1, $84
	analyze 2

	cmpb >0
	byte $F1, $00, $00
	analyze 3

	lda #0
	byte $86, $00
	analyze 2

	lda <0
	byte $96, $00
	analyze 2

	lda ,x
	byte $A6, $84
	analyze 2

	lda >0
	byte $B6, $00, $00
	analyze 3

	leay ,x
	byte $31, $84
	analyze 2

	rola
	byte $49
	analyze 1

	lbhs @
	byte $10, $24, $FF, $FC
	analyze 4

	lsl <0
	byte $08, $00
	analyze 2

	lsl >0
	byte $78, $00, $00
	analyze 3

	lsl ,x
	byte $68, $84
	analyze 2

	lbvc @
	byte $10, $28, $FF, $FC
	analyze 4

	lsla
	byte $48
	analyze 1

	exg a,a
	byte $1E, $88
	analyze 2

	sbcb #0
	byte $C2, $00
	analyze 2

	sbcb <0
	byte $D2, $00
	analyze 2

	sbcb ,x
	byte $E2, $84
	analyze 2

	sbcb >0
	byte $F2, $00, $00
	analyze 3

	asrb
	byte $57
	analyze 1

	brn @
	byte $21, $FE
	analyze 2

	andcc #0
	byte $1C, $00
	analyze 2

	lbcc @
	byte $10, $24, $FF, $FC
	analyze 4

	cmps #0
	byte $11, $8C, $00, $00
	analyze 4

	cmps <0
	byte $11, $9C, $00
	analyze 3

	cmps ,x
	byte $11, $AC, $84
	analyze 3

	cmps >0
	byte $11, $BC, $00, $00
	analyze 4

	lbsr @
	byte $17, $FF, $FD
	analyze 3

	bvc @
	byte $28, $FE
	analyze 2

	ble @
	byte $2F, $FE
	analyze 2

	lbne @
	byte $10, $26, $FF, $FC
	analyze 4

	ldb #0
	byte $C6, $00
	analyze 2

	ldb <0
	byte $D6, $00
	analyze 2

	ldb ,x
	byte $E6, $84
	analyze 2

	ldb >0
	byte $F6, $00, $00
	analyze 3

	lslb
	byte $58
	analyze 1

	clra
	byte $4F
	analyze 1

	clr <0
	byte $0F, $00
	analyze 2

	clr >0
	byte $7F, $00, $00
	analyze 3

	clr ,x
	byte $6F, $84
	analyze 2

	cmpa #0
	byte $81, $00
	analyze 2

	cmpa <0
	byte $91, $00
	analyze 2

	cmpa ,x
	byte $A1, $84
	analyze 2

	cmpa >0
	byte $B1, $00, $00
	analyze 3

	rolb
	byte $59
	analyze 1

	orcc #0
	byte $1A, $00
	analyze 2

	mul
	byte $3D
	analyze 1

	stu <0
	byte $DF, $00
	analyze 2

	stu ,x
	byte $EF, $84
	analyze 2

	stu >0
	byte $FF, $00, $00
	analyze 3

	bpl @
	byte $2A, $FE
	analyze 2

	cwai #0
	byte $3C, $00
	analyze 2

	bsr @
	byte $8D, $FE
	analyze 2

	lbra @
	byte $16, $FF, $FD
	analyze 3

	cmpx #0
	byte $8C, $00, $00
	analyze 3

	cmpx <0
	byte $9C, $00
	analyze 2

	cmpx ,x
	byte $AC, $84
	analyze 2

	cmpx >0
	byte $BC, $00, $00
	analyze 3

	rti
	byte $3B
	analyze 1

	eorb #0
	byte $C8, $00
	analyze 2

	eorb <0
	byte $D8, $00
	analyze 2

	eorb ,x
	byte $E8, $84
	analyze 2

	eorb >0
	byte $F8, $00, $00
	analyze 3

	subb #0
	byte $C0, $00
	analyze 2

	subb <0
	byte $D0, $00
	analyze 2

	subb ,x
	byte $E0, $84
	analyze 2

	subb >0
	byte $F0, $00, $00
	analyze 3

	nop
	byte $12
	analyze 1

	stx <0
	byte $9F, $00
	analyze 2

	stx ,x
	byte $AF, $84
	analyze 2

	stx >0
	byte $BF, $00, $00
	analyze 3

	ldd #0
	byte $CC, $00, $00
	analyze 3

	ldd <0
	byte $DC, $00
	analyze 2

	ldd ,x
	byte $EC, $84
	analyze 2

	ldd >0
	byte $FC, $00, $00
	analyze 3

	lsra
	byte $44
	analyze 1

	inca
	byte $4C
	analyze 1

	inc <0
	byte $0C, $00
	analyze 2

	inc >0
	byte $7C, $00, $00
	analyze 3

	inc ,x
	byte $6C, $84
	analyze 2

	lsr <0
	byte $04, $00
	analyze 2

	lsr >0
	byte $74, $00, $00
	analyze 3

	lsr ,x
	byte $64, $84
	analyze 2

	leau ,x
	byte $33, $84
	analyze 2

	pulu cc
	byte $37, $01
	analyze 2

	lblt @
	byte $10, $2D, $FF, $FC
	analyze 4

	rora
	byte $46
	analyze 1

	sync
	byte $13
	analyze 1

	ror <0
	byte $06, $00
	analyze 2

	ror >0
	byte $76, $00, $00
	analyze 3

	ror ,x
	byte $66, $84
	analyze 2

	lbcs @
	byte $10, $25, $FF, $FC
	analyze 4

	lbhi @
	byte $10, $22, $FF, $FC
	analyze 4

	adcb #0
	byte $C9, $00
	analyze 2

	adcb <0
	byte $D9, $00
	analyze 2

	adcb ,x
	byte $E9, $84
	analyze 2

	adcb >0
	byte $F9, $00, $00
	analyze 3

	abx
	byte $3A
	analyze 1

	cmpd #0
	byte $10, $83, $00, $00
	analyze 4

	cmpd <0
	byte $10, $93, $00
	analyze 3

	cmpd ,x
	byte $10, $A3, $84
	analyze 3

	cmpd >0
	byte $10, $B3, $00, $00
	analyze 4

	nega
	byte $40
	analyze 1

	lble @
	byte $10, $2F, $FF, $FC
	analyze 4

	lblo @
	byte $10, $25, $FF, $FC
	analyze 4

	bmi @
	byte $2B, $FE
	analyze 2

	sty <0
	byte $10, $9F, $00
	analyze 3

	sty ,x
	byte $10, $AF, $84
	analyze 3

	sty >0
	byte $10, $BF, $00, $00
	analyze 4

	neg <0
	byte $00, $00
	analyze 2

	neg >0
	byte $70, $00, $00
	analyze 3

	neg ,x
	byte $60, $84
	analyze 2

	bita #0
	byte $85, $00
	analyze 2

	bita <0
	byte $95, $00
	analyze 2

	bita ,x
	byte $A5, $84
	analyze 2

	bita >0
	byte $B5, $00, $00
	analyze 3

	sts <0
	byte $10, $DF, $00
	analyze 3

	sts ,x
	byte $10, $EF, $84
	analyze 3

	sts >0
	byte $10, $FF, $00, $00
	analyze 4

	tstb
	byte $5D
	analyze 1

	decb
	byte $5A
	analyze 1

	blo @
	byte $25, $FE
	analyze 2

	sta <0
	byte $97, $00
	analyze 2

	sta ,x
	byte $A7, $84
	analyze 2

	sta >0
	byte $B7, $00, $00
	analyze 3

	blt @
	byte $2D, $FE
	analyze 2

	orb #0
	byte $CA, $00
	analyze 2

	orb <0
	byte $DA, $00
	analyze 2

	orb ,x
	byte $EA, $84
	analyze 2

	orb >0
	byte $FA, $00, $00
	analyze 3

	pshu cc
	byte $36, $01
	analyze 2

	bcs @
	byte $25, $FE
	analyze 2

	bhi @
	byte $22, $FE
	analyze 2

	sex
	byte $1D
	analyze 1

	lbpl @
	byte $10, $2A, $FF, $FC
	analyze 4

	com <0
	byte $03, $00
	analyze 2

	com >0
	byte $73, $00, $00
	analyze 3

	com ,x
	byte $63, $84
	analyze 2

	addb #0
	byte $CB, $00
	analyze 2

	addb <0
	byte $DB, $00
	analyze 2

	addb ,x
	byte $EB, $84
	analyze 2

	addb >0
	byte $FB, $00, $00
	analyze 3

	bra @
	byte $20, $FE
	analyze 2

	coma
	byte $43
	analyze 1

	cmpy #0
	byte $10, $8C, $00, $00
	analyze 4

	cmpy <0
	byte $10, $9C, $00
	analyze 3

	cmpy ,x
	byte $10, $AC, $84
	analyze 3

	cmpy >0
	byte $10, $BC, $00, $00
	analyze 4

	anda #0
	byte $84, $00
	analyze 2

	anda <0
	byte $94, $00
	analyze 2

	anda ,x
	byte $A4, $84
	analyze 2

	anda >0
	byte $B4, $00, $00
	analyze 3

	//////////////////////////////////////////////////////////////////////////////

	#include "my.s"
