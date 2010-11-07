\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests covering players as abstract entities

include objects
include mersenne
include workstation
include wrapped-draw
include positionable
include mobility
include elasticity
include viewable
include behaviors
include players

: s         0players 1234 seeded 123 player ;
: tp0.1     s   123 score abort" tp0.1 score mismatch" ;

: tp0   tp0.1 ;

: s         0players 2 seeded 123 player 456 player 789 player assigned ;
: tp1.1     s   123 score 456 score 789 score + +
            10000 <> abort" tp1.1 score total mismatch" ;
: tp1.2     s   123 456 redistributed
            123 score 456 score <> abort" tp1.2 score mismatch" ; 
: tp1.3     s   123 789 redistributed
            123 score 789 score <> abort" tp1.3 score mismatch" ;
: tp1.4     s   456 789 redistributed
            456 score 789 score <> abort" tp1.4 score mismatch" ;
: tp1   tp1.1 tp1.2 tp1.3 tp1.4 ;

: tp    tp0 tp1 depth abort" tp: depth" ;

