macro POP AF  {push8($F1);}
macro POP BC  {push8($C1);}
macro POP DE  {push8($D1);}
macro POP HL  {push8($E1);}
macro PUSH AF {push8($F5);}
macro PUSH BC {push8($C5);}
macro PUSH DE {push8($D5);}
macro PUSH HL {push8($E5);}

macro POP IY  {push16be($FDE1,false); }
macro POP IX  {push16be($DDE1,false); }
macro PUSH IX {push16be($DDE5,false); }
macro PUSH IY {push16be($FDE5,false); }
