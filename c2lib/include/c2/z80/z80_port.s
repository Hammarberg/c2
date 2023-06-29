
macro in a,(c) 
{
	push16be($ed78,false);
}
macro in b,(c)
{
	push16be($ed40,false);
}
macro in c,(c)
{
	push16be($ed48,false);
}
macro in d,(c)
{
	push16be($ed50,false);
}
macro in e,(c)
{
	push16be($ed58,false);
}
macro in h,(c)
{
	push16be($ed60,false);
}
macro in l,(c) 
{
	push16be($ed68,false);
}
macro in (c)
{
	push16be($ed70,false);
}
macro in a,(@n)
{
	push8($db); 
	push8(n);
};

macro otdr
{
	push16be($edbb,false);
}
macro otir
{
	push16be($edb3,false);
}
macro out (c),a 
{
	push16be($ed79,false);
}
macro out (c),b
{
	push16be($ed41,false);
}
macro out (c),c
{
	push16be($ed49,false);
}

macro out (c),d 
{
	push16be($ed51,false);
}
macro out (c),e
{
	push16be($ed59,false);
}
macro out (c),h
{
	push16be($ed61,false);
}
macro out (c),l
{
	push16be($ed69,false);
}
macro out (c),0
{
	push16be($ed71,false);
}
macro outd
{
	push16be($edab,false);
}
macro outi
{
	push16be($eda3,false);
}

macro out (@n),a 
{
	push8($d3);
	push8(n);
}