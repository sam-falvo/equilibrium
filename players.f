\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Implements player logic, both AI and human.

16 constant /side

variable &human

: up ( vx vy n -- vx vy n )
  dup 1 and if >r 1- r> then ;

: dn ( vx vy n -- vx vy n )
  dup 4 and if >r 1+ r> then ;

: lf ( vx vy n -- vx vy n )
  dup 2 and if rot 1- -rot then ;

: rt ( vx vy n -- vx vy n )
  dup 8 and if rot 1+ -rot then ;

: adj ( -- )
  &human @ velocity controls up lf dn rt drop &human @ mobile ;

: _render ( fk -- )
  dup position origin  position /side + swap /side + swap extent
  rectangle ;

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
  ['] _render r@ viewable
  probability $FFFF and r@ colored
  r> ;

: human ( -- )
  vehicle &human ! ;

: bot ( -- )
  vehicle drop ;

: bots ( -- )
  0 do bot loop ;

: players ( -- )
  human 4 bots ;

