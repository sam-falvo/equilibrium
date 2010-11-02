\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Management of mobile objects

100 constant limit
limit cells constant /column

create foreignKeys  /column allot
create vXs          /column allot   ( velocity components )
create vYs          /column allot
create vXFractions  /column allot   ( fractionals of velocity )
create vYFractions  /column allot
create aXs          /column allot   ( acceleration components )
create aYs          /column allot
variable #records

: 0mobility ( -- )
  0 #records !  foreignKeys /column -1 fill ;

: fk! ( fk -- )
  #records @ cells foreignKeys + ! ;

: vY! ( vY -- )
  #records @ cells vYs + ! ;

: vX! ( vX -- )
  #records @ cells vXs + ! ;

: updated ( vX vY fk ofs -- )
  dup >r foreignKeys + !  r@ vYs + !  r> vXs + ! ;

: -match ( vX vY fk ofs -- vX vY fk ofs )
  2dup foreignKeys + @ = if updated 2r> 2drop then ;

: -exists ( vX vY fk -- vX vY fk )
  0 begin dup /column < while -match cell+ repeat drop ;

: +spacious ( vX vY fk -- vX vY fk )
  #records @ limit >= abort" mobility.f: out of records" ;

: +positionable ( vX vY fk -- vX vY fk )
  dup hasPosition? 0=
  abort" mobility.f: Mobile objects must have position" ;

: 0fractions ( -- )
  #records @ cells aXs + off
  #records @ cells aYs + off
  #records @ cells vXFractions + off
  #records @ cells vYFractions + off ;

: mobile ( vX vY fk -- )
  +positionable -exists +spacious fk! vY! vx!
  0fractions 1 #records +! ;

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip r> drop then ;

: row ( fk -- ofs )
  0 begin dup /column < while -match cell+ repeat
  2drop 0 0 r> drop ;

: velocity ( fk -- vX vY )
  row dup vXs + @ swap vYs + @ ;

: scooted ( ofs -- )
  >r vXs r@ + @  vYs r@ + @  foreignKeys r> + @  translated ;

: +valid ( ofs -- ofs )
  dup foreignKeys + @ -1 = if drop r> drop then ;

: adjusted ( ofs -- )
  +valid scooted ;

: moved ( -- )
  0 begin dup #records @ < while dup cells adjusted 1+ repeat drop ;

: xVelocity ( fk -- vx )
  row vXs + @ ;

: xSpeed ( vx fk -- )
  row vXs + ! ;

: yVelocity ( fk -- vy )
  row vYs + @ ;

: ySpeed ( vy fk -- )
  row vYs + ! ;

