
macro ld (hl),@[Z80n]r { push8($70 + r); }
macro ld e,@[Z80n]r    { push8($58 + r); }
macro ld h,@[Z80n]r    { push8($60 + r); }
macro ld l,@[Z80n]r    	{ push8($68 + r); }
macro ld b,@[Z80n]r    { push8($40 + r); }
macro ld c,@[Z80n]r    	{ push8($48 + r); }
macro ld d,@[Z80n]r    { push8($50 + r); }
macro ld a,@[Z80n]r    	{ push8($78+ r); }

macro ld (ix+@n),@[Z80n]r { push8($dd); push8($70+r); push8(n);}
macro ld (iy+@n),@[Z80n]r { push8($fd); push8($70+r); push8(n);}

macro ld d,(hl { push8($56); }

macro ld (@nn),bc  { push16be($ed43,false); push16be(nn,true); }
macro ld (@nn),de  { push16be($ed53,false); push16be(nn,true); }
macro ld (@nn),ix  { push16be($dd22,false); push16be(nn,true); }
macro ld (@nn),iy  { push16be($fd22,false); push16be(nn,true); }
macro ld (@nn),sp  { push16be($ed73,false); push16be(nn,true); }
macro ld ix,(@nn)  { push16be($dd2a,false); push16be(nn,true); }
macro ld ix,@nn    { push16be($dd21,false); push16be(nn,true); }
macro ld iy,(@nn)  { push16be($fd2a,false); push16be(nn,true); }
macro ld iy,@nn    { push16be($fd21,false); push16be(nn,true); }
macro ld sp,(@nn)  { push16be($ed7b,false); push16be(nn,true); }
macro ld de,(@nn)  { push16be($ed5b,false); push16be(nn,true); }
macro ld bc,(@nn)  { push16be($ed4b,false); push16be(nn,true); }

macro ld hl,(@nn) { push8($2a); push16be(nn,true); }
macro ld hl,@nn   { push8($21); push16be(nn,true); }
macro ld de,@nn   { push8($11); push16be(nn,true); }
macro ld bc,@nn   { push8($01); push16be(nn,true); }
macro ld a,(@nn)  { push8($3a); push16be(nn,true); }
macro ld sp,@nn   { push8($31); push16be(nn,true); }
macro ld (@nn),a  { push8($32); push16be(nn,true); }
macro ld (@nn),hl { push8($22); push16be(nn,true); }

macro ld d,(ix+@n) { push16be($dd56,false); push8(n); }
macro ld d,(iy+@n) { push16be($fd56,false); push8(n); }
macro ld a,(ix+@n) { push16be($dd7e,false); push8(n); }
macro ld a,(iy+@n) { push16be($fd7e,false); push8(n); }

macro ld (de),a     { push8($12); }
macro ld a,(bc)     { push8($0a); }
macro ld a,(de)     { push8($1a); }
macro ld a,(hl)     { push8($7e); }
macro ld b,(hl)     { push8($46); }
macro ld c,(hl)     { push8($4e); }
macro ld e,(hl)     { push8($5e); }
macro ld h,(hl)     { push8($66); }
macro ld l,(hl)     { push8($6e); }
macro ld sp,hl      { push8($f9); }

macro ld e,@n       { push8($1e); push8(n); }
macro ld h,@n       { push8($26); push8(n); }
macro ld l,@n       { push8($2e); push8(n); }
macro ld a,@n       { push8($3e); push8(n); }
macro ld b,@n       { push8($06); push8(n); }
macro ld c,@n       { push8($0e); push8(n); }
macro ld (hl),@n    { push8($36); push8(n); }

macro ld hx,@n       { push16be($dd26); push8(n); }
macro ld hy,@n       { push16be($fd26); push8(n); }
macro ld l,(ix+@n)   { push16be($dd6e); push8(n); }
macro ld l,(iy+@n)   { push16be($fd6e); push8(n); }
macro ld lx,@n       { push16be($fd2e); push8(n); }
macro ld ly,@n       { push16be($fd2e); push8(n); }
macro ld e,(ix+@n)   { push16be($dd5e); push8(n); }
macro ld e,(iy+@n)   { push16be($fd5e); push8(n); }
macro ld b,(ix+@n)   { push16be($dd46); push8(n); }
macro ld b,(iy+@n)   { push16be($fd46); push8(n); }
macro ld c,(ix+@n)   { push16be($dd4e); push8(n); }
macro ld c,(iy+@n)   { push16be($fd4e); push8(n); }
macro ld h,(ix+@n)   { push16be($dd66); push8(n); }
macro ld h,(iy+@n)   { push16be($fd66); push8(n); }
macro ld (ix+@n),@m   { push16be($dd36); push8(n); push8(m);} 
macro ld (iy+@n),@m   { push16be($fd36); push8(n); push8(m);} 

macro ld a,hx       { push8($dd); push8($7c); } 
macro ld a,hy       { push8($fd); push8($7c); } 
macro ld a,lx       { push8($dd); push8($7d); } 
macro ld a,ly       { push8($fd); push8($7d); } 
macro ld a,i        { push8($ed); push8($57); } 
macro ld a,r        { push8($ed); push8($5f); } 
macro ld b,hx       { push8($dd); push8($44); } 
macro ld b,hy       { push8($fd); push8($44); } 
macro ld b,lx       { push8($dd); push8($45); } 
macro ld b,ly       { push8($fd); push8($45); } 
macro ld c,hx       { push8($dd); push8($4c); } 
macro ld c,hy       { push8($fd); push8($4c); } 
macro ld c,lx       { push8($dd); push8($4d); } 
macro ld c,ly       { push8($fd); push8($4d); } 
macro ld d,hx       { push8($dd); push8($54); } 
macro ld d,hy       { push8($fd); push8($54); } 
macro ld d,lx       { push8($dd); push8($55); } 
macro ld d,ly       { push8($fd); push8($55); } 
macro ld d,n        { push8($16); push8($xx); } 
macro ld e,hx       { push8($dd); push8($5c); } 
macro ld e,hy       { push8($fd); push8($5c); } 
macro ld e,lx       { push8($dd); push8($5d); } 
macro ld e,ly       { push8($fd); push8($5d); } 
macro ld i,a        { push8($ed); push8($47); } 
macro ld r,a        { push8($ed); push8($4f); } 
macro ld sp,ix      { push8($dd); push8($f9); } 
macro ld sp,iy      { push8($fd); push8($f9); } 

macro ld ly,@[Z80nh]r { push8($dd); push8($68+r); }
macro ld hx,@[Z80nh]r { push8($dd); push8($60+r); }
macro ld hy,@[Z80nh]r { push8($fd); push8($60+r); }
macro ld lx,@[Z80nh]r { push8($dd); push8($68+r); }
