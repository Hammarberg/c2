macro sub (hl)    { push8($96); }
macro sub hx      { push16be($dd94,false); }
macro sub hy      { push16be($fd94,false); }
macro sub lx      { push16be($dd95,false); }
macro sub ly      { push16be($fd95,false); }

macro sub (ix+@n)  { push16be($dd96,false); push8(n); }
macro sub (iy+@n)  { push16be($fd96,false); push8(n); } 
macro sub @[z80n]r { push8($90 + r); } 
macro sub @n       { push8($d6); push8(n); }
