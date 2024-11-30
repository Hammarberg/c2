#include "c2/c64/c64.s"
#include "c2/wdc/65816.s"

			// hello

			var screen = $0400
			var color = $d800

			basic_startup
			sei

			cpu nat
			reg x16
			_x16

			lda #$20
			ldx #999
:			sta screen,x
			dex
			bpl -

			var textlen = text.end - text
			ldy #textlen - 1
			ldx #12*40 + (40-textlen)/2 + textlen - 1

:			lda text,y
			sta screen,x
			lda #$01
			sta color,x
			dex
			dey
			bpl -

			cpu emu
			_x8
			cli
:			rts

text:		screencode "hello c2 world"
.end:
