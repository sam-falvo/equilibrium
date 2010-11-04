\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Main driver

include workstation
include wrapped-draw
include mersenne
include viewable
include objects
include positionable
include mobility
include elasticity
include behaviors
include players
include scoreboard

variable done

: frame ( -- )
  black drawn moved collided confined acted 33 synced ;

: border ( fkUnused -- )
  drop  0 40 origin  767 767 extent  rectangle ;

: configured ( -- )
  1337 seeded
  players
  ['] scoreboard object viewable
  ['] border object viewable ;

: check   key? if key drop done on then ;

: game ( -- )
  0viewable 0objects 0positionables 0mobility
  0elasticity 0behaviors 0players
  presented  done off  configured
  begin frame check flip done @ until  hidden ;

