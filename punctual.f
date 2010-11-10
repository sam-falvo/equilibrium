\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Module supporting scheduled object events.

100 constant limit
limit cells constant /column

create foreignKeys  /column allot
create delays       /column allot
create callbacks    /column allot
variable #records

\
\ Module initialization
\

: 0punctual ( -- )
  0 #records !  foreignKeys /column -1 fill ;

\
\ punctual
\

: matched ( xt uDelay fk i -- )
  cells nip swap over delays + ! callbacks + ! ;

: -match ( xt uDelay fk i -- xt uDelay fk i )
  2dup cells foreignKeys + @ = if matched 2r> 2drop then ;

: -exists ( xt uDelay fk -- xt uDelay fk )
  0 begin dup #records @ < while -match 1+ repeat drop ;

: +spacious ( -- )
  #records @ limit >= abort" punctual: attempt to insert too many objects" ;

: fk! ( fk -- )
  #records @ cells foreignKeys + ! ;

: delay! ( uDelay -- )
  #records @ cells delays + ! ;

: callback! ( xt -- )
  #records @ cells callbacks + ! ;

: punctual ( xt uDelay fk -- )
  -exists +spacious fk! delay! callback! 1 #records +! ;

\
\ lax
\

: collapsed ( base ofs -- )
  /column over cell+ - -rot + dup cell+ swap rot move ;

: delisted ( ofs -- )
  foreignKeys over collapsed delays over collapsed
  callbacks swap collapsed  -1 #records +! ;

: -match ( fk ofs -- fk ofs )
  2dup foreignKeys + @ = if nip delisted 2r> 2drop then ;

: -exists ( fk -- fk )
  0 begin dup #records @ cells < while -match cell+ repeat drop ;

: lax ( fk -- )
  -exists drop ;

\
\ isPunctual?
\

: -match ( fk i -- fk i )
  2dup cells foreignKeys + @ = if nip cells r> drop then ;

: row ( fk -- ofs )
  0 begin dup #records @ < while -match 1+ repeat drop r> drop ;

: -exists ( fk -- fk )
  row drop -1 r> drop ;

: isPunctual? ( fk -- f )
  -exists drop 0 ;

\
\ elapsed
\

: called ( i -- )
  cells >r r@ delays + @ 1 <> if r> drop exit then
  r@ foreignKeys + @ r> callbacks + @ execute ;

: notified ( -- )
  0 begin dup #records @ < while dup called 1+ repeat drop ;

: collapsed ( ofs base -- )
  over >r + dup cell+ swap /column r> cell+ - move ;

: delisted ( i -- )
  cells >r r@ foreignKeys collapsed r@ delays collapsed r>
  callbacks collapsed ;

: -expired ( i -- i )
  dup cells delays + @ 2 < if dup delisted r> drop then ;

: row ( i -- i' )
  -expired 1+ ;

: compacted ( -- )
  0 begin dup #records @ < while row repeat drop ;

: ticked ( i -- )
  cells delays + -1 swap +! ;

: tallied ( -- )
  0 begin dup #records @ < while dup ticked 1+ repeat drop ;

: elapsed ( -- )
  notified compacted tallied ;

