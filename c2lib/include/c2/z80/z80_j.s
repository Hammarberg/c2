macro JP (HL) 	{push8($E9);}
macro JP (IX) 	{push16be($DDE9,false);}
macro JP (IY) 	{push16be($FDE9,false);}
macro JR @N   	{ push8($18); push8(N); }
macro JR C,@N   { push8($38); push8(N); }
macro JR NC,@N  { push8($30); push8(N); }
macro JR NZ,@N  { push8($20); push8(N); }
macro JR Z,@N   { push8($28); push8(N); }
macro JP @NN     {push8($C3); push16be(NN,true); }
macro JP C,@NN   {push8($DA); push16be(NN,true); }
macro JP M,@NN   {push8($FA); push16be(NN,true); }
macro JP NC,@NN  {push8($D2); push16be(NN,true); }
macro JP NZ,@NN  {push8($C2); push16be(NN,true); }
macro JP P,@NN   {push8($F2); push16be(NN,true); }
macro JP PE,@NN  {push8($EA); push16be(NN,true); }
macro JP PO,@NN  {push8($E2); push16be(NN,true); }
macro JP Z,@NN   {push8($CA); push16be(NN,true); }
