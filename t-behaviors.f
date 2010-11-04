\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests for controllable module

include behaviors

variable #callbacks
variable obj123
variable obj456

: clear
  #callbacks off  obj123 off  obj456 off ;

: _cb ( fk -- )
  1 #callbacks +!
  dup 123 = if obj123 on then
  456 = if obj456 on then ;

: s         0behaviors clear ['] _cb 123 behaves ['] _cb 456 behaves acted ;
: tb0.1     s   #callbacks @ 2 <> abort" tb0.1 callbacks mismatbh" ;
: tb0.2     s   obj123 @ 0= abort" tb0.2 object 123 callback expected" ;
: tb0.3     s   obj456 @ 0= abort" tb0.3 object 456 callback expected" ;

: tb0   tb0.1 tb0.2 tb0.3 ;

: tb    tb0 depth abort" tb: depth" ;

