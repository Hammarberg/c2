macro RET    {push8($C9);}
macro RET C  {push8($D8);}
macro RET M  {push8($F8);}
macro RET NC {push8($D0);}
macro RET NZ {push8($C0);}
macro RET P  {push8($F0);}
macro RET PE {push8($E8);}
macro RET PO {push8($E0);}
macro RET Z  {push8($C8);}
macro RETI push16be($ED4D);}
macro RETN push16be($ED45);}

