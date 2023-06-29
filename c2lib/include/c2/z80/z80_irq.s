macro di { push8($f3); }
macro ei { push8($fb); }
macro halt { push8($76); }

macro im 0 
{
	push16be($ed46);
}
macro im 1 
{
	push16be($ed56);
}

macro im 2 
{
	push16be($ed5e);
}

