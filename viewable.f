\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Support for viewable objects

100 constant limit

limit cells constant /column

create foreignKeys      /column allot
create renderers        /column allot
create colors           /column allot

variable #records

: 0viewable ( -- )
  0 #records !  foreignKeys /column -1 fill ;

: +spacious ( xt fk -- xt fk )
  #records @ limit < if exit then r> drop 2drop ;

: fk! ( fk r -- )
  cells foreignKeys + ! ;

: fk@ ( r -- fk )
  cells foreignKeys + @ ;

: renderer! ( xt r -- )
  cells renderers + ! ;

: renderer@ ( r -- xt )
  cells renderers + @ ;

: color@ ( r -- u )
  cells colors + @ ;

: 0color ( r -- )
  $FFFF swap cells colors + ! ;

: viewable ( xt fk -- )
  +spacious #records @ swap over 0color over fk! renderer! 1 #records +! ;

: +valid ( r -- r )
  dup fk@ -1 = if drop r> drop then ;

: draw ( r -- )
  +valid dup color@ unsafe-color! dup fk@ swap renderer@ execute ;

: drawn ( -- )
  0 begin dup #records @ < while dup draw 1+ repeat drop ;

: nulled ( r -- )
  -1 swap fk! ;

: -match ( fk r -- fk r )
  2dup fk@ = if nulled drop r> drop then ;

: unviewable ( fk -- )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: -match ( u fk i -- u fk i )
  2dup cells foreignKeys + @ = if nip cells colors + @ 2r> 2drop then ;

: -exists ( u fk -- u fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: color ( fk -- u )
  -exists abort" viewable.f: attempt to get color on unviewable object" ;

: -match ( u fk i -- u fk i )
  2dup cells foreignKeys + @ = if nip cells colors + ! 2r> 2drop then ;

: -exists ( u fk -- u fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: colored ( u fk -- )
  -exists abort" viewable.f: attempt to set color on unviewable object" ;

