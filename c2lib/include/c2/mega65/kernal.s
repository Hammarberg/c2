/*
	c2 - cross assembler
	Copyright (C) 2022-2024  John Hammarberg (crt@nospam.binarybone.com)

	This file is part of c2.

	c2 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

	c2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along with c2. If not, see <https://www.gnu.org/licenses/>.
*/

#pragma once
// Reference and descriptions from https://files.mega65.org/html/main.php?id=ffd575e5-5d9c-47ff-b553-fcec80fd77a3

// I/O: Read the current input and output devices
#define KERNAL_GETIO $FF41

// Files: Read file, device, secondary address
#define KERNAL_GETLFS $FF44

// Editor: Read/set keyboard locks
#define KERNAL_KEYLOCKS $FF47

// Editor: Add a character to the soft keyboard input buffer
#define KERNAL_ADDKEY $FF4A

// Reserved: Set up fast serial ports
#define KERNAL_SPIN_SPOUT $FF4D

// Files: Close all files on a device
#define KERNAL_CLOSE_ALL $FF50

// OS: Reset to GO64 mode
#define KERNAL_C64MODE $FF53

// OS: Invoke monitor
#define KERNAL_MonitorCall $FF56

// OS: Boot an alternate system from disk
#define KERNAL_BOOT_SYS $FF59

// OS: Call cartridge cold start or disk boot loader
#define KERNAL_PHOENIX $FF5C

// Files: Search for logical file number in use
#define KERNAL_LKUPLA $FF5F

// Files: Search for secondary address in use
#define KERNAL_LKUPSA $FF62

// Editor: Toggle between 40x25 and 80x25 text modes
#define KERNAL_SWAPPER $FF65

// Editor: Program an editor function key
#define KERNAL_PFKEY $FF68

// Files: Set bank for I/O and filename memory
#define KERNAL_SETBNK $FF6B

// Memory: Call subroutine in any bank
#define KERNAL_JSRFAR $FF6E

// Memory: Jump to address in any bank
#define KERNAL_JMPFAR $FF71

// Memory: Read a byte from an address in any bank
#define KERNAL_LDA_FAR $FF74

// Memory: Store a byte to an address in any bank
#define KERNAL_STA_FAR $FF77

// Memory: Compare a byte with an address in any bank
#define KERNAL_CMP_FAR $FF7A

// Tools: Print an inline null-terminated short string
#define KERNAL_PRIMM $FF7D

// Editor: Initialize screen editor
#define KERNAL_CINT $FF81

// OS: Initialize I/O devices
#define KERNAL_IOINIT $FF84

// OS: Initialize RAM and buffers
#define KERNAL_RAMTAS $FF87

// OS: Initialize KERNAL vector table
#define KERNAL_RESTOR $FF8A

// OS: Read/set KERNAL vector table
#define KERNAL_VECTOR $FF8D

// OS: Enable/disable KERNAL messages
#define KERNAL_SETMSG $FF90

// Serial: Send secondary address to listener
#define KERNAL_SECND $FF93

// Serial: Send secondary address to talker
#define KERNAL_TKSA $FF96

// Reserved: RESERVED, DO NOT USE
#define KERNAL_MEMTOP $FF99

// Reserved: RESERVED, DO NOT USE
#define KERNAL_MEMBOT $FF9C

// Tools: Scan keyboard
#define KERNAL_KEY $FF9F

// OS: Monitor’s exit to BASIC
#define KERNAL_MONEXIT $FFA2

// Serial: Accept a byte from talker
#define KERNAL_ACPTR $FFA5

// Serial: Send a byte to listener
#define KERNAL_CIOUT $FFA8

// Serial: Send “untalk” command
#define KERNAL_UNTLK $FFAB

// Serial: Send “unlisten” command
#define KERNAL_UNLSN $FFAE

// Serial: Send “listen” command
#define KERNAL_LISTN $FFB1

// Serial: Send “talk” command
#define KERNAL_TALK $FFB4

// I/O: Get status of last I/O operation
#define KERNAL_READSS $FFB7

// Files: Set file, device, secondary address
#define KERNAL_SETLFS $FFBA

// Files: Set filename pointers
#define KERNAL_SETNAM $FFBD

// Files: Open logical file
#define KERNAL_OPEN $FFC0

// Files: Close logical file
#define KERNAL_CLOSE $FFC3

// I/O: Set input channel
#define KERNAL_CHKIN $FFC6

// I/O: Set output channel
#define KERNAL_CKOUT $FFC9

// I/O: Restore default channels
#define KERNAL_CLRCH $FFCC

// I/O: Read a character from input device
#define KERNAL_BASIN $FFCF

// I/O: Write a character to output device
#define KERNAL_BSOUT $FFD2

// Files: Load/verify from file
#define KERNAL_LOAD $FFD5

// Files: Save to file
#define KERNAL_SAVE $FFD8

// Tools: Set CIA1 24-hour clock
#define KERNAL_SETTIM $FFDB

// Tools: Read CIA1 24-hour clock
#define KERNAL_RDTIM $FFDE

// Tools: Report Stop key (see ScanStopKey)
#define KERNAL_STOP $FFE1

// I/O: Read a character from input device, without waiting
#define KERNAL_GETIN $FFE4

// Files: Close all files and channels
#define KERNAL_CLALL $FFE7

// Tools: Scan Stop key
#define KERNAL_ScanStopKey $FFEA

// Editor: Get current screen window size
#define KERNAL_SCRORG $FFED

// Editor: Read/set cursor position
#define KERNAL_PLOT $FFF0

// Reserved: RESERVED, DO NOT USE
#define KERNAL_IOBASE $FFF3
