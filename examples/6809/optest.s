#include "c2/motorola/6809.s"

/*
	6809 opcode test comparison vs a a good known raw binary from lwtools-lwasm
	http://www.lwtools.ca/
*/

	// optest

	@ = $1000
	var opstart = @;
	c2_file reference("a.out");

	// C++ lambda function
	auto check = [this, &reference, &opstart](){
		var size = @ - opstart;
		repeat(size)
		{
			var a = c2_peek(opstart+c2repn);
			var b = reference.pop8();
			if(a != b)
			{
				if(c2repn)
				{
					c2_info("pos %04x ord %d %02x, %02x/%02x", int(opstart-0x1000+c2repn-1), int(c2repn-1), int(c2_peek(opstart+c2repn-1)), int(a), int(b));
				}
				else
				{
					c2_info("pos %04x ord %d %02x/%02x", int(opstart-0x1000+c2repn), int(c2repn), int(a), int(b));
				}
				c2_error("assembled opcode doesn't match reference");
			}
		}
		opstart = @;
	};

	#include "optest_generated.s"
