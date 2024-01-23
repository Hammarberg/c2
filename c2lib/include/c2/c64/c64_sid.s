/*
	c2 - cross assembler
	Copyright (C) 2022-2023  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once

// Base address
#define SID_BASE 	$d400
#define SID_V1		SID_BASE+$0
#define SID_V2		SID_BASE+$7
#define SID_V3		SID_BASE+$e
#define SID_X		SID_BASE+$15

// Voice 1-3
#define SID_FREQ	0
#define SID_FREQL	SID_FREQ
#define SID_FREQH	1
#define SID_PW		2
#define SID_PWL		SID_PW
#define SID_PWH		3
#define SID_CTRL	4
#define SID_AD		5
#define SID_SR		6

// Extra registers
#define SID_FCOFF   0
#define SID_FCOFFL  SID_FCOFF
#define SID_FCOFFH  1
#define SID_FCTRL   2
#define SID_VOL     3
#define SID_PADX    4
#define SID_PADY    5
#define SID_OWAV    6
#define SID_OADSR   7

// Absolute addresses
#define SID_V1_FREQ	    SID_V1+SID_FREQ
#define SID_V1_FREQL    SID_V1+SID_FREQL
#define SID_V1_FREQH	SID_V1+SID_FREQH
#define SID_V1_PW       SID_V1+SID_PW
#define SID_V1_PWL      SID_V1+SID_PWL
#define SID_V1_PWH      SID_V1+SID_PWH
#define SID_V1_CTRL     SID_V1+SID_CTRL
#define SID_V1_AD       SID_V1+SID_AD
#define SID_V1_SR       SID_V1+SID_SR

#define SID_V2_FREQ     SID_V2+SID_FREQ
#define SID_V2_FREQL	SID_V2+SID_FREQL
#define SID_V2_FREQH	SID_V2+SID_FREQH
#define SID_V2_PW       SID_V2+SID_PW
#define SID_V2_PWL      SID_V2+SID_PWL
#define SID_V2_PWH      SID_V2+SID_PWH
#define SID_V2_CTRL     SID_V2+SID_CTRL
#define SID_V2_AD       SID_V2+SID_AD
#define SID_V2_SR       SID_V2+SID_SR

#define SID_V3_FREQ     SID_V3+SID_FREQ
#define SID_V3_FREQL	SID_V3+SID_FREQL
#define SID_V3_FREQH	SID_V3+SID_FREQH
#define SID_V3_PW       SID_V3+SID_PW
#define SID_V3_PWL      SID_V3+SID_PWL
#define SID_V3_PWH      SID_V3+SID_PWH
#define SID_V3_CTRL     SID_V3+SID_CTRL
#define SID_V3_AD       SID_V3+SID_AD
#define SID_V3_SR       SID_V3+SID_SR

// Extra registers
#define SID_X_FCOFF     SID_X+SID_FCOFF
#define SID_X_FCOFFL    SID_X+SID_FCOFFL
#define SID_X_FCOFFH    SID_X+SID_FCOFFH
#define SID_X_FCTRL     SID_X+SID_FCTRL
#define SID_X_VOL       SID_X+SID_VOL
#define SID_X_PADX      SID_X+SID_PADX
#define SID_X_PADY      SID_X+SID_PADY
#define SID_X_OWAV      SID_X+SID_OWAV
#define SID_X_OADSR     SID_X+SID_OADSR

// Voice control register flags
#define SID_ON			1
#define SID_SYNC		2
#define SID_RING		4
#define SID_RESET		8
#define SID_TRI			16
#define SID_TRIANGLE	SID_TRI
#define SID_SAW			32
#define SID_SAWTOOTH	SID_SAW
#define SID_PULSE		64
#define SID_RECTANGLE	SID_PULSE
#define SID_NOISE		128

// Filter control
#define SID_MUTE_V3		128
#define SID_FHIGH		63
#define SID_FBAND		32
#define SID_FLOW		16
