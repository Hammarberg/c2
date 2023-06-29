macro or hx { push16be($ddb4,false); }
macro or hy { push16be($fdb4,false); }
macro or lx { push16be($ddb5,false); }
macro or ly { push16be($fdb5,false); }
macro or @n  { push8($f6); push8(n);}
macro or @[Z80n]r {push8($B0+r); }


