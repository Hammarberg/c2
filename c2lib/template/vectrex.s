#include "c2/vectrex/vectrex.s"
#include "c2/motorola/6809.s"

			// {title}

			@ = $0
			byte	"g GCE 1998", $80
			word	music1
			byte	$F8, $50, $20, -$46
			byte	"HELLO WORLD", $80
			byte 	0

main:
			jsr		Wait_Recal
			jsr		Intensity_5F

			ldu		#hello_world_string
			lda		#$10
			ldb		#-$70
			jsr		Print_Str_d
			bra		main

hello_world_string:
			byte	"C2 ASSEMBLED HELLO", $80
