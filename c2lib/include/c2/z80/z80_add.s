
// add
macro add a,(ix+@n)
{
	push8($dd);
	push8($86);
	push8(n);
}

macro add a,(iy+@n)
{
	push8($fd);
	push8($86);
	push8(n);
}

macro add a,(hl)
{
	push8($86);
}

macro add a,@n
{
	push8($ce);
	push8(n);
}

macro add a,@[Z80n]r
{
	push8($80+r);
}

macro add a,hx
{
	push8($dd);
	push8($84);
}

macro add a,hy
{
	push8($fd);
	push8($84);
}

macro add a,lx
{
	push8($dd);
	push8($85);
}

macro add a,ly
{
	push8($fd);
	push8($85);
}

macro add hl,bc
{
	push8($09);
}

macro add hl,de
{
	push8($19);
}

macro add hl,hl
{
	push8($29);
}

macro add hl,sp
{
	push8($39);
}

macro add ix,bc
{
	push8($dd);
	push8($09);
}

macro add ix,de
{
	push8($dd);
	push8($19);
}

macro add ix,ix
{
	push8($dd);
	push8($29);
}

macro add ix,sp
{
	push8($dd);
	push8($39);
}


macro add iy,bc
{
	push8($fd);
	push8($09);
}

macro add iy,de
{
	push8($fd);
	push8($19);
}

macro add iy,iy
{
	push8($fd);
	push8($29);
}

macro add iy,sp
{
	push8($fd);
	push8($39);
}

