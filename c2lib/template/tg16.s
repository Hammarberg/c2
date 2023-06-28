//
//	NOTE 
//	this is bare minimum TG16 example. 
//	

#include "c2/tg16/huc6280.s"
#include "c2/tg16/vdc.s"

#define DATA_START $4000

	//	zeropage/ram 
	@ = RAM_LOCATION

vsr:	byte 0

#define MAX_Sprites 64
//	avoid stack
	@ = RAM_LOCATION + $200
//	variables in RAM but not ZP 

	@ = $e000
//	pretty much PCE boilerplate
onReset:

	sei 
	csh //	Change Speed High
	cld // Clear Decimal Flag
	stz TIMER_reload
	ldx #$ff
	txs
	lda #$ff 				// hardware/IO 	$0000-$1fff
	tam #%00000001 
	lda #$f8 				//	ram/ZP 		$2000-$3fff
	tam #%00000010 
	lda #1				//	prgrom1		$4000-$5fff 
	tam #%00000100
	lda #2				//	prgrom2		$6000-$7fff
	tam #%00001000 
	lda #3				//	prgrom3		$8000-$9fff
	tam #%00010000 
	lda #4				//	prgrom4		$a000-$bfff 
	tam #%00100000 
	lda #5				//	prgrom4		$c000-$dfff 
	tam #%01000000 
	lda #0				//	prgrom0		$e000-$ffff 
	tam #%10000000 

	stz    	RAM_LOCATION                	// clear all the RAM
	tii    	RAM_LOCATION,RAM_LOCATION+1,$1FFF

	lda #$7
	sta IRQ_disable
	stz IRQ_status

	_vdc_reg #VDC_CR,#0
	_vdc_reg #VDC_RCR,#0
	_vdc_reg #VDC_BXR,#0
	_vdc_reg #VDC_BYR,#$0000
	_vdc_reg #VDC_MWR,#MAP_32x32

	_vdc_reg #VDC_VSR,#$0d07
	_vdc_reg #VDC_VDR,#224
	_vdc_reg #VDC_VCR,#$0003
	_vdc_reg #VDC_DMA_CR,#%00010001  
	_vdc_reg #VDC_SAT_SRC,#$7f00

	//	clear vram
	st0 #VDC_MAWR // VDC: Set VDC Address To Memory Address Write Register (VRAM Write Address) (MAWR)
	st1 #$00      
	st2 #$08      
	st0 #VDC_VWR // VDC: Set VDC Address To VRAM Data Write Register (VWR)
	tia RAM_LOCATION,VDC_DATA_L,$8000 
	//	we do this twice, to just keep going into the VRAM
	tia RAM_LOCATION,VDC_DATA_L,$8000 

	_vdc_256_wide
	_vdc_reg #VDC_CR,#(VDP_IRQ_ENABLE | VDP_BG_ENABLE | VDP_SPR_ENABLE )
	//	PCE
	lda #%00000001 
	sta IRQ_disable
	stz IRQ_status
	cli
	jmp @

onTimer:
{
	pha
	sta IRQ_status	//ACK TIMER
	stz TIMER_control	//Turn off timer
	pla
	rti
}


//	vblank
onIRQ:
{
	pha
	phx
	phy
	lda VDC_REG_SELECT
	sta vsr
	and #$2 
	beq vsynccheck
	stz $106
	stz $106
vsynccheck:
	lda vsr
	and #$20
	beq exit
	//	logic 
	//	IRQ has happened  
exit:	
	stz VDC_REG_SELECT
	ply
	plx
	pla
	rti
}	

onNMI:
onIRQ2:
	rti

//	NO CODE or DATA after this, besides IRQ vectors and CHRROM 
//  IRQ vectors

	@ = $fff6
	word onIRQ2 
	word onIRQ 
	word onTimer 
	word onNMI
	@ = $fffe
	word onReset

	@ = $10000,DATA_START
