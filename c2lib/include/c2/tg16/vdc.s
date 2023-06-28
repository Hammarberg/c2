
//  see 
//  https://datacrystal.romhacking.net/wiki/VDC_Programmers_Reference_(Turbo-Grafx_16)

//  traditional 
#define IO_PORT                   $0000
//  incredibly stupid as the PCE can move pages around, but ZP and stack are always at $2000
#define RAM_LOCATION              $2000 //  includes zero page 

#define VDC_REG_SELECT            IO_PORT+$100
#define VDC_DATA_L                IO_PORT+$102
#define VDC_DATA_H                IO_PORT+$103

#define VDC_PAL_SELECT            IO_PORT+$400
#define VDC_PALINDEX_L            IO_PORT+$402
#define VDC_PALINDEX_H            IO_PORT+$403
#define VDC_PALDATA_L             IO_PORT+$404
#define VDC_PALDATA_H             IO_PORT+$405

#define JOYPAD                    IO_PORT+$1000

#define IRQ_disable               IO_PORT+$1402
#define IRQ_status                IO_PORT+$1403

#define TIMER_reload              IO_PORT + $1c00
#define TIMER_control             IO_PORT + $1c01

#define VDC_MAWR                  0 //  memory address write register
#define VDC_MARR                  1 //  memory address read register
#define VDC_VRR                   2 // vram data register read
#define VDC_VWR                   2 // write
#define VDC_CR                    5 // control 
#define VDC_RCR                   6 // raster counter
#define VDC_BXR                   7 // xscroll
#define VDC_BYR                   8 // yscroll 
#define VDC_MWR                   9 // BG width 
#define VDC_HSR                   10// h sync 
#define VDC_HDR                   11// h display
#define VDC_VSR                   12// Vertical Synchro Register 
#define VDC_VDR                   13// Vertical Display Register
#define VDC_VCR                   14// Vertical Display End Position Register
#define VDC_DMA_CR                15 // DMA control
#define VDC_DMA_SRC               16
#define VDC_DMA_DST               17
#define VDC_DMA_LEN               18
#define VDC_SAT_SRC               19

#define VCE_DOT_CLOCK_10MHZ       %00000010
#define VCE_DOT_CLOCK_7MHZ        %00000001
#define VCE_DOT_CLOCK_5MHZ        %00000000

#define VDP_SPR_COLLISION_ENABLE  %0000000000000001
#define VDP_SPR_OVERFLOW_IRQ      %0000000000000010
#define VDP_RCR_ENABLE            %0000000000000100
#define VDP_IRQ_ENABLE            %0000000000001000
#define VDP_SPR_ENABLE            %0000000001000000
#define VDP_BG_ENABLE             %0000000010000000
#define VDP_INC_1                 %0000000000000000
#define VDP_INC_32                %0000100000000000   
#define VDP_INC_64                %0001000000000000
#define VDP_INC_128               %0001100000000000
//                                 FEDCBA9876543210
#define MAP_32x32                 %00000000 
#define MAP_64x32                 %00010000
#define MAP_128x32                %00100000
#define MAP_32x64                 %01000000
#define MAP_64x64                 %01010000
#define MAP_128x64                %01100000
#define SPR_PRIORITY              %0000000010000000
#define SPR_X32                   %0000000100000000
#define SPR_XFLIP                 %0000100000000000
#define SPR_Y16                   %0000000000000000
#define SPR_Y32                   %0001000000000000
#define SPR_Y64                   %0011000000000000
#define SPR_YFLIP                 %1000000000000000

macro _vdc_reg #@reg, #@src 
{
  st0 #reg 
  st1 #src&255
  st2 #src>>8
}

macro _vdc_256_wide
{
  st0 #VDC_HSR
  st1 #$02 
  st2 #$02
  st0 #VDC_HDR
  st1 #$1f
  st2 #$04
  lda #VCE_DOT_CLOCK_5MHZ
  sta VDC_PAL_SELECT  
}

macro _vdc_320_wide
{
  st0 #VDC_HSR
  st1 #$02 
  st2 #$04
  st0 #VDC_HDR
  st1 #$29
  st2 #$04
  lda #VCE_DOT_CLOCK_7MHZ
  sta VDC_PAL_SELECT
}

macro _vce_upload @source,@dest,@length
{
  lda #dest&255
  sta VDC_PALINDEX_L    //st1 - L address
  lda #dest>>8
  sta VDC_PALINDEX_H    //st2 - H Address
  tia source,VDC_PALDATA_L,length // MPR6:VDC_DATAL = SOURCE ($FF:0002) (Lo Byte)
}

macro _vdc_upload @source,@dest,@length 
{
  st0 #VDC_MAWR // VDC: Set VDC Address To Memory Address Write Register (VRAM Write Address) (MAWR)
  st1 #dest&255      // VDC: Data = $00 (Lo Byte)
  st2 #dest>>8      // VDC: Data = $10 (Hi Byte)
  st0 #VDC_VWR // VDC: Set VDC Address To VRAM Data Write Register (VWR)
  tia source,VDC_DATA_L,length // MPR6:VDC_DATAL = SOURCE ($FF:0002) (Lo Byte)
}

macro RGB @r,@g,@b 
{
  word ((g&$e0)<<1) | ((r&$e0)>>2) | ((b&$e0)>>5)
}
