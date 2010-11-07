\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Implements player logic, both AI and human.

100 constant limit
limit cells constant /column

create foreignKeys  /column allot
create scores       /column allot

variable #records

: 0players ( -- )
  0 #records !  foreignKeys /column -1 fill ;

: fk! ( fk -- )
  #records @ cells foreignKeys + ! ;

: fk@ ( i -- )
  cells foreignKeys + @ ;

: -match ( fk i -- fk i )
  2dup fk@ = if 2drop 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: score! ( -- )
  #records @ cells scores + off ;

: player ( fk -- )
  -exists fk! score! 1 #records +! ;

: -match ( fk i -- fk i )
  2dup fk@ = if nip cells r> drop then ;

: row ( fk -- ofs )
  0 begin dup #records @ < while -match 1+ repeat
  abort" players: attempt to access non-existant player" ;

: score ( fk -- )
  row scores + @ ;

: any ( -- ofs )
  begin probability 29 lshift dup #records @ u< if cells exit then drop
  again ;

: assigned ( -- )
  10000 any scores + ! ;

: rows ( fk1 fk2 -- ofs1 ofs2 )
  row swap row ;

: score@ ( ofs -- u )
  scores + @ ;

: scored ( u fk -- )
  row scores + ! ;

: redistributed ( fk1 fk2 -- )
  2dup score swap score + 2/ dup >r swap scored r> swap scored ;



16 constant /side


: up ( vx vy n -- vx vy n )
  dup 1 and if >r 1- r> then ;

: dn ( vx vy n -- vx vy n )
  dup 4 and if >r 1+ r> then ;

: lf ( vx vy n -- vx vy n )
  dup 2 and if rot 1- -rot then ;

: rt ( vx vy n -- vx vy n )
  dup 8 and if rot 1+ -rot then ;

: body ( fk -- )
  dup position origin  position /side + swap /side + swap extent
  rectangle ;

: +valid ( n r -- n r )
  dup cells foreignKeys + @ -1 = if r> drop then ;

: considered ( n r -- n' r )
  +valid dup cells scores + @ rot max swap ;

: highest ( -- n )
  0 0 begin dup #records @ < while considered 1+ repeat drop ;

: -highest? ( n -- )
  highest <> ;

: +highest ( fk -- fk )
  dup score -highest? if r> 2drop then ;

: flag ( fk -- )
  +highest
  dup position 4 + swap 4 + ox ! oy !
  dup position 12 + swap 12 + dx ! dy ! line
  dup position 4 + swap 12 + ox ! oy !
  position 12 + swap 4 + dx ! dy ! line ;

: _render ( fk -- )
  dup body flag ;

: x ( -- 2 <= n < 750 )
  probability abs 766 /side - mod 2 + ;

: y ( -- 42 <= n < 764 )
  probability abs 720 /side - mod 42 + ;

: coordinates ( -- x y )
  x y ;

: vx ( -- -8 <= vx <= 7 )
  probability 29 rshift ;

: vy ( -- -8 <= vx <= 7 )
  probability 29 rshift ;

: vector ( -- vX vY )
  vx vy ;

: vehicle ( -- )
  object >r
  coordinates r@ positioned
  vector r@ mobile
  r@ elastic
  ['] redistributed r@ onCollide
  r@ player
  ['] _render r@ viewable
  probability $FFFF and r@ colored
  r> ;

: bot ( -- )
  vehicle drop ;

: bots ( -- )
  0 do bot loop ;

\
\ inhibited
\

: maintain ( fk1 kf2 -- )
  2drop ;

: prevented ( i -- )
  ['] maintain over cells foreignKeys + @ onCollide ;

: inhibited ( -- )
  0 begin dup #records @ < while prevented 1+ repeat drop ;

\
\ uninhibited
\

: encouraged ( i -- )
  ['] redistributed over cells foreignKeys + @ onCollide ;

: uninhibited ( -- )
  0 begin dup #records @ < while encouraged 1+ repeat drop ;

\
\ rescored
\

: zeroed ( i -- )
  0 over cells foreignKeys + @ scored ;

: rescored ( -- )
  0 begin dup #records @ < while zeroed 1+ repeat drop assigned ;

