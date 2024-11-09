#include "c2/c2.s"

			// regression_test
			
			//

			macro byte @n
			{
				push8(n);
			}

			macro word @n
			{
				push16le(n);
			}

			macro dword @n
			{
				push32le(n);
			}

			macro qword @n
			{
				push64le(n);
			}

			@ = 0

			// Label tests
label1:
			word label1
.local:
			word label1.local

			repeatv(4, i)
			{
				label3[i]:
				byte $55
			}

			repeatv(4, i)
			{
				word label3[i]
			}

			repeat(4)
			{
			.local:
				word .local
			}

			// ORG test
rewrite:
			word 0

			@ = rewrite
			c2_allow_overwrite = true;
			word 1
			c2_allow_overwrite = false;

			word @
			byte $aa
			@ = @ + 1
			byte $aa

			@ = @ , $1234
relocated:
			word @
			@ = @
			word relocated

			// Var test

			macro varstore @n
			{
				if(n.bits() <= 8)
				{
					byte n
				}
				else if(n.bits() <= 16)
				{
					word n
				}
				else if(n.bits() <= 32)
				{
					dword n
				}
				else
				{
					qword n
				}
			}

			macro store @n
			{
				if(n.size() == 1)
				{
					varstore n
					return;
				}

				repeatv(n.size(), i)
				{
					varstore n[i]
				}
			}

			var x = $ff
			var y = x + 1

			store x
			store y

			x = $0002;
			store x

			x = $00000004;
			store x

			x = $0000000000000008;
			store x

			x = "a string";
			store x

			// global test

			macro test_global
			{
				store above
			}

			global above = 0x00001111

			test_global

