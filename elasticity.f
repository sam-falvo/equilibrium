\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ The set of all objects exhibiting elastic collisions.

100 constant limit
limit cells constant /column

create foreignKeys  /column allot
create handlers     /column allot

variable #records

\
\ 0elasticity
\

: 0elasticity ( -- )
  0 #records !  foreignKeys /column -1 fill ;

\
\ elastic
\

: fk! ( fk -- )
  #records @ cells foreignKeys + ! ;

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if 2drop 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: default ( fk1 fk2 -- )
  2drop ;

: handler! ( -- )
  ['] default #records @ cells handlers + ! ;

: elastic ( fk -- )
  -exists fk! handler! 1 #records +! ;

\
\ confined
\

: x ( dx x -- dx' x' )
  dup 751 > if 751 swap - 751 +  swap abs negate swap then
  dup 0< if negate swap abs swap then ;

: y ( dy y -- dy' y' )
  dup 751 > if 751 swap - 751 +  swap abs negate swap then
  dup 40 < if 40 swap - 40 +  swap abs swap then ;

: h ( fk -- )
  >r r@ xVelocity r@ xPosition x r@ xPositioned r> xSpeed ;

: v ( fk -- )
  >r r@ yVelocity r@ yPosition y r@ yPositioned r> ySpeed ;

: rebounded ( ofs -- )
  dup foreignKeys + @ -1 <> if dup foreignKeys + @ dup h v then drop ;

: confined ( -- )
  0 begin dup #records @ < while dup cells rebounded 1+ repeat
  drop ;

\
\ colliding?
\

: right ( fk -- r )
  dup width swap xPosition + 1- ;

: bottom ( fk -- b )
  dup height swap yPosition + 1- ;

: l ( fk1 fk2 -- l )
  xPosition swap xPosition max ;

: r ( fk1 fk2 -- r )
  right swap right min ;

: t ( fk1 fk2 -- t )
  yPosition swap yPosition max ;

: b ( fk1 fk2 -- b )
  bottom swap bottom min ;

: intersection ( fk1 fk2 -- l r t b )
  2dup l -rot 2dup r -rot 2dup t -rot b ;

: isRectangle? ( l r t b -- f )
  <= -rot <= and ;

: colliding? ( fk1 fk2 -- f )
  intersection isRectangle? ;

\
\ collided
\

: pPreserved ( fk1 fk2 -- )
  2dup swap >r >r velocity rot velocity r> mobile r> mobile ;

: fk@ ( i -- fk )
  cells foreignKeys + @ ;

: keys ( i j -- fk fk )
  fk@ swap fk@ ;

: +valid ( fk fk -- fk fk )
  dup -1 = if 2drop r> drop then
  over -1 = if 2drop r> drop then ;

: -match ( fk i -- fk i )
  2dup fk@ = if nip cells r> drop then ;

: row ( fk -- ofs )
  0 begin dup #records @ < while -match 1+ repeat
  abort" elasticity: inelastic object used" ;

: notify ( fk fk -- )
  dup row handlers + @ execute ;

: col3 ( i j -- )
  keys +valid 2dup colliding? if
  2dup pPreserved 2dup notify then 2drop ;

: col2 ( i -- )
  dup 1+ begin dup #records @ < while 2dup col3 1+ repeat 2drop ;

: collided ( -- )
  0 begin dup #records @ < while dup col2 1+ repeat drop ;

\
\ onCollide
\

: onCollide ( xt fk -- )
  row handlers + ! ;

