/*
EX (SP),HL    19    1   ------  E3
EX (SP),IX    23    2   ------  DD E3
EX (SP),IY    23    2   ------  FD E3
EX AF,AF'     4     1   ------  08
EX DE,HL      4     1   ------  EB
EXX           4     1   ------  D9
*/

macro ex (sp),hl 
{
	push8($e3);
}

macro ex (sp),ix 
{
	push8($dd);
	push8($e3);
}

macro ex (sp),iy 
{
	push8($fd);
	push8($e3);
}

macro ex af,af`
{
	push8($08);
}

macro ex de,hl
{
	push8($eb);
}

macro exx
{
	push8($d9);
}
