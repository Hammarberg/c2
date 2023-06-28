macro dec (hl) { push8($35); }
macro dec (ix+@n) { push16be($dd35,false); push8(n); }
macro dec (iy+@n) { push16be($fd35,false); push8(n); }
macro dec a { push8($3d); }
macro dec b { push8($05); }
macro dec bc { push8($0b); }
macro dec c { push8($0d); }
macro dec d { push8($15); }
macro dec de { push8($1b); }
macro dec e { push8($1d); }
macro dec h { push8($25); }
macro dec hl { push8($2b); }
macro dec ix { push16be($dd2b,false); }
macro dec iy { push16be($fd2b,false); }
macro dec l { push8($2d); }
macro dec sp { push8($3b); }

