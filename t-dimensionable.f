\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests covering the dimensionable aspect.

include dimensionable

: s         0dimensions 8 13 123 dimensioned ;

: td0.1     s   124 isDimensioned? abort" td0.1: unexpected dimansions" ;
: td0.2     s   123 isDimensioned? 0= abort" td0.2: dimensions expected" ;
: td0.3     s   123 width 8 <> abort" td0.3: width" ;
: td0.4     s   123 height 13 <> abort" td0.4: height" ;
: td0.5     s   123 undimensioned  123 isDimensioned? abort" td0.5: no longer dimensioned" ;

: td0   td0.1 td0.2 td0.3 td0.4 td0.5 ;

: td    td0 depth abort" td: depth" ;

