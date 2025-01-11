#include "c2/dragon/dragon.s"

        // NiteMove
        // Adapted to c2 from from https://github.com/Marky-D-32/Dragon32-NiteMove
        // A machine code game for the dragon 32. Move the Knight around a chess board.
        // This game was orginally developed by Pat McCabe and Colin Turner. It was published in the May 1986 issue of Dragon User.

        //  Calling macro to give a start load address and insert a DOS header
        dosheader $2134

begin:  bsr instr

semi24: ldx #$600
        lda #$80
loop:   sta ,x+
        cmpx #$1e00
        bcs loop
        lda #$0d
        sta $ff22
        sta $ffc0
        sta $ffc3
        sta $ffc5
        sta $ffc7
        // onscreen instructions
contrl: ldx #$600
        lda #$80
loop1:  sta ,x+
        cmpx #$1e00
        bne loop1
        ldx #$0671
        stx $88
        clrb
        leay print,pcr
loop2:  lda ,y+
        anda #$bf
        sta ,x+
        sta $1f,x
        sta $3f,x
        sta $5f,x
        sta $7f,x
        sta $9f,x
        sta $bf,x
        cmpx #6269
        beq score
        incb
        cmpb #13
        bne loop2
line:   clrb
        leax 755,x
        bne loop2
print:  byte "CONTROLS:-   "
        byte "CURSOR KEYS  "
        byte "FOR MOVEMENT."
        byte "PRESS ENTER  "
        byte "TO CHANGE.   "
        byte "\"R\" RESTARTS "
        byte "\"Q\" QUITS    "
        // score initializatio
score:  ldx #6244
        stx $88
        clrb
        leay score1,pcr
loop3:  lda ,y+
        anda #$bf
        sta ,x+
        sta $1f,x
        sta $3f,x
        sta $5f,x
        sta $7f,x
        sta $9f,x
        sta $bf,x
        incb
        cmpb #8
        bne loop3
        ldd #$3030
        std $1f00
        bra board
score1: byte "MOVES 00"
        // set up display
board:  ldx #$0660
        ldd #$0000
        ldy #$cfcf
        ldu #$afaf
rows:   sty ,x++
        stu ,x++
        inca
        cmpa #4
        bne rows
        leax 16,x
        clra
        incb
        cmpb #16
        bne rows
        exg y,u
        clrb
        cmpx #$1660
        bne rows
        // randomise start
        lda $1f80
        cmpa #50
        beq start2
        ldx #$0e64
        bne start1
start2: jsr $978e		// random number: generates an 8 bit random number and puts it in location 278
        ldb 278
        andb #$07
        aslb
        addb #$60
        pshs b
        jsr $978e		// random number: generates an 8 bit random number and puts it in location 278
        lda 278
        anda #$07
        asla
        adda #$06
        puls b
        tfr d,x
        ldy ,x
        cmpy #$afaf
start1: beq fstchk
        bne nxtchk
        // main contol routie
wait:   ldu $1f30
        leau -1538,u
        bsr check
        leau 4,u
        bsr check
        leau 506,u
        bsr check
        leau 8,u
        bsr check
        leau 1016,u
        bsr check
        leau 8,u
        bsr check
        leau 506,u
        bsr check
        leau 4,u
        bsr check
        bsr nomove
check:  ldd ,u
        cmpa #$af
        beq cyan
        cmpa #$cf
        beq orange
        puls pc
keys:   jsr $8006		// polcat:keyboard input:put into register a
        beq keys
        cmpa #81
        beq quit
        cmpa #82
        beq begin
        cmpa #$5e
        bne down
        ldd -544,x
        cmpa #$80
        beq keys
        bsr chek
        leax -1024,x
        ldd ,x
        bne chek2
down:   cmpa #$0a
        bne left
        ldd 32,x
        cmpa #$80
        beq keys
        bsr chek
        ldd ,x
        bsr chek2
left:   cmpa #$08
        bne right
        ldd -33,x
        cmpa #$80
        beq keys
        bsr chek
        leax -514,x
        ldd ,x
        bsr chek2
right:  cmpa #$09
        bne enter
        ldd -30,x
        cmpa #$80
        beq keys
        bsr chek
        leax -510,x
        ldd ,x
        bsr chek2
enter:  cmpa #$0d
        bne keys
        ldu $1f20
        leau -1026,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 4,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 506,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 8,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 1016,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 8,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 506,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau 4,u
        stu $1f20
        cmpx $1f20
        beq cango
        leau -1026,u
        stu $1f20
nogo:   stx $1f60
        ldx #$1b66
        stx $88
        clrb
        leay cant,pcr
loop4:  lda ,y+
        anda #$bf
        sta ,x+
        sta $1f,x
        sta $3f,x
        sta $5f,x
        sta $7f,x
        sta $9f,x
        sta $bf,x
        incb
        cmpb #19
        bne loop4
        ldy #$ffff
delay:  leay -1,y
        bne delay
        ldx $1f60
        bsr chek
        lda #255
        ldx #200
        bsr sound
        lda #125
        ldx #100
        bsr sound
        ldx #$1b66
        lda #$80
loop5:  sta ,x+
        cmpx #$1e00
        bne loop5
        ldx $1f30
        stx $1f20
        leax -512,x
        ldd ,x
        bne chek2
cango:  leax -512,x
        ldd ,x
        cmpd #$aaaa
        beq fstchk
        cmpd #$caca
        beq nxtchk
        leax 512,x
        bne nogo
fstchk: ldy #$ffff
        bsr move
        bsr units
        pshs x
        lda #187
        ldx #85
        bsr sound
        puls x
        stx $1f20
        stx $1f30
        leax -512,x
        bne wait
nxtchk: ldy #$dfdf
        bsr move
        bsr units
        pshs x
        lda #187
        ldx #85
        bsr sound
        puls x
        stx $1f20
        stx $1f30
        leax -512,x
        bne wait
scrchk: ldd $1f00
        cmpa #54
        bne keys
        cmpb #52
        beq ending
        bne keys
cant:   byte "YOU CAN'T GO THERE!"
        // colour change
chek:   leax -512,x
        ldd ,x
        cmpa #$df
        bne ff
        ldy #$dfdf
        bra move
ff:     cmpa #$ff
        bne aa
        ldy #$ffff
        bra move
aa:     cmpa #$aa
        bne ca
        ldy #$afaf
        bra move
ca:     cmpa #$ca
        bne da
        ldy #$cfcf
        bra move
da:     cmpa #$da
        bne fa
        ldy #$dfdf
        bra move
fa:     cmpa #$fa
        ldy #$ffff
move:   clrb
loop6:  sty ,x
        leax 32,x
        incb
        cmpb #16
        bne loop6
        puls pc
        // cursor colour colntrols
chek2:  cmpa #$af
        beq blue
        cmpa #$cf
        beq buff
        cmpa #$df
        beq cyan
        cmpa #$ff
        beq orange
blue:   ldy #$aaaa
        ldu #$a5a5
        bra move2
buff:   ldy #$caca
        ldu #$c5c5
        bra move2
cyan:   ldy #$dada
        ldu #$d5d5
        bra move2
orange: ldy #$fafa
        ldu #$f5f5
        bra move2
move2:  clra
        clrb
loop7:  sty ,x
        leax 32,x
        incb
        cmpb #4
        bne loop7
        inca
        cmpa #4
        bne swop
        pshs x
        lda #31
        ldx #69
        bsr sound
        puls x
        bra scrchk
swop:   exg u,y
        clrb
        bra loop7
        // counting routine
units:  pshs a,b,x
        ldx #6218
count:  ldd $1f00
        cmpb #57
        beq tens
        incb
loop8:  std ,x
        leax 32,x
        cmpx #6456
        blo loop8
        std $1f00
        puls x,a,b,pc
tens:   inca
        ldb #47
        std $1f00
        bra count
        // sound routines
sound:  pshs a
        lda $ff01
        anda #247
        sta $ff01
        lda $ff03
        anda #247
        sta $ff03
        lda $ff23
        ora #8
        sta $ff23
        orcc #$50
        puls a
        pshs x
        ldb #252
sd1:    stb $ff20
sd2:    leax -1,x
        bne sd2
        ldx ,s
        clr $ff20
sd3:    leax -1,x
        bne sd3
        ldx ,s
        deca
        bne sd1
        andcc #$af
        puls x,pc
nomove: lda #131
        ldx #102
        bsr sound
        lda #200
        ldx #225
        bsr sound
finish: ldx #$1b66
        stx $88
        clrb
        leay type,pcr
loop9:  lda ,y+
        anda #$bf
        sta ,x+
        sta $1f,x
        sta $3f,x
        sta $5f,x
        sta $7f,x
        sta $9f,x
        sta $bf,x
        incb
        cmpb #19
        bcs loop9
        ldx $1f20
        leax -512,x
        ldd ,x
        bra chek2
type:   byte "SORRY NO MOVES LEFT"
ending: ldx #$1b60
        stx $88
        clrb
        leay again,pcr
loop10: lda ,y+
        anda #$bf
        sta ,x+
        sta $1f,x
        sta $3f,x
        sta $5f,x
        sta $7f,x
        sta $9f,x
        sta $bf,x
        incb
        cmpb #31
        bcs loop10
loop11: jsr $8006		// polcat:keyboard input:put into register a
        cmpa #$59
        beq begin
        cmpa #$4e
        beq quit
        bne loop11
again:  byte "WELL DONE ANOTHER GAME (Y OR N)"
        // initial text display
instr:  jsr $ba77		// clear screen: clears screen to space and 'homes' cursor
        ldx #$04a2
        stx $88
        leax rules,pcr
        jsr $90e5		// out string:outputs a text string to device number in devn
        jsr $90e5		// out string:outputs a text string to device number in devn
        ldx #$400
loop12: lda ,x
        eora #$40
        sta ,x+
        cmpx #$5ff
        bls loop12
        ldx #$400
        lda #$af
loop13: sta ,x+
        cmpx #$41e
        bls loop13
        ldx #$5a2
        lda #156
loop14: sta ,x+
        cmpx #$5bd
        bls loop14
        lda #152
        sta $5be
        ldx #$41f
        lda #$cf
loop15: sta ,x
        leax 32,x
        cmpx #$5df
        bls loop15
        lda #146
        sta $43e
        ldx #$45e
        lda #154
loop16: sta ,x
        leax 32,x
        cmpx #$59e
        bls loop16
        ldx #$5e1
        lda #$df
loop17: sta ,x+
        cmpx #$600
        bls loop17
        lda #145
        sta $421
        ldx #$422
        lda #147
loop18: sta ,x+
        cmpx #$43d
        bls loop18
        ldx #$420
        lda #$ff
loop19: sta ,x
        leax 32,x
        cmpx #$5e0
        bls loop19
        lda #148
        sta $5a1
        ldx #$441
        lda #149
loop20: sta ,x
        leax 32,x
        cmpx #$581
        bls loop20
loop21: jsr $8006			// polcat:keyboard input:put into register a
        cmpa #49
        beq level
        cmpa #50
        beq level
        cmpa #32
        beq cklevl
        lda #1
loop22: pshs a
        ldb #2
loop23: pshs b
        ldx #$400
        ldy #$401
        lda #31
loop24: ldb ,y+
        stb ,x+
        deca
        bne loop24
        puls b
        decb
        bne loop23
        ldx #$41f
        ldy #$43f
        lda #$15
loop25: ldb ,y
        stb ,x
        leay 32,y
        leax 32,x
        deca
        bne loop25
        ldb #2
loop26: ldx #$600
        ldy #$5ff
        lda #31
        pshs b
loop27: ldb ,-y
        stb ,-x
        deca
        bne loop27
        puls b
        decb
        bne loop26
        ldx #$5e0
        ldy #$5c0
        lda #15
loop28: ldb ,y
        stb ,x
        leay -32,y
        leax -32,x
        deca
        bne loop28
        puls a
        deca
        bne loop22
        lda #28
        ldx #$5c1
        ldy #$5c2
        ldu ,x
loop29: ldb ,y+
        stb ,x+
        deca
        bne loop29
        stu $5dd
        ldy #12000
slow:   leay -1,y
        bne slow
        bra loop21
        // scrolls screen
scroll: clr $1f70
        ldb #32
loop30: ldx #$400
        lda #$80
loop31: sta ,x
        leax 32,x
        cmpx #$601
        bls loop31
        ldx #$400
        ldy #$401
loop32: lda ,y+
        sta ,x+
        cmpx #$600
        bls loop32
        pshs y
        ldy #$1500
loop33: leay -1,y
        bne loop33
        pshs b
        lda #100
        ldx #36
        bsr sound
        puls b
        decb
        bne loop30
        bra semi24
        // start level check
level:  sta $1f70
        sta $1f80
        ldx #$5c1
        stx $88
        leax spcbar,pcr
        jsr $90e5			// outputs a text string to device number in devn
        lda #200
        ldx #25
        bsr sound
        bra loop21
spcbar: byte "       PRESS SPACEBAR TO START",0
cklevl: lda $1f70
        cmpa #49
        beq scroll
        cmpa #50
        beq scroll
        bne loop21
rules:  byte "  CHANGE THE BOARD FROM BLUE    "
        byte "  & WHITE TO ORANGE AND CYAN    "
        byte "                                "
        byte "   USING THE CURSOR KEYS MOVE   "
        byte "   AS THE KNIGHT CAN IN CHESS   "
        byte "                                "
        byte "                                "
        byte "                                "
        byte "                                "
        byte "   ENTER SKILL LEVEL 1 OR 2 ? ",0
        // finish return to basic
quit:   jsr $b3b4		// reset:resets whole works, as if reset button has been pressed
