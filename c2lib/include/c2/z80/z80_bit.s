
macro BIT @b,(HL)
{
	push8($cb);
	push8($46+(8*b));
}

macro BIT @b,(ix+@n)
{
	push8($dd);
	push8($cb);
	push8(n);
	push8($46+(8*b));
}

macro BIT @b,(iy+@n)
{
	push8($fd);
	push8($cb);
	push8(n);
	push8($46+(8*b));
}

macro BIT @b,@[Z80n]r
{
	push8($cb);
	push8($40 + r +(8*b));
}

