\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests for object tracking

include objects

\
\ Exercise object ID allocation
\

: s         0objects ;
: to0.1     s   object object = abort" to0.1: uniqueness violated" ;

: s         0objects 31 0 do object drop loop ;
: to1.1     s   object 31 <> abort" to1.1: object 31 expected"
                object 32 <> abort" to1.1: object 32 expected"
                object 33 <> abort" to1.1: object 33 expected" ;

: s         0objects object drop object drop object drop ;
: to2.1     s   0 isObject? 0= abort" to2.1: object 0 expected"
                1 isObject? 0= abort" to2.1: object 1 expected"
                2 isObject? 0= abort" to2.1: object 2 expected" ;
: to2.2     s   1 destroyed
                0 isObject? 0= abort" to2.2: object 0 expected"
                1 isObject?    abort" to2.1: object 1 NOT expected"
                2 isObject? 0= abort" to2.1: object 2 expected" ;

: to0   to0.1 ;
: to1   to1.1 ;
: to2   to2.1 to2.2 ;

: tobj  to0 to1 to2 ;
