
macro cp (hl)
{
	push8($be);
}
macro cp (ix+@n)
{
	push8($dd);
	push8($be);
	push8(n);
}

macro cp (iy+@n)
{
	push8($fd);
	push8($be);
	push8(n);
}

macro cp hx
{
	push8($dd);
	push8($bc);
}

macro cp hy
{
	push8($fd);
	push8($bc);
}

macro cp lx
{
	push8($dd);
	push8($bd);
}

macro cp ly
{
	push8($fd);
	push8($bd);
}

macro cp @[Z80n]r
{
	push8($b8+r);
}

macro cp @n
{
	push8($fe);
	push8(n);
}

