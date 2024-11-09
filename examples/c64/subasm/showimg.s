#include "c2/c64/c64.s"
#include "c2/mos/6502.s"

			// showimg

			macro set_d011 @vscroll, @rows25, @screen_on, @bitmap, @extended ,@raster_hi
			{
				lda #(vscroll&7) | ((rows25&1) << 3) | ((screen_on&1) << 4) | ((bitmap&1) << 5) | ((extended&1) << 6) | ((raster_hi&1) << 7)
				sta $d011
			}

			macro set_d018 @font, @screen
			{
				lda # (((screen&$3fff)/$0400) << 4) | (((font&$3fff)/$0800) << 1)
				sta $d018
			}

			@ = $0900
start:
			
			sei

			lda #$03
			sta $d020

			set_d011 3, 1, 1, 1, 0, 0
			/* expands to
			lda #$3b
			sta $d011
			*/

			set_d018 bitmap, screen
			/* expands to
			lda #$38
			sta $d018
			*/

:			jmp -

			//import labels from bitmapsdata.s
			import bitmap
			import screen
			assemble "bitmapdata.s"
