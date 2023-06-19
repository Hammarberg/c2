#include "c2/mos/6502.s"

//  Make a 32kb ROM cart 
//  with 8kb CHR ROM data

#define ROM_START               $8000

//--
//  NES specific
//--
#define MAPPER_HORIZONTAL       $2
#define MAPPER_VERTICAL         $3
#define MAPPER_FOURSCREEN       $a
#define NTSC                    $0
#define PAL                     $1
#define NES                     0 
#define NESVS                   1 
#define PLAYCHOICE10            2
#define NAMETABLE_0             $2000
#define NAMETABLE_1             $2400
#define NAMETABLE_2             $2800
#define NAMETABLE_3             $2c00
#define CTRL_NT_2000            %00000000 
#define CTRL_NT_2400            %00000001 
#define CTRL_NT_2800            %00000010 
#define CTRL_NT_2c00            %00000011 
#define CTRL_INC_1              %00000000
#define CTRL_INC_32             %00000100
#define CTRL_SPR_0000           %00000000
#define CTRL_SPR_1000           %00001000
#define CTRL_BG_0000            %00000000
#define CTRL_BG_1000            %00010000
#define CTRL_SPR_8x8            %00000000
#define CTRL_SPR_8x16           %00100000
#define CTRL_NMI_OFF            %00000000
#define CTRL_NMI_ON             %10000000
#define Mask_BG_ON              %00001000 
#define Mask_SP_OFF             %00000000 
#define Mask_SP_ON              %00010000 
#define OAM_BUFFER              $700

//--
//
//  define the PPU 
//  
//--

        @ = $2000 
PPU:    
    .Control:       BYTE 0 
    .Mask:          BYTE 0
    .Status:        BYTE 0
    .OAM_Address:   BYTE 0 
    .OAM_Data:      BYTE 0
    .Scroll:        BYTE 0 
    .Address:       BYTE 0
    .Data:          BYTE 0

//--
//
//  define the IO 
//  
//--

    @ = $4000
IO:     
    .Square_1_vol:      BYTE 0  
    .Square_1_sweep:    BYTE 0  
    .Square_1_lo:       BYTE 0  
    .Square_1_hi:       BYTE 0  
    .Square_2_vol:      BYTE 0  
    .Square_2_sweep:    BYTE 0  
    .Square_2_lo:       BYTE 0  
    .Square_2_hi:       BYTE 0  
    .Triangle_linear:   WORD 0
    .Triangle_lo:       BYTE 0
    .Triangle_hi:       BYTE 0
    .Noise_linear:      WORD 0
    .Noise_lo:          BYTE 0
    .Noise_hi:          BYTE 0
    .DMC_freq:          BYTE 0  
    .DMC_raw:           BYTE 0
    .DMC_start:         BYTE 0      
    .DMC_length:        BYTE 0  
    .OAM_DMA:           BYTE 0       
    .Sound_channels:    BYTE 0 
    .Input_0:           BYTE 0      
    .Input_1:           BYTE 0      


macro NES_HEADER @mapper,@system,@freq,@prgrom_banks,@chrrom_banks
{
    @ = ROM_START-16        
    BYTE $4E,$45,$53,$1A    //  NES
    BYTE prgrom_banks
    BYTE chrrom_banks
    BYTE mapper
    BYTE system
    BYTE 0 
    BYTE freq
    BYTE    $00,$00,$00,$00,$00,$00
}


macro PPU_vwait
{
.vblankwait1:  
    bit PPU.Status
    bpl .vblankwait1
}

macro PPU_setaddr #@Address
{
    lda #Address>>8
    sta PPU.Address
    lda #Address&255
    sta PPU.Address
}