\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ viewable unit tests

include workstation
include unsafe-draw
include viewable

variable #draws
variable &depth

\
\ Exercise object registration and delisting.  Side-effect:
\ also exercises procedure to draw all viewable objects.
\

: tv0.1draw1    depth &depth !
                123 <> abort" tv0.1draw1 foreign key doesn't match"
                1 #draws +! ;

: tv0.1draw2    depth &depth @ <>
                abort" tv0.1draw2 stack depth mismatch"
                456 <> abort" tv0.1draw2 foreign key doesn't match"
                1 #draws +! ;

: tv0.1draw3    depth &depth @ <>
                abort" tv0.1draw3 stack depth mismatch"
                789 <> abort" tv0.1draw3 foreign key doesn't match"
                1 #draws +! ;


: s         0viewable
            ['] tv0.1draw1 123 viewable
            ['] tv0.1draw2 456 viewable
            ['] tv0.1draw3 789 viewable ;

: tv0.1     s   #draws off  drawn
                #draws @ 3 <> abort" tv0.1"
                depth abort" tv0.1 depth mismatch" ;
: tv0.2     s   456 unviewable
                #draws off  drawn
                #draws @ 2 <> abort" tv0.2"
                depth abort" tv0.2 depth mismatch" ;
: tv0.3     s   123 color $FFFF <> abort" tv0.3 color mismatch" ;

: tv0   tv0.1 tv0.2 tv0.3 ;

\
\ Exercise object color interface
\

: s         0viewable ['] tv0.1draw1 123 viewable
            $AAA 123 colored ;

: tv1.1     s   123 color $AAA <> abort" tv1.1 color mismatch" ;

: tv1   tv1.1 ;

: tv    tv0 tv1 ;

