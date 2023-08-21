macro sbc a,(hl) { push8($9e); } 
macro sbc hx    { push16be($dd9c,false); }
macro sbc hy    { push16be($fd9c,false); }
macro sbc lx    { push16be($dd9d,false); }
macro sbc ly    { push16be($fd9d,false); }
macro sbc a,@n   { push16be($de00+n,false); }
macro sbc hl,bc { push16be($ed42,false); }
macro sbc hl,de { push16be($ed52,false); }
macro sbc hl,hl { push16be($ed62,false); }
macro sbc hl,sp { push16be($ed72,false); }

macro sbc a,(ix+@n) { push16be($dd9e,false); push8(n); }
macro sbc a,(iy+@n) { push16be($fd9e,false); push8(n); }
macro sbc a,@[z80n]r { push8($98 + r); } 

