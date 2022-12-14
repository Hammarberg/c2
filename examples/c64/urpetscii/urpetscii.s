#include "c2/c64/c64.s"

			// urpetscii - fast and stupid - beacuse it's easy

			// C pre-processor is available
			#define SCREEN $0400
			#define COLOR $d800

			basic_startup

			sei

			lda #0
			sta $d020
			sta $d021

			// Load PETSCII data into variables as arrays

			var sdata = loadvar("Orthogonality.prg", 2 + $0861 - $0801 ,1000)	//Screen
			var cdata = loadvar("Orthogonality.prg", 2 + $0c49 - $0801 ,1000)	//Color

#if 0
			// A meta loop!
			for(int r=0; r<1000; r++)
			{
				lda #sdata[r]
				sta SCREEN+r
				lda #cdata[r]
				sta COLOR+r
			}
#else
			for(int b=0; b<256; b++)
			{
				bool loaded = false;

				for(int r=0; r<1000; r++)
				{
					if(sdata[r] == b)
					{
						if(!loaded)
						{
							lda #b
							loaded = true;
						}

						sta SCREEN+r
					}

					if(cdata[r] == b && sdata[r] != $20)
					{
						if(!loaded)
						{
							lda #b
							loaded = true;
						}

						sta COLOR+r
					}
				}
			}
#endif

			// Forever jmp
			jmp @
