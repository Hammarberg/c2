/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
#include "c2/mos/6502.s"

#define VSYNC   $00
#define VBLANK  $01
#define WSYNC   $02
#define RSYNC   $03
#define NUSIZ0  $04
#define NUSIZ1  $05
#define COLUP0  $06
#define COLUP1  $07
#define COLUPF  $08
#define COLUBK  $09
#define CTRLPF  $0A
#define REFP0   $0B
#define REFP1   $0C
#define PF0	    $0D
#define PF1	    $0E
#define PF2	    $0F
#define RESP0   $10
#define POSH2   $11
#define RESP1   $11
#define RESM0   $12
#define RESM1   $13
#define RESBL   $14
#define AUDC0   $15
#define AUDC1   $16
#define AUDF0   $17
#define AUDF1   $18
#define AUDV0   $19
#define AUDV1   $1A
#define GRP0    $1B
#define GRP1    $1C
#define ENAM0   $1D
#define ENAM1   $1E
#define ENABL   $1F
#define HMP0    $20
#define HMP1    $21
#define HMM0    $22
#define HMM1    $23
#define HMBL    $24
#define VDELP0  $25
#define VDELP1  $26
#define VDELBL  $27
#define RESMP0  $28
#define RESMP1  $29
#define HMOVE   $2A
#define HMCLR   $2B
#define CXCLR   $2C

#define CXM0P   $30
#define CXM1P   $31
#define CXP0FB  $32
#define CXP1FB  $33
#define CXM0FB  $34
#define CXM1FB  $35
#define CXBLPF  $36
#define CXPPMM  $37
#define INPT0   $38
#define INPT1   $39
#define INPT2   $3A
#define INPT3   $3B
#define INPT4   $3C
#define INPT5   $3D

#define SWCHA   $280
#define SWACNT  $281
#define SWCHB   $282
#define SWBCNT  $283
#define INTIM   $284
#define TIMINT  $285

#define TIM1T   $294
#define TIM8T   $295
#define TIM64T  $296
#define T1024T  $297

#define TIM1I   $29c
#define TIM8I   $29d
#define TIM64I  $29e
#define T1024I  $29f
