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
include dimensionable
include elasticity
include behaviors
include punctual
include players
include scoreboard

variable done
variable &goc
variable &human
variable &timer

\
\ Game over controller -- assumes control of UI
\ when game is not in session.
\

30 constant duration ( in frames )

defer _goc ( fkUnused -- )
defer _timeup ( fkUnused -- )

: respond ( fkHuman -- )
  velocity controls up lf dn rt drop &human @ mobile ;

: disengaged ( -- )
  inhibited  &human @ unresponsive  greeted  ['] _goc &goc @ behaves ;

: armed ( -- )
  ['] _timeup duration &goc @ punctual ;

: (_timeup) ( fkUnused -- )
  drop &timer @ 1- dup &timer ! if armed exit then disengaged ;

' (_timeup) is _timeup

: playing ( -- )
  uninhibited  60 &timer !  &goc @ unresponsive  armed
  ['] respond &human @ behaves  engaged  rescored ;

: (_goc) ( fkUnused -- )
  drop  controls 2 = if playing then ;

' (_goc) is _goc

: goc ( -- )
  object dup &goc !  ['] _goc swap behaves ;

\
\ Main loop iteration
\

: d(   s" depth >r" evaluate ; immediate
: z)   s" depth r> <> z" evaluate ; immediate
: y)   s" depth r> <> y" evaluate ; immediate
: x)   s" depth r> <> x" evaluate ; immediate
: w)   s" depth r> <> w" evaluate ; immediate
: v)   s" depth r> <> v" evaluate ; immediate
: u)   s" depth r> <> u" evaluate ; immediate
: t)   s" depth r> <> t" evaluate ; immediate
: z     abort" drawn depth" ;
: y     abort" moved depth" ;
: x     abort" collided depth" ;
: w     abort" confined depth" ;
: v     abort" acted depth" ;
: u     abort" synced depth" ;
: t     abort" elapsed depth" ;

: frame ( -- )
  black d( drawn z) d( moved y) d( collided x) d( confined w)
  d( acted v) d( synced u) d( elapsed t) ;

\
\ Playfield
\

: _border ( fkUnused -- )
  drop  0 40 origin  767 767 extent  rectangle ;

: border ( -- )
  ['] _border object viewable ;

\
\ Basic game configuration
\

: human ( -- )
  vehicle &human !  ;

: players ( -- )
  human 4 bots assigned ;

: configured ( -- )
  1337 seeded  players
  &human @ scoreboard
  &timer clock
  border goc ;

\
\ Game main loop/entry point
\

: check   key? if key drop done on then ;

: init'd ( -- )
  0viewable 0objects 0positionables 0mobility
  0elasticity 0behaviors 0players 0punctual
  0dimensions ;

: game ( -- )
  init'd  presented  done off  configured
  begin frame check flip done @ until  hidden ;

