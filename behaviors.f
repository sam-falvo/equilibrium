\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Module that implements the plumbing for game behaviors.

100 constant limit
limit cells constant /column

variable #records
create foreignKeys  /column allot
create actions      /column allot

: 0behaviors ( -- )
  0 #records !  foreignKeys /column -1 fill ;

: fk! ( fk -- )
  #records @ cells foreignKeys + ! ;

: action! ( xt -- )
  #records @ cells actions + ! ;

: updated ( xt fk i -- )
  nip cells actions + ! ;

: -match ( xt fk i -- xt fk i )
  2dup cells foreignKeys + @ = if updated 2r> 2drop then ;

: -exists ( xt fk -- xt fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: behaves ( xt fk -- )
  -exists fk! action! 1 #records +! ;

: behaved ( i -- )
  cells dup foreignKeys + @ swap actions + @ execute ;

: acted ( -- )
  0 begin dup #records @ < while dup behaved 1+ repeat drop ;

