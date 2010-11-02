\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Keeps track of which objects are in use.  Written for a 32-bit
\ Forth implementation.

100 constant limit
31 constant mask
mask 1+ constant width

limit mask + width / constant /bitmap
create bitmap  /bitmap cells allot

: 0objects ( -- )
  bitmap /bitmap cells 0 fill ;

: row ( pk -- a )
  width / cells bitmap + ;

: column ( pk -- u )
  1 swap mask and lshift ;

: isObject? ( pk -- f )
  dup row @ swap column and 0= 0= ;

: -bit ( pk -- pk )
  dup isObject? if exit then
  dup >r row dup @ r@ column or swap !  r> 2r> 2drop ;

: -word ( pk -- pk )
  dup row @ -1 = if exit then
  begin dup limit < while -bit 1+ repeat
  abort" objects.f: Out of objects" ;

: object ( -- pk )
  0 begin dup limit < while -word width + repeat
  abort" objects.f: Out of objects" ;

: destroyed ( pk -- )
  dup row @ over column invert and swap row ! ;

