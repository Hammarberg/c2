#pragma once

/*
ROM Reference (by Bruce Tomlin)

Addr    Name            DP      Inreg   Outreg  Trashreg
----    --------------- ---     ------- ------- --------
F000    Start           --              --      --
F06C    Warm_Start      --              --      --
F14C    INIT_VIA        =D0             DP      D,X
F164    Init_OS_RAM     =C8             DP      D,X
F18B    Init_OS         =D0             DP      D,X
F192    Wait_Recal      =D0             DP      D,X
F1A2    Set_Refresh     D0                      D
F1AA    DP_to_D0        =D0             A,DP
F1AF    DP_to_C8        =C8             A,DP
F1B4    Read_Btns_Mask  D0      A       A       B,X
F1BA    Read_Btns       D0              A       B,X
F1F5    Joy_Analog      D0                      D,X
F1F8    Joy_Digital     D0                      D,X
F256    Sound_Byte      D0              X       D
F259    Sound_Byte_x    D0      A,B,X           D
F25B    Sound_Byte_raw  D0
F272    Clear_Sound     D0                      D,X
F27D    Sound_Bytes     D0      U               D,X,U
F284    Sound_Bytes_x   D0      X,U             D,X,U
F289    Do_Sound        D0                      D,X,U
F28C    Do_Sound_x      D0                      D,X,U
F29D    Intensity_1F    D0                      D
F2A1    Intensity_3F    D0                      D
F2A5    Intensity_5F    D0                      D
F2A9    Intensity_7F    D0                      D
F2AB    Intensity_a     D0      A               D
F2BE    Dot_ix_b        D0      B,X             D
F2C1    Dot_ix          D0      X               D
F2C3    Dot_d           D0      A,B             D
F2C5    Dot_here        D0                      D
F2D5    Dot_List        D0      X       X       D
F2DE    Dot_List_Reset  D0      X       X       D
F2E6    Recalibrate     D0                      D,X
F2F2    Moveto_x_7F     D0      X               D
F2FC    Moveto_d_7F     D0      A,B             D
F308    Moveto_ix_FF    D0      X       X       D
F30C    Moveto_ix_7F    D0      X       X       D
F30E    Moveto_ix_a     D0      X,A     X       D
F310    Moveto_ix       D0      X       X       D
F312    Moveto_d        D0              A,B     D
F34A    Reset0Ref_D0    =D0             DP      D
F34F    Check0Ref       D0                      D
F354    Reset0Ref       D0                      D
F35B    Reset_Pen       D0                      D
F36B    Reset0Int       D0                      D
F373    Print_Str_hwyx  D0      U       U       D,X
F378    Print_Str_yx    D0      U       U       D,X
F37A    Print_Str_d     D0      A,B,U   U       D,X
F385    Print_List_hw   D0      U       U       D,X
F38A    Print_List      D0      U       U       D,X
F38C    Print_List_chk  D0      U       U       D,X
F391    Print_Ships_x   D0      A,B,X           D,X,U
F393    Print_Ships     D0      A,B,X           D,X,U
F3AD    Mov_Draw_VLc_a  D0      X       X       D       count y x y x ...
F3B1    Mov_Draw_VL_b   D0      B,X     X       D       y x y x ...
F3B5    Mov_Draw_VLcs   D0      X       X       D       count scale y x ...
F3B7    Mov_Draw_VL_ab  D0      A,B,X   X       D       y x y x ...
F3B9    Mov_Draw_VL_a   D0      A,X     X       D       y x y x ...
F3BC    Mov_Draw_VL     D0      X       X       D       y x y x ...
F3BE    Mov_Draw_VL_d   D0      D,X     X       D       y x y x ...
F3CE    Draw_VLc        D0      X       X       D       count y x y x ...
F3D2    Draw_VL_b       D0      B,X     X       D       y x y x ...
F3D6    Draw_VLcs       D0      X       X       D       count scale y x ...
F3D8    Draw_VL_ab      D0      A,B,X   X       D       y x y x ...
F3DA    Draw_VL_a       D0      A,X     X       D       y x y x ...
F3DD    Draw_VL         D0      X       X       D       y x y x ...
F3DF    Draw_Line_d     D0      A,B     X       D       y x y x ...
F404    Draw_VLp_FF     D0      X       X       D       pat y x ... $01
F408    Draw_VLp_7F     D0      X       X       D       pat y x ... $01
F40C    Draw_VLp_scale  D0      X       X       D       scale pat y x ... $01
F40E    Draw_VLp_b      D0      B,X     X       D       pat y x ... $01
F410    Draw_VLp        D0      X       X       D       pat y x ... $01
F434    Draw_Pat_VL_a   D0      A,X     X       D       y x y x ...
F437    Draw_Pat_VL     D0      X       X       D       y x y x ...
F439    Draw_Pat_VL_d   D0      D,X     X       D       y x y x ...
F46E    Draw_VL_mode    D0      X       X       D       mode y x ... $01
F495    Print_Str       D0      U       U       D,X
F511    Random_3        --              A
F517    Random          --              A
F533    Init_Music_Buf  --                      D,X
F53F    Clear_x_b       --      B,X     D
F542    Clear_C8_RAM    --              D,X
F545    Clear_x_256     --      X       D
F548    Clear_x_d       --      D,X     D
F550    Clear_x_b_80    --      B,X     A,B
F552    Clear_x_b_a     --      A,B,X   B
F55A    Dec_3_Counters  --              X,B
F55E    Dec_6_Counters  --              X,B
F563    Dec_Counters    --      B,X     B
F56D    Delay_3         --              B               30 cycles
F571    Delay_2         --              B               25 cycles
F575    Delay_1         --              B               20 cycles
F579    Delay_0         --              B               12 cycles
F57A    Delay_b         --      B       B               5*B + 10 cycles
F57D    Delay_RTS       --                              5 cycles
F57E    Bitmask_a       --      A       A       X
F584    Abs_a_b         --      A,B     A,B
F58B    Abs_b           --      B       B
F593    Rise_Run_Angle  C8      A,B     A,B
F5D9    Get_Rise_Idx    --      A       A,B     X
F5DB    Get_Run_Idx     --      A       A,B     X
F5EF    Rise_Run_Idx    C8                      D
F5FF    Rise_Run_X      C8      A,B
F601    Rise_Run_Y      C8      A,B
F603    Rise_Run_Len    C8      A,B     A,B
F610    Rot_VL_ab       =C8     A,B,X,U DP,X,U  D       y x y x ...
F616    Rot_VL          =C8     X,U     DP,X,U  D       y x y x ...
F61F    Rot_VL_Mode     C8      A,X,U   X,U     D       mode y x ... $01
F62B    Rot_VL_M_dft    C8      X,U     X,U     D       mode y x ... $01
F65B    Xform_Run_a     C8      A       A       B
F65D    Xform_Run       C8              A       B
F661    Xform_Rise_a    C8      A       A       B
F663    Xform_Rise      C8              A       B
F67F    Move_Mem_a_1    --      A,X,U   A,B
F683    Move_Mem_a      --      A,X,U   A,B
F687    Init_Music_chk  C8      U               D,X,Y,U
F68D    Init_Music      C8      U               D,X,Y,U
F692    Init_Music_dft  C8      U               D,X,Y,U
F7A9    Select_Game     =C8     A,B     DP      D,X,Y
F835    Display_Option  D0      A,Y             D,X,U
F84F    Clear_Score     --      X               D
F85E    Add_Score_a     --      A,X,U           D
F87C    Add_Score_d     --      D,X,U           D
F8B7    Strip_Zeros     --      B,X             D
F8C7    Compare_Score   --      X,U     A       B
F8D8    New_High_Score  --      X,U             X,U,D
F8E5    Obj_Will_Hit_u  --      D,X,Y,U C-flag
F8F3    Obj_Will_Hit    --      D,X,Y,U C-flag
F8FF    Obj_Hit         --      D,X,Y   C-flag
F92E    Explosion_Snd   C8      U               D,X
FF9F    Draw_Grid_VL    D0      X,Y     X,Y     D
*/

// this file is part of vectrex frogger, written by Christopher Salomon
// in March-April 1998 all stuff contained here is public domain (?)
///////////////////////////////////////////////////////////////////////////////
// this file contains includes for vectrex BIOS functions and variables      //
// it was written by Bruce Tomlin, slighte changed by Christopher Salomon    //
///////////////////////////////////////////////////////////////////////////////
// Converted to c2 format by John Hammarberg

#define Vec_Snd_Shadow       0xC800   //Shadow of sound chip registers (15 bytes)
#define Vec_Btn_State        0xC80F   //Current state of all joystick buttons
#define Vec_Prev_Btns        0xC810   //Previous state of all joystick buttons
#define Vec_Buttons          0xC811   //Current toggle state of all buttons
#define Vec_Button_1_1       0xC812   //Current toggle state of stick 1 button 1
#define Vec_Button_1_2       0xC813   //Current toggle state of stick 1 button 2
#define Vec_Button_1_3       0xC814   //Current toggle state of stick 1 button 3
#define Vec_Button_1_4       0xC815   //Current toggle state of stick 1 button 4
#define Vec_Button_2_1       0xC816   //Current toggle state of stick 2 button 1
#define Vec_Button_2_2       0xC817   //Current toggle state of stick 2 button 2
#define Vec_Button_2_3       0xC818   //Current toggle state of stick 2 button 3
#define Vec_Button_2_4       0xC819   //Current toggle state of stick 2 button 4
#define Vec_Joy_Resltn       0xC81A   //Joystick A/D resolution (0x80=min 0x00=max)
#define Vec_Joy_1_X          0xC81B   //Joystick 1 left/right
#define Vec_Joy_1_Y          0xC81C   //Joystick 1 up/down
#define Vec_Joy_2_X          0xC81D   //Joystick 2 left/right
#define Vec_Joy_2_Y          0xC81E   //Joystick 2 up/down
#define Vec_Joy_Mux          0xC81F   //Joystick enable/mux flags (4 bytes)
#define Vec_Joy_Mux_1_X      0xC81F   //Joystick 1 X enable/mux flag (=1)
#define Vec_Joy_Mux_1_Y      0xC820   //Joystick 1 Y enable/mux flag (=3)
#define Vec_Joy_Mux_2_X      0xC821   //Joystick 2 X enable/mux flag (=5)
#define Vec_Joy_Mux_2_Y      0xC822   //Joystick 2 Y enable/mux flag (=7)
#define Vec_Misc_Count       0xC823   //Misc counter/flag byte, zero when not in use
#define Vec_0Ref_Enable      0xC824   //Check0Ref enable flag
#define Vec_Loop_Count       0xC825   //Loop counter word (incremented in Wait_Recal)
#define Vec_Brightness       0xC827   //Default brightness
#define Vec_Dot_Dwell        0xC828   //Dot dwell time?
#define Vec_Pattern          0xC829   //Dot pattern (bits)
#define Vec_Text_HW          0xC82A   //Default text height and width
#define Vec_Text_Height      0xC82A   //Default text height
#define Vec_Text_Width       0xC82B   //Default text width
#define Vec_Str_Ptr          0xC82C   //Temporary string pointer for Print_Str
#define Vec_Counters         0xC82E   //Six bytes of counters
#define Vec_Counter_1        0xC82E   //First  counter byte
#define Vec_Counter_2        0xC82F   //Second counter byte
#define Vec_Counter_3        0xC830   //Third  counter byte
#define Vec_Counter_4        0xC831   //Fourth counter byte
#define Vec_Counter_5        0xC832   //Fifth  counter byte
#define Vec_Counter_6        0xC833   //Sixth  counter byte
#define Vec_RiseRun_Tmp      0xC834   //Temp storage word for rise/run
#define Vec_Angle            0xC836   //Angle for rise/run and rotation calculations
#define Vec_Run_Index        0xC837   //Index pair for run
//                       0xC839   //Pointer to copyright string during startup
#define Vec_Rise_Index       0xC839   //Index pair for rise
//                       0xC83B   //High score cold-start flag (=0 if valid)
#define Vec_RiseRun_Len      0xC83B   //length for rise/run
//                       0xC83C   //temp byte
#define Vec_Rfrsh            0xC83D   //Refresh time (divided by 1.5MHz)
#define Vec_Rfrsh_lo         0xC83D   //Refresh time low byte
#define Vec_Rfrsh_hi         0xC83E   //Refresh time high byte
#define Vec_Music_Work       0xC83F   //Music work buffer (14 bytes, backwards?)
#define Vec_Music_Wk_A       0xC842   //        register 10
//                       0xC843   //        register 9
//                       0xC844   //        register 8
#define Vec_Music_Wk_7       0xC845   //        register 7
#define Vec_Music_Wk_6       0xC846   //        register 6
#define Vec_Music_Wk_5       0xC847   //        register 5
//                       0xC848   //        register 4
//                       0xC849   //        register 3
//                       0xC84A   //        register 2
#define Vec_Music_Wk_1       0xC84B   //        register 1
//                       0xC84C   //        register 0
#define Vec_Freq_Table       0xC84D   //Pointer to note-to-fr.EQUency table (normally 0xFC8D)
#define Vec_Max_Players      0xC84F   //Maximum number of players for Select_Game
#define Vec_Max_Games        0xC850   //Maximum number of games for Select_Game
#define Vec_ADSR_Table       0xC84F   //Storage for first music header word (ADSR table)
#define Vec_Twang_Table      0xC851   //Storage for second music header word ('twang' table)
#define Vec_Music_Ptr        0xC853   //Music data pointer
#define Vec_Expl_ChanA       0xC853   //Used by Explosion_Snd - bit for first channel used?
#define Vec_Expl_Chans       0xC854   //Used by Explosion_Snd - bits for all channels used?
#define Vec_Music_Chan       0xC855   //Current sound channel number for Init_Music
#define Vec_Music_Flag       0xC856   //Music active flag (0x00=off 0x01=start 0x80=on)
#define Vec_Duration         0xC857   //Duration counter for Init_Music
#define Vec_Music_Twang      0xC858   //3 word 'twang' table used by Init_Music
#define Vec_Expl_1           0xC858   //Four bytes copied from Explosion_Snd's U-reg parameters
#define Vec_Expl_2           0xC859   //
#define Vec_Expl_3           0xC85A   //
#define Vec_Expl_4           0xC85B   //
#define Vec_Expl_Chan        0xC85C   //Used by Explosion_Snd - channel number in use?
#define Vec_Expl_ChanB       0xC85D   //Used by Explosion_Snd - bit for second channel used?
#define Vec_ADSR_Timers      0xC85E   //ADSR timers for each sound channel (3 bytes)
#define Vec_Music_Freq       0xC861   //Storage for base fr.EQUency of each channel (3 words)
//                       0xC85E   //Scratch 'score' storage for Display_Option (7 bytes)
#define Vec_Expl_Flag        0xC867   //Explosion_Snd initialization flag?
//               0xC868...0xC876   //Unused?
#define Vec_Expl_Timer       0xC877   //Used by Explosion_Snd
//                       0xC878   //Unused?
#define Vec_Num_Players      0xC879   //Number of players selected in Select_Game
#define Vec_Num_Game         0xC87A   //Game number selected in Select_Game
#define Vec_Seed_Ptr         0xC87B   //Pointer to 3-byte random number seed (=0xC87D)
#define Vec_Random_Seed      0xC87D   //Default 3-byte random number seed
                                //
//    0xC880 - 0xCBEA is user RAM  //
                                //
#define Vec_Default_Stk      0xCBEA   //Default top-of-stack
#define Vec_High_Score       0xCBEB   //High score storage (7 bytes)
#define Vec_SWI3_Vector      0xCBF2   //SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_SWI2_Vector      0xCBF2   //SWI2/SWI3 interrupt vector (3 bytes)
#define Vec_FIRQ_Vector      0xCBF5   //FIRQ interrupt vector (3 bytes)
#define Vec_IRQ_Vector       0xCBF8   //IRQ interrupt vector (3 bytes)
#define Vec_SWI_Vector       0xCBFB   //SWI/NMI interrupt vector (3 bytes)
#define Vec_NMI_Vector       0xCBFB   //SWI/NMI interrupt vector (3 bytes)
#define Vec_Cold_Flag        0xCBFE   //Cold start flag (warm start if = 0x7321)
                                //
#define VIA_port_b           0xD000   //VIA port B data I/O register
//       0 sample/hold (0=enable  mux 1=disable mux)
//       1 mux sel 0
//       2 mux sel 1
//       3 sound BC1
//       4 sound BDIR
//       5 comparator input
//       6 external device (slot pin 35) initialized to input
//       7 /RAMP
#define VIA_port_a           0xD001   //VIA port A data I/O register (handshaking)
#define VIA_DDR_b            0xD002   //VIA port B data direction register (0=input 1=output)
#define VIA_DDR_a            0xD003   //VIA port A data direction register (0=input 1=output)
#define VIA_t1_cnt_lo        0xD004   //VIA timer 1 count register lo (scale factor)
#define VIA_t1_cnt_hi        0xD005   //VIA timer 1 count register hi
#define VIA_t1_lch_lo        0xD006   //VIA timer 1 latch register lo
#define VIA_t1_lch_hi        0xD007   //VIA timer 1 latch register hi
#define VIA_t2_lo            0xD008   //VIA timer 2 count/latch register lo (refresh)
#define VIA_t2_hi            0xD009   //VIA timer 2 count/latch register hi
#define VIA_shift_reg        0xD00A   //VIA shift register
#define VIA_aux_cntl         0xD00B   //VIA auxiliary control register
//       0 PA latch enable
//       1 PB latch enable
//       2 \                     110=output to CB2 under control of phase 2 clock
//       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
//       4 /
//       5 0=t2 one shot                 1=t2 free running
//       6 0=t1 one shot                 1=t1 free running
//       7 0=t1 disable PB7 output       1=t1 enable PB7 output
#define VIA_cntl             0xD00C   //VIA control register
//       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
//       1 \
//       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
//       3 /
//       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
//       5 \
//       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
//       7 /
#define VIA_int_flags        0xD00D   //VIA interrupt flags register
//               bit                             cleared by
//       0 CA2 interrupt flag            reading or writing port A I/O
//       1 CA1 interrupt flag            reading or writing port A I/O
//       2 shift register interrupt flag reading or writing shift register
//       3 CB2 interrupt flag            reading or writing port B I/O
//       4 CB1 interrupt flag            reading or writing port A I/O
//       5 timer 2 interrupt flag        read t2 low or write t2 high
//       6 timer 1 interrupt flag        read t1 count low or write t1 high
//       7 IRQ status flag               write logic 0 to IER or IFR bit
#define VIA_int_enable       0xD00E   //VIA interrupt enable register
//       0 CA2 interrupt enable
//       1 CA1 interrupt enable
//       2 shift register interrupt enable
//       3 CB2 interrupt enable
//       4 CB1 interrupt enable
//       5 timer 2 interrupt enable
//       6 timer 1 interrupt enable
//       7 IER set/clear control
#define VIA_port_a_nohs      0xD00F   //VIA port A data I/O register (no handshaking)

#define Cold_Start           0xF000   //
#define Warm_Start           0xF06C   //
#define Init_VIA             0xF14C   //
#define Init_OS_RAM          0xF164   //
#define Init_OS              0xF18B   //
#define Wait_Recal           0xF192   //
#define Set_Refresh          0xF1A2   //
#define DP_to_D0             0xF1AA   //
#define DP_to_C8             0xF1AF   //
#define Read_Btns_Mask       0xF1B4   //
#define Read_Btns            0xF1BA   //
#define Joy_Analog           0xF1F5   //
#define Joy_Digital          0xF1F8   //
#define Sound_Byte           0xF256   //
#define Sound_Byte_x         0xF259   //
#define Sound_Byte_raw       0xF25B   //
#define Clear_Sound          0xF272   //
#define Sound_Bytes          0xF27D   //
#define Sound_Bytes_x        0xF284   //
#define Do_Sound             0xF289   //
#define Do_Sound_x           0xF28C   //
#define Intensity_1F         0xF29D   //
#define Intensity_3F         0xF2A1   //
#define Intensity_5F         0xF2A5   //
#define Intensity_7F         0xF2A9   //
#define Intensity_a          0xF2AB   //
#define Dot_ix_b             0xF2BE   //
#define Dot_ix               0xF2C1   //
#define Dot_d                0xF2C3   //
#define Dot_here             0xF2C5   //
#define Dot_List             0xF2D5   //
#define Dot_List_Reset       0xF2DE   //
#define Recalibrate          0xF2E6   //
#define Moveto_x_7F          0xF2F2   //
#define Moveto_d_7F          0xF2FC   //
#define Moveto_ix_FF         0xF308   //
#define Moveto_ix_7F         0xF30C   //
#define Moveto_ix_b          0xF30E   // Used to be named Moveto_ix_a but this is wrong.
#define Moveto_ix            0xF310   //
#define Moveto_d             0xF312   //
#define Reset0Ref_D0         0xF34A   //
#define Check0Ref            0xF34F   //
#define Reset0Ref            0xF354   //
#define Reset_Pen            0xF35B   //
#define Reset0Int            0xF36B   //
#define Print_Str_hwyx       0xF373   //
#define Print_Str_yx         0xF378   //
#define Print_Str_d          0xF37A   //
#define Print_List_hw        0xF385   //
#define Print_List           0xF38A   //
#define Print_List_chk       0xF38C   //
#define Print_Ships_x        0xF391   //
#define Print_Ships          0xF393   //
#define Mov_Draw_VLc_a       0xF3AD   //count y x y x ...
#define Mov_Draw_VL_b        0xF3B1   //y x y x ...
#define Mov_Draw_VLcs        0xF3B5   //count scale y x y x ...
#define Mov_Draw_VL_ab       0xF3B7   //y x y x ...
#define Mov_Draw_VL_a        0xF3B9   //y x y x ...
#define Mov_Draw_VL          0xF3BC   //y x y x ...
#define Mov_Draw_VL_d        0xF3BE   //y x y x ...
#define Draw_VLc             0xF3CE   //count y x y x ...
#define Draw_VL_b            0xF3D2   //y x y x ...
#define Draw_VLcs            0xF3D6   //count scale y x y x ...
#define Draw_VL_ab           0xF3D8   //y x y x ...
#define Draw_VL_a            0xF3DA   //y x y x ...
#define Draw_VL              0xF3DD   //y x y x ...
#define Draw_Line_d          0xF3DF   //y x y x ...
#define Draw_VLp_FF          0xF404   //pattern y x pattern y x ... 0x01
#define Draw_VLp_7F          0xF408   //pattern y x pattern y x ... 0x01
#define Draw_VLp_scale       0xF40C   //scale pattern y x pattern y x ... 0x01
#define Draw_VLp_b           0xF40E   //pattern y x pattern y x ... 0x01
#define Draw_VLp             0xF410   //pattern y x pattern y x ... 0x01
#define Draw_Pat_VL_a        0xF434   //y x y x ...
#define Draw_Pat_VL          0xF437   //y x y x ...
#define Draw_Pat_VL_d        0xF439   //y x y x ...
#define Draw_VL_mode         0xF46E   //mode y x mode y x ... 0x01
#define Print_Str            0xF495   //
#define Random_3             0xF511   //
#define Random               0xF517   //
#define Init_Music_Buf       0xF533   //
#define Clear_x_b            0xF53F   //
#define Clear_C8_RAM         0xF542   //never used by GCE carts?
#define Clear_x_256          0xF545   //
#define Clear_x_d            0xF548   //
#define Clear_x_b_80         0xF550   //
#define Clear_x_b_a          0xF552   //
#define Dec_3_Counters       0xF55A   //
#define Dec_6_Counters       0xF55E   //
#define Dec_Counters         0xF563   //
#define Delay_3              0xF56D   //30 cycles
#define Delay_2              0xF571   //25 cycles
#define Delay_1              0xF575   //20 cycles
#define Delay_0              0xF579   //12 cycles
#define Delay_b              0xF57A   //5B + 10 cycles
#define Delay_RTS            0xF57D   //5 cycles
#define Bitmask_a            0xF57E   //
#define Abs_a_b              0xF584   //
#define Abs_b                0xF58B   //
#define Rise_Run_Angle       0xF593   //
#define Get_Rise_Idx         0xF5D9   //
#define Get_Run_Idx          0xF5DB   //
#define Get_Rise_Run         0xF5EF   //
#define Rise_Run_X           0xF5FF   //
#define Rise_Run_Y           0xF601   //
#define Rise_Run_Len         0xF603   //
#define Rot_VL_ab            0xF610   //
#define Rot_VL               0xF616   //
#define Rot_VL_Mode_a        0xF61F   //
#define Rot_VL_Mode          0xF62B   //
#define Rot_VL_dft           0xF637   //
#define Xform_Run_a          0xF65B   //
#define Xform_Run            0xF65D   //
#define Xform_Rise_a         0xF661   //
#define Xform_Rise           0xF663   //
#define Move_Mem_a_1         0xF67F   //
#define Move_Mem_a           0xF683   //
#define Init_Music_chk       0xF687   //
#define Init_Music           0xF68D   //
#define Init_Music_x         0xF692   //
#define Select_Game          0xF7A9   //
#define Clear_Score          0xF84F   //
#define Add_Score_a          0xF85E   //
#define Add_Score_d          0xF87C   //
#define Strip_Zeros          0xF8B7   //
#define Compare_Score        0xF8C7   //
#define New_High_Score       0xF8D8   //
#define Obj_Will_Hit_u       0xF8E5   //
#define Obj_Will_Hit         0xF8F3   //
#define Obj_Hit              0xF8FF   //
#define Explosion_Snd        0xF92E   //
#define Draw_Grid_VL         0xFF9F   //
                                //
#define music1   0xFD0D               //
#define music2   0xFD1D               //
#define music3   0xFD81               //
#define music4   0xFDD3               //
#define music5   0xFE38               //
#define music6   0xFE76               //
#define music7   0xFEC6               //
#define music8   0xFEF8               //
#define music9   0xFF26               //
#define musica   0xFF44               //
#define musicb   0xFF62               //
#define musicc   0xFF7A               //
#define musicd   0xFF8F               //

// Extension for c2

#define lo(X) ((X)&255)
#define LO lo
#define hi(X) lo((X)>>8)
#define HI hi
