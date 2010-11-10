\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Dimensionable aspect of objects

100 constant limit
limit cells constant /column

create foreignKeys  /column allot
create widths       /column allot
create heights      /column allot

variable #records

\
\ 0dimensions
\

: 0dimensions ( -- )
  0 #records !  foreignKeys /column -1 fill ;

\
\ dimensioned
\

: changed ( w h fk ofs -- )
  nip swap over heights + ! widths + ! ;

: -match ( w h fk ofs -- w h fk ofs )
  2dup foreignKeys + @ = if changed 2r> 2drop then ;

: -exists ( w h fk -- w h fk )
  0 begin dup #records @ cells < while -match cell+ repeat drop ;

: +room ( -- )
  #records @ limit >= abort" dimensionable: attempt to register too many objects" ;

: fk ( fk -- )
  #records @ cells foreignKeys + ! ;

: h ( h -- )
  #records @ cells heights + ! ;

: w ( w -- )
  #records @ cells widths + ! ;

: dimensioned ( w h fk -- )
  -exists +room fk h w 1 #records +! ;

\
\ undimensioned
\

: collapsed ( base ofs -- )
  /column over cell+ - -rot + dup cell+ swap rot move ;

: removed ( ofs -- )
  foreignKeys over collapsed widths over collapsed
  heights swap collapsed  -1 #records +! ;

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip removed r> drop then ;

: undimensioned ( fk -- )
  0 begin dup #records @ cells < while -match cell+ repeat 2drop ;

\
\ isDimensioned?
\

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if 2drop -1 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ cells < while -match cell+ repeat drop ;

: isDimensioned? ( fk -- f )
  -exists drop 0 ;

\
\ width
\

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ cells < while -match cell+ repeat drop ;

: row ( fk -- ofs )
  -exists -1 abort" dimensionable: attempt to query non-dimensioned object" ;

: width ( fk -- w )
  row widths + @ ;

\
\ height
\

: height ( fk -- h )
  row heights + @ ;

