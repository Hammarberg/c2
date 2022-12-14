/*
	c2 - cross assembler
	Copyright (C) 2022  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
// Commodore 64 standard KERNAL functions
// Original information gathered by Joe Forster: http://sta.c64.org/cbm64krnfunc.html

// Initialize VIC; restore default input/output to keyboard/screen; clear screen; set PAL/NTSC switch and interrupt timer.
// Input: –
// Output: –
// Used registers: A, X, Y.
// Real address: $FF5B.
#define KERNAL_SCINIT $FF81

// Initialize CIA's, SID volume; setup memory configuration; set and start interrupt timer.
// Input: –
// Output: –
// Used registers: A, X.
// Real address: $FDA3.
#define KERNAL_IOINIT $FF84

// Clear memory addresses $0002-$0101 and $0200-$03FF; run memory test and set start and end address of BASIC work area accordingly; set screen memory to $0400 and datasette buffer to $033C.
// Input: –
// Output: –
// Used registers: A, X, Y.
// Real address: $FD50.
#define KERNAL_RAMTAS $FF87

// Fill vector table at memory addresses $0314-$0333 with default values.
// Input: –
// Output: –
// Used registers: –
// Real address: $FD15.
#define KERNAL_RESTOR $FF8A

// Copy vector table at memory addresses $0314-$0333 from or into user table.
// Input: Carry: 0 = Copy user table into vector table, 1 = Copy vector table into user table; X/Y = Pointer to user table.
// Output: –
// Used registers: A, Y.
// Real address: $FD1A.
#define KERNAL_VECTOR $FF8D

// Set system error display switch at memory address $009D.
// Input: A = Switch value.
// Output: –
// Used registers: –
// Real address: $FE18.
#define KERNAL_SETMSG $FF90

// Send LISTEN secondary address to serial bus. (Must call LISTEN beforehands.)
// Input: A = Secondary address.
// Output: –
// Used registers: A.
// Real address: $EDB9.
#define KERNAL_LSTNSA $FF93

// Send TALK secondary address to serial bus. (Must call TALK beforehands.)
// Input: A = Secondary address.
// Output: –
// Used registers: A.
// Real address: $EDC7.
#define KERNAL_TALKSA $FF96

// Save or restore start address of BASIC work area.
// Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).
// Output: X/Y = Address (if Carry = 1).
// Used registers: X, Y.
// Real address: $FE25.
#define KERNAL_MEMBOT $FF99

// Save or restore end address of BASIC work area.
// Input: Carry: 0 = Restore from input, 1 = Save to output; X/Y = Address (if Carry = 0).
// Output: X/Y = Address (if Carry = 1).
// Used registers: X, Y.
// Real address: $FE34.
#define KERNAL_MEMTOP $FF9C

// Query keyboard; put current matrix code into memory address $00CB, current status of shift keys into memory address $028D and PETSCII code into keyboard buffer.
// Input: –
// Output: –
// Used registers: A, X, Y.
// Real address: $EA87.
#define KERNAL_SCNKEY $FF9F

// Unknown. (Set serial bus timeout.)
// Input: A = Timeout value.
// Output: –
// Used registers: –
// Real address: $FE21.
#define KERNAL_SETTMO $FFA2

// Read byte from serial bus. (Must call TALK and TALKSA beforehands.)
// Input: –
// Output: A = Byte read.
// Used registers: A.
// Real address: $EE13.
#define KERNAL_IECIN $FFA5

// Write byte to serial bus. (Must call LISTEN and LSTNSA beforehands.)
// Input: A = Byte to write.
// Output: –
// Used registers: –
// Real address: $EDDD.
#define KERNAL_IECOUT $FFA8

// Send UNTALK command to serial bus.
// Input: –
// Output: –
// Used registers: A.
// Real address: $EDEF.
#define KERNAL_UNTALK $FFAB

// Send UNLISTEN command to serial bus.
// Input: –
// Output: –
// Used registers: A.
// Real address: $EDFE.
#define KERNAL_UNLSTN $FFAE

// Send LISTEN command to serial bus.
// Input: A = Device number.
// Output: –
// Used registers: A.
// Real address: $ED0C.
#define KERNAL_LISTEN $FFB1

// Send TALK command to serial bus.
// Input: A = Device number.
// Output: –
// Used registers: A.
// Real address: $ED09.
#define KERNAL_TALK $FFB4

// Fetch status of current input/output device, value of ST variable. (For RS232, status is cleared.)
// Input: –
// Output: A = Device status.
// Used registers: A.
// Real address: $FE07.
#define KERNAL_READST $FFB7

// Set file parameters.
// Input: A = Logical number; X = Device number; Y = Secondary address.
// Output: –
// Used registers: –
// Real address: $FE00.
#define KERNAL_SETLFS $FFBA

// Set file name parameters.
// Input: A = File name length; X/Y = Pointer to file name.
// Output: –
// Used registers: –
// Real address: $FDF9.
#define KERNAL_SETNAM $FFBD

// Open file. (Must call SETLFS and SETNAM beforehands.)
// Input: –
// Output: –
// Used registers: A, X, Y.
// Real address: ($031A), $F34A.
#define KERNAL_OPEN $FFC0

// Close file.
// Input: A = Logical number.
// Output: –
// Used registers: A, X, Y.
// Real address: ($031C), $F291.
#define KERNAL_CLOSE $FFC3

// Define file as default input. (Must call OPEN beforehands.)
// Input: X = Logical number.
// Output: –
// Used registers: A, X.
// Real address: ($031E), $F20E.
#define KERNAL_CHKIN $FFC6

// Define file as default output. (Must call OPEN beforehands.)
// Input: X = Logical number.
// Output: –
// Used registers: A, X.
// Real address: ($0320), $F250.
#define KERNAL_CHKOUT $FFC9

// Close default input/output files (for serial bus, send UNTALK and/or UNLISTEN); restore default input/output to keyboard/screen.
// Input: –
// Output: –
// Used registers: A, X.
// Real address: ($0322), $F333.
#define KERNAL_CLRCHN $FFCC

// Read byte from default input (for keyboard, read a line from the screen). (If not keyboard, must call OPEN and CHKIN beforehands.)
// Input: –
// Output: A = Byte read.
// Used registers: A, Y.
// Real address: ($0324), $F157.
#define KERNAL_CHRIN $FFCF

// Write byte to default output. (If not screen, must call OPEN and CHKOUT beforehands.)
// Input: A = Byte to write.
// Output: –
// Used registers: –
// Real address: ($0326), $F1CA.
#define KERNAL_CHROUT $FFD2

// Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
// Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
// Used registers: A, X, Y.
// Real address: $F49E.
#define KERNAL_LOAD $FFD5

// Save file. (Must call SETLFS and SETNAM beforehands.)
// Input: A = Address of zero page register holding start address of memory area to save; X/Y = End address of memory area plus 1.
// Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1).
// Used registers: A, X, Y.
// Real address: $F5DD.
#define KERNAL_SAVE $FFD8

// Set Time of Day, at memory address $00A0-$00A2.
// Input: A/X/Y = New TOD value.
// Output: –
// Used registers: –
// Real address: $F6E4.
#define KERNAL_SETTIM $FFDB

// read Time of Day, at memory address $00A0-$00A2.
// Input: –
// Output: A/X/Y = Current TOD value.
// Used registers: A, X, Y.
// Real address: $F6DD.
#define KERNAL_RDTIM $FFDE

// Query Stop key indicator, at memory address $0091; if pressed, call CLRCHN and clear keyboard buffer.
// Input: –
// Output: Zero: 0 = Not pressed, 1 = Pressed; Carry: 1 = Pressed.
// Used registers: A, X.
// Real address: ($0328), $F6ED.
#define KERNAL_STOP $FFE1

// Read byte from default input. (If not keyboard, must call OPEN and CHKIN beforehands.)
// Input: –
// Output: A = Byte read.
// Used registers: A, X, Y.
// Real address: ($032A), $F13E.
#define KERNAL_GETIN $FFE4

// Clear file table; call CLRCHN.
// Input: –
// Output: –
// Used registers: A, X.
// Real address: ($032C), $F32F.
#define KERNAL_CLALL $FFE7

// Update Time of Day, at memory address $00A0-$00A2, and Stop key indicator, at memory address $0091.
// Input: –
// Output: –
// Used registers: A, X.
// Real address: $F69B.
#define KERNAL_UDTIM $FFEA

// Fetch number of screen rows and columns.
// Input: –
// Output: X = Number of columns (40); Y = Number of rows (25).
// Used registers: X, Y.
// Real address: $E505.
#define KERNAL_SCREEN $FFED

// Save or restore cursor position.
// Input: Carry: 0 = Restore from input, 1 = Save to output; X = Cursor column (if Carry = 0); Y = Cursor row (if Carry = 0).
// Output: X = Cursor column (if Carry = 1); Y = Cursor row (if Carry = 1).
// Used registers: X, Y.
// Real address: $E50A.
#define KERNAL_PLOT $FFF0

// Fetch CIA #1 base address.
// Input: –
// Output: X/Y = CIA #1 base address ($DC00).
// Used registers: X, Y.
// Real address: $E500.
#define KERNAL_IOBASE $FFF3
