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

\
\ Generic accessors
\

: fk@ ( i -- fk )
  cells foreignKeys + @ ;

: fk! ( fk i -- )
  cells foreignKeys + ! ;

: fk0 ( fk -- )
  #records @ fk! ;

: renderer@ ( r -- xt )
  cells renderers + @ ;

: renderer! ( xt r -- )
  cells renderers + ! ;

: renderer0 ( xt -- )
  #records @ renderer! ;

: color@ ( r -- u )
  cells colors + @ ;

: color! ( u r -- )
  cells colors + ! ;

: color0 ( -- )
  $FFFF #records @ color! ;

\
\ viewable
\

: -match ( xt fk i -- xt fk i )
  2dup fk@ = if nip renderer! 2r> 2drop then ;

: -exists ( xt fk -- xt fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: +spacious ( -- )
  #records @ limit >= abort" viewable: attempt to view too many objects" ;

: viewable ( xt fk -- )
  -exists +spacious fk0 renderer0 color0 1 #records +! ;

\
\ drawn
\

: draw ( r -- )
  dup color@ unsafe-color! dup fk@ swap renderer@ execute ;

: drawn ( -- )
  0 begin dup #records @ < while dup draw 1+ repeat drop ;

\
\ unviewable
\

: collapsed ( ofs base -- )
  over >r + dup cell+ swap /column r> cell+ - move ;

: delisted ( r -- )
  cells >r r@ foreignKeys collapsed  r@ renderers collapsed
  r> colors collapsed  -1 #records +! ;

: -match ( fk r -- fk r )
  2dup fk@ = if nip delisted r> drop then ;

: unviewable ( fk -- )
  0 begin dup #records @ < while -match 1+ repeat drop ;

\
\ color
\

: -match ( u fk i -- u fk i )
  2dup cells foreignKeys + @ = if nip cells colors + @ 2r> 2drop then ;

: -exists ( u fk -- u fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: color ( fk -- u )
  -exists abort" viewable.f: attempt to get color on unviewable object" ;

\
\ colored
\
: -match ( u fk i -- u fk i )
  2dup cells foreignKeys + @ = if nip cells colors + ! 2r> 2drop then ;

: -exists ( u fk -- u fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: colored ( u fk -- )
  -exists abort" viewable.f: attempt to set color on unviewable object" ;

\
\ isViewable?
\

: -match ( fk i -- fk i )
  2dup cells foreignKeys + @ = if 2drop -1 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: isViewable? ( fk -- f )
  -exists drop 0 ;

