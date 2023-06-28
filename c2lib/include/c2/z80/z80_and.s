/*
AND (HL)      7     1   00P1++  A6
AND (IX+N)    19    3   00P1++  DD A6 XX
AND (IY+N)    19    3   00P1++  FD A6 XX
AND r         4     1   00P1++  Ar
AND HX              2   00P1++  DD A4
AND HY              2   00P1++  FD A4
AND LX              2   00P1++  DD A5
AND LY              2   00P1++  FD A5
AND N         7     2   00P1++  E6 XX
*/

macro and (hl)
{
	push8($a6);
}

macro and (ix+@n)
{
	push8($dd);
	push8($a6);
	push8(n);
}

macro and (iy+@n)
{
	push8($fd);
	push8($a6);
	push8(n);
}

macro and hx
{
	push8($dd);
	push8($a4);
}

macro and hy
{
	push8($fd);
	push8($a4);
}

macro and lx
{
	push8($dd);
	push8($a5);
}

macro and ly
{
	push8($fd);
	push8($a5);
}

macro and @[Z80n]r
{
	push8($a0+r);
}

macro and @n
{
	push8($e6);
	push8(n);
}
