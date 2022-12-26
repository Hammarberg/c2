#include "c2/c64/c64.s"
#include "c2/c64/kernal.s"
#include "c2/mos/6502_unintended.s"
#include "c2/mos/6502_tools.s"

			// test
			
			basic_startup
			sei

			lda #0
			sta $d020
			sta $d021

			memcpy $0400, data, 1000
			memcpy $d800, data + 1000, 1000

			jmp @
		
data:		//incstream "dir", 2 + $0861 - $0801, 2000

incstream "curl -L https://csdb.dk/release/download.php?id=267043 --output -", 2 + $0861 - $0801, 2000
