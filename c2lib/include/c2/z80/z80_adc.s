
// adc
macro adc a,(ix+@n)
{
	push8($dd);
	push8($8e);
	push8(n);
}

macro adc a,(iy+@n)
{
	push8($fd);
	push8($8e);
	push8(n);
}

macro adc a,(hl)
{
	push8($8e);
}


macro adc a,@[Z80n]r
{
	push8($88+r);
}

macro adc a,@n
{
	push8($ce);
	push8(n);
}


macro adc a,hx
{
	push8($dd);
	push8($8c);
}

macro adc a,hy
{
	push8($fd);
	push8($8c);
}

macro adc a,ixh
{
	push8($dd);
	push8($8c);
}

macro adc a,iyh
{
	push8($fd);
	push8($8c);
}

macro adc a,lx
{
	push8($dd);
	push8($8d);
}

macro adc a,ly
{
	push8($fd);
	push8($8d);
}

macro adc a,ixl
{
	push8($dd);
	push8($8d);
}

macro adc a,iyl
{
	push8($fd);
	push8($8d);
}

macro adc hl,bc
{
	push8($ed);
	push8($4a);
}

macro adc hl,de
{
	push8($ed);
	push8($5a);
}

macro adc hl,hl
{
	push8($ed);
	push8($6a);
}

macro adc hl,sp
{
	push8($ed);
	push8($7a);
}

