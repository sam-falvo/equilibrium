\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Unit tests exercising the "waiting" aspect of objects.

include objects
include punctual

variable o
variable #calls

: cb    o @ <> abort" tp: cb: object ID mismatch"  1 #calls +! ;

: s     0punctual 0objects  object o !  ['] cb 5 o @ punctual  #calls off ;
: e     elapsed ;
: tp0.0     s   o @ 1+ isPunctual? abort" tp0.0 huh?"
                depth abort" tp0.0: depth" ;
: tp0.1     s   o @ isPunctual? 0= abort" tp0.1 expecting event" ;
: tp0.2     s   e e e e  o @ isPunctual? 0= abort" tp0.2 expecting event"
                #calls @ abort" tp0.2 wrongly notified" ;
: tp0.3     s   e e e e e  o @ isPunctual? abort" tp0.3 blew schedule"
                #calls @ 0= abort" tp0.3 notification expected" ;
: tp0.4     s   e e e e e e  o @ isPunctual? abort" tp0.4 blew schedule"
                #calls @ 1 <> abort" tp0.4 notification count" ;

: tp0   tp0.0 tp0.1 tp0.2 tp0.3 tp0.4 ;


variable p

variable #o
variable #p
variable #?

: cb    dup p @ = if 1 #p +! drop exit then
        dup o @ = if 1 #o +! drop exit then 
        1 #? +! drop ;

: s     0punctual 0objects  object o !  object p !
        #o off  #p off  #? off
        ['] cb 5 o @ punctual  ['] cb 5 p @ punctual  #calls off ;
: tp1.1     s   e e e e  #o @ abort" tp1.1 callback o unexpected"
                #p @ abort" tp1.1 callback p unexpected"
                #? @ abort" tp1.1 callback ? unexpected" ;
: tp1.2     s   e e e e e e  #o @ 1 <> abort" tp1.2 callback o unexpected"
                #p @ 1 <> abort" tp1.2 callback p unexpected"
                #? @ abort" tp1.2 callback ? unexpected" ;

: tp1   tp1.1 tp1.2 ;

: s     0punctual 0objects  object o !  object p !
        #o off  #p off  #? off
        ['] cb 3 o @ punctual  ['] cb 5 p @ punctual  #calls off ;
: tp2.1     s   e e e #o @ 1 <> abort" tp2.1 callback o unexpected"
                #p @ abort" tp2.1 callback p unexpected"
                #? @ abort" tp2.1 callback ? unexpected" ;
: tp2.2     s   e e e e e e  #o @ 1 <> abort" tp2.2 callback o unexpected"
                #p @ 1 <> abort" tp2.2 callback p unexpected"
                #? @ abort" tp2.2 callback ? unexpected" ;

: tp2   tp2.1 tp2.2 ;

: s     0punctual 0objects  object o !  object p !
        #o off  #p off  #? off
        ['] cb 6 o @ punctual  ['] cb 5 p @ punctual  #calls off ;
: tp3.1     s   e e e e e  #o @ abort" tp3.1 callback o unexpected"
                #p @ 1 <> abort" tp3.1 callback p unexpected"
                #? @ abort" tp3.1 callback ? unexpected" ;
: tp3.2     s   e e e e e e  #o @ 1 <> abort" tp3.2 callback o unexpected"
                #p @ 1 <> abort" tp3.2 callback p unexpected"
                #? @ abort" tp3.2 callback ? unexpected" ;

: tp3   tp3.1 tp3.2 ;

: tp    tp0 tp1 tp2 tp3 depth abort" tp: depth" ;

