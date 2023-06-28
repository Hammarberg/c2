
macro call c,@n 
{
	push8($dc);	
	push16le(n,true);
}

macro call m,@n 
{
	push8($fc);	
	push16le(n,true);
}

macro call nc,@n 
{
	push8($d4);	
	push16le(n,true);
}

macro call @n 
{
	push8($cd);	
	push16le(n,true);
}

macro call nz,@n 
{
	push8($c4);	
	push16le(n,true);
}

macro call p,@n 
{
	push8($f4);	
	push16le(n,true);
}

macro call pe,@n 
{
	push8($ec);	
	push16le(n,true);
}

macro call po,@n 
{
	push8($e4);	
	push16le(n,true);
}

macro call z,@n 
{
	push8($cc);	
	push16le(n,true);
}

