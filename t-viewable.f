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
: tv0.4     s   123 isViewable? 0= abort" tv0.4 visibility mismatch" ;
: tv0.5     s   124 isViewable? abort" tv0.5 visibility mismatch" ;
: tv0.6     s   124 unviewable depth abort" tv0.6 depth" ;
: tv0   tv0.1 tv0.2 tv0.3 tv0.4 tv0.5 tv0.6 ;

\
\ Exercise object color interface
\

: s         0viewable ['] tv0.1draw1 123 viewable
            $AAA 123 colored ;

: tv1.1     s   123 color $AAA <> abort" tv1.1 color mismatch" ;

: tv1   tv1.1 ;

\
\ Invisibility
\

: s         0viewable ['] tv0.1draw1 123 viewable ;
: tv2.1     s   124 unviewable  123 isViewable? 0= abort" tv2.1 visibility mismatch" ;
: tv2.2     s   123 unviewable  123 isViewable? abort" tv2.2 visibility mismatch" ;
: tv2   tv2.1 ;

: tv    tv0 ( tv1 ( tv2 ( ) depth abort" tv: depth" ;

