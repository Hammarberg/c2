/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

// from here 
// http://jgmalcolm.com/z80/download/z80.txt 

#pragma once

#define C2_Z80
#define Z80n b,c,d,e,h,l,hl,a 
#define Z80nh b,c,d,e,hx,lx,hl,a 

#include "z80_adc.s"
#include "z80_add.s"
#include "z80_and.s"
#include "z80_bit.s"
#include "z80_call.s"
#include "z80_cp.s"
#include "z80_dec.s"
#include "z80_ex.s"
#include "z80_irq.s"
#include "z80_port.s"
#include "z80_inc.s"
#include "z80_j.s"
#include "z80_ld.s"
#include "z80_or.s"
#include "z80_stack.s"
#include "z80_ret.s"

macro ccf { push8($3f); }
macro cpd { push16be($eda9,false); }
macro cpdr { push16be($edb9,false); }
macro cpi { push16be($eda1,false); }
macro cpir { push16be($edb1,false); }
macro cpl { push8($2f); }
macro daa { push8($27); }
macro djnz @n 
{
	push8($10);
	push8(n-@-1);
}

macro ind  { push16be($edaa,false); }
macro indr { push16be($edba,false); }
macro ini  { push16be($eda2,false); }
macro inir { push16be($edb2,false); }
macro ldd  { push16be($eda8,false); }
macro lddr { push16be($edb8,false); }
macro ldi  { push16be($eda0,false); }
macro ldir { push16be($edb0,false); }


/*
NEG           8     2   +1V+++  ED 44
NOP           4     1   ------  00
RES b,(HL)    15    2   ------  CB 86+8*b
RES b,(IX+N)  23    4   ------  DD CB XX 86+8*b
RES b,(IY+N)  23    4   ------  FD CB XX 86+8*b
RES b,r       8     2   ------  CB 8r+8*b
RL (HL)       15    2   +0P0++  CB 16
RL r          8     2   +0P0++  CB 1r
RL (IX+N)     23    4   +0P0++  DD CB XX 16
RL (IY+N)     23    4   +0P0++  FD CB XX 16
RLA           4     1   +0-0--  17
RLC (HL)      15    2   +0P0++  CB 06
RLC (IX+N)    23    4   +0P0++  DD CB XX 06
RLC (IY+N)    23    4   +0P0++  FD CB XX 06
RLC r         8     2   +0P0++  CB 0r
RLCA          4     1   +0-0--  07
RLD           18    2   -0P0++  ED 6F
RR (HL)       15    2   +0P0++  CB 1E
RR r          8     2   +0P0++  CB 18+r
RR (IX+N)     23    4   +0P0++  DD CB XX 1E
RR (IY+N)     23    4   +0P0++  FD CB XX 1E
RRA           4     1   +0-0--  1F
RRC (HL)      15    2   +0P0++  CB 0E
RRC (IX+N)    23    4   +0P0++  DD CB XX 0E
RRC (IY+N)    23    4   +0P0++  FD CB XX 0E
RRC r         8     2   +0P0++  CB 08+r
RRCA          4     1   +0-0--  0F
RRD           18    2   -0P0++  ED 67
RST 0         11    1   ------  C7
RST 8H        11    1   ------  CF
RST 10H       11    1   ------  D7
RST 18H       11    1   ------  DF
RST 20H       11    1   ------  E7
RST 28H       11    1   ------  EF
RST 30H       11    1   ------  F7
RST 38H       11    1   ------  FF
SBC A,(HL)    7     1   +1V+++  9E
SBC A,(IX+N)  19    3   +1V+++  DD 9E XX
SBC A,(IY+N)  19    3   +1V+++  FD 9E XX
SBC A,r       4     1   +1V+++  98+r
SBC HX              2   +1V+++  DD 9C
SBC HY              2   +1V+++  FD 9C
SBC LX              2   +1V+++  DD 9D
SBC LY              2   +1V+++  FD 9D
SBC A,N       7     2   +1V+++  DE XX
SBC HL,BC     15    2   +1V ++  ED 42
SBC HL,DE     15    2   +1V ++  ED 52
SBC HL,HL     15    2   +1V ++  ED 62
SBC HL,SP     15    2   +1V ++  ED 72
SCF           4     1   10-0--  37
SET b,(HL)    15    2   ------  CB C6+8*b
SET b,(IX+N)  23    4   ------  DD CB XX C6+8*b
SET b,(IY+N)  23    4   ------  FD CB XX C6+8*b
SET b,r       8     2   ------  CB Cr+8*b
SLA (HL)      15    2   +0P0++  CB 26
SLA (IX+N)    23    4   +0P0++  DD CB XX 26
SLA (IY+N)    23    4   +0P0++  FD CB XX 26
SLA r         8     2   +0P0++  CB 2r
SLL (HL)      15    2   +0P0++  CB 36
SLL (IX+N)    23    4   +0P0++  DD CB XX 36
SLL (IY+N)    23    4   +0P0++  FD CB XX 36
SLL r         8     2   +0P0++  CB 3r
SRA (HL)      15    2   +0P0++  CB 2E
SRA (IX+N)    23    4   +0P0++  DD CB XX 2E
SRA (IY+N)    23    4   +0P0++  FD CB XX 2E
SRA r         8     2   +0P0++  CB 28+r
SRL (HL)      15    2   +0P0++  CB 3E
SRL (IX+N)    23    4   +0P0++  DD CB XX 3E
SRL (IY+N)    23    4   +0P0++  FD CB XX 3E
SRL r         8     2   +0P0++  CB 38+r
SUB (HL)      7     1   ++V+++  96
SUB (IX+N)    19    3   ++V+++  DD 96 XX
SUB (IY+N)    19    3   ++V+++  FD 96 XX
SUB r         4     1   ++V+++  9r
SUB HX              2   ++V+++  DD 94
SUB HY              2   ++V+++  FD 94
SUB LX              2   ++V+++  DD 95
SUB LY              2   ++V+++  FD 95
SUB N         7     2   ++V+++  D6 XX
XOR (HL)      7     1   00P0++  AE
XOR (IX+N)    19    3   00P0++  DD AE XX
XOR (IY+N)    19    3   00P0++  FD AE XX
XOR r         4     1   00P0++  A8+r
XOR HX              2   00P0++  DD AC
XOR HY              2   00P0++  FD AC
XOR LX              2   00P0++  DD AD
XOR LY              2   00P0++  FD AD
XOR N         7     2   00P0++  EE XX
*/
