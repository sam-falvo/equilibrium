\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Mobility unit tests

include objects
include positionable
include mobility

\
\ Exercise registration and delisting.
\

: s         0objects 0positionables 0mobility
            0 0 123 positioned  3 2 123 mobile ;
: tm0.1     s   depth >r  123 velocity
                2 <> abort" tm0.1 vY mismatch"
                3 <> abort" tm0.1 vX mismatch"
                depth r> - abort" tm0.1 stack depth" ;
: tm0.2     s   depth >r moved  123 position
                2 <> abort" tm0.2 y mismatch"
                3 <> abort" tm0.2 x mismatch"
                depth r> - abort" tm0.2 stack depth" ;
: tm0.3     s   depth >r moved moved  123 position
                4 <> abort" tm0.3 y mismatch"
                6 <> abort" tm0.3 x mismatch"
                depth r> - abort" tm0.3 stack depth" ;
: tm0   tm0.1 tm0.2 tm0.3 ;

: tm    tm0 depth abort" tm: depth" ;

