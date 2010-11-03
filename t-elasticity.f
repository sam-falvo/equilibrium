\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests covering elastic objects

include objects
include positionable
include mobility
include elasticity

variable o
variable p

: s         0objects 0elasticity 0mobility 0positionables object o !
            749 50 o @ positioned 7 7 o @ mobile o @ elastic
            moved confined ;
: te0.1     s   o @ position
                57 <> abort" te0.1 y mismatch"
                746 <> abort" te0.1 x mismatch"
                o @ velocity
                7 <> abort" te0.1 y speed"
                -7 <> abort" te0.1 x speed" ;

: te0   te0.1 ;

: s         0objects 0elasticity 0mobility 0positionables object o !
            4 50 o @ positioned -7 7 o @ mobile o @ elastic
            moved confined ;
: te1.1     s   o @ position
                57 <> abort" te1.1 y mismatch"
                3 <> abort" te1.1 x mismatch"
                o @ velocity
                7 <> abort" te1.1 y speed"
                7 <> abort" te1.1 x speed" ;

: te1   te1.1 ;

: s         0objects 0elasticity 0mobility 0positionables object o !
            50 749 o @ positioned 7 7 o @ mobile o @ elastic
            moved confined ;
: te2.1     s   o @ position
                746 <> abort" te2.1 y mismatch"
                57 <> abort" te2.1 x mismatch"
                o @ velocity
                -7 <> abort" te2.1 y speed"
                7 <> abort" te2.1 x speed" ;

: te2   te2.1 ;

: s         0objects 0elasticity 0mobility 0positionables object o !
            50 43 o @ positioned 7 -7 o @ mobile o @ elastic
            moved confined ;
: te3.1     s   o @ position
                44 <> abort" te3.1 y mismatch"
                57 <> abort" te3.1 x mismatch"
                o @ velocity
                7 <> abort" te3.1 y speed"
                7 <> abort" te3.1 x speed" ;

: te3   te3.1 ;

: s         0objects 0elasticity 0mobility 0positionables object o !
            749 43 o @ positioned 7 -7 o @ mobile o @ elastic
            moved confined ;
: te4.1     s   o @ position
                44 <> abort" te4.1 y mismatch"
                746 <> abort" te4.1 x mismatch"
                o @ velocity
                7 <> abort" te4.1 y speed"
                -7 <> abort" te4.1 x speed" ;

: te4   te4.1 ;

: s         0objects 0elasticity 0mobility 0positionables object o !
            2 750 o @ positioned -7 7 o @ mobile o @ elastic
            moved confined ;
: te5.1     s   o @ position
                745 <> abort" te5.1 y mismatch"
                5 <> abort" te5.1 x mismatch"
                o @ velocity
                -7 <> abort" te5.1 y speed"
                7 <> abort" te5.1 x speed" ;

: te5   te5.1 ;

: s         0objects 0elasticity 0mobility 0positionables
            object o ! object p !
            16 16 o @ positioned 20 10 o @ mobile o @ elastic
            30 16 p @ positioned 10 10 p @ mobile p @ elastic ;
: te6.1     s   o @ p @ colliding? 0= abort" te6.1 collision detect" ;
: te6.2     s   depth >r o @ p @ pPreserved
                o @ position
                16 <> abort" te6.2 y mismatch on o"
                16 <> abort" te6.2 x mismatch on o"
                o @ velocity
                10 <> abort" te6.2 vY mismatch on o"
                10 <> abort" te6.2 vX mismatch on o"
                p @ position
                16 <> abort" te6.2 y mismatch on p"
                30 <> abort" te6.2 x mismatch on p"
                p @ velocity
                10 <> abort" te6.2 vY mismatch on p"
                20 <> abort" te6.2 vX mismatch on p"
                depth r> - abort" te6.2 depth" ;
: te6   te6.1 te6.2 ;

: s         0objects 0elasticity 0mobility 0positionables
            object o ! object p !
            16 16 o @ positioned 10 20 o @ mobile o @ elastic
            16 31 p @ positioned 20 10 p @ mobile p @ elastic ;
: te7.1     s   o @ p @ colliding? 0= abort" te7.1 collision detect" ;
: te7.2     s   o @ p @ pPreserved
                o @ position
                16 <> abort" te7.2 y mismatch on o"
                16 <> abort" te7.2 x mismatch on o"
                o @ velocity
                10 <> abort" te7.2 vY mismatch on o"
                20 <> abort" te7.2 vX mismatch on o"
                p @ position
                31 <> abort" te7.2 y mismatch on p"
                16 <> abort" te7.2 x mismatch on p"
                p @ velocity
                20 <> abort" te7.2 vY mismatch on p"
                10 <> abort" te7.2 vX mismatch on p" ;
: te7   te7.1 te7.2 ;

: s         0objects 0elasticity 0mobility 0positionables
            object o ! object p !
            16 16 o @ positioned 10 20 o @ mobile o @ elastic
            16 31 p @ positioned 20 10 p @ mobile p @ elastic ;

: te8.1     s   collided
                o @ position
                16 <> abort" te8.1 y mismatch on o"
                16 <> abort" te8.1 x mismatch on o"
                o @ velocity
                10 <> abort" te8.1 vY mismatch on o"
                20 <> abort" te8.1 vX mismatch on o"
                p @ position
                31 <> abort" te8.1 y mismatch on p"
                16 <> abort" te8.1 x mismatch on p"
                p @ velocity
                20 <> abort" te8.1 vY mismatch on p"
                10 <> abort" te8.1 vX mismatch on p" ;

: te8   te8.1 ;

variable #callbacks
: redist    2drop 1 #callbacks +! ;
: s         0objects 0elasticity 0mobility 0positionables
            object o ! object p !
            16 16 o @ positioned 10 20 o @ mobile o @ elastic
            16 31 p @ positioned 20 10 p @ mobile p @ elastic
            ['] redist o @ onCollide ['] redist p @ onCollide
            #callbacks off ;

: te9.1     s   collided  #callbacks @ 1 <> abort" te9.1 callback" ;

: te9       te9.1 ;

: te    te0 te1 te2 te3 te4 te5 te6 te7 te8 te9 depth .s abort" te: depth" ;

