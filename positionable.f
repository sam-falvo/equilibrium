\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Maintains positions of objects.

100 constant limit
limit cells constant /column

create foreignKeys      /column allot
create xs               /column allot
create ys               /column allot
variable #records

\
\ 0positionables
\

: 0positionables ( -- )
  0 #records !  foreignKeys /column -1 fill ;

\
\ positioned
\

: +spacious ( -- )
  #records @ limit >= abort" positionable.f: out of rows" ;

: updated ( x y fk ofs -- )
  >r drop r@ ys + ! r> xs + ! ;

: -match ( x y fk ofs - x y fk ofs )
  2dup foreignKeys + @ = if updated 2r> 2drop then ;

: -exists ( x y fk -- x y fk )
  0 begin dup /column < while -match cell+ repeat drop ;

: fk! ( fk -- )
  #records @ cells  foreignKeys + ! ;

: y! ( y -- )
  #records @ cells  ys + ! ;

: x! ( x -- )
  #records @ cells  xs + ! ;

: positioned ( x y fk -- )
  +spacious -exists  fk! y! x!  1 #records +! ;

\
\ unpositioned
\

: collapsed ( base ofs -- )
  /column over cell+ - -rot + dup cell+ swap rot move ;

: delisted ( ofs -- )
  foreignKeys over collapsed xs over collapsed ys swap collapsed
  -1 #records +! ;

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip delisted 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ cells < while -match cell+ repeat drop ;

: unpositioned ( fk -- )
  -exists drop ;

\
\ position
\

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip r> drop then ;

: row ( fk -- ofs )
  0 begin dup /column < while -match cell+ repeat
  abort" positionable.f: attempt to query position of unknown object" ;

: position ( fk -- x y )
  row dup xs + @ swap ys + @ ;

\
\ translated
\

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if 2drop -1 r> drop then ;

: hasPosition? ( fk -- f )
  0 begin dup /column < while -match cell+ repeat 2drop 0 ;

: translated ( dx dy fk -- )
  row swap over ys + +! xs + +! ;

\
\ getters/setters
\

: xPosition ( fk -- x )
  row xs + @ ;

: xPositioned ( x fk -- )
  row xs + ! ;

: yPosition ( fk -- y )
  row ys + @ ;

: yPositioned ( y fk -- )
  row ys + ! ;

