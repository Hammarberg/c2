#include "c64.s"

			// numbers
			
			basic_startup

			// Decimal numbers
			lda #123

			// Binary
			lda #%0100111
			lda #0b0100111

			// Hexadecimal
			jsr $ffd2
			jsr 0xffd2
			var x = $ffd0 + 2
			jsr x
			lda #0xea

			// Explicitly use 16 bits
			sta $0002

			// Octal
			lda #010	//dec 8

			// Characters
			lda #'@'				// ASCII
			lda #ascii2petscii('@')	// PETSCII
			lda #ascii2screen('@')	// Screen code

			rts
