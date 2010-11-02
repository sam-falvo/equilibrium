\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ positionable unit tests

include positionable

\
\ Exercising accessors for position
\

: s         0positionables  13 19 12345 positioned ;
: tp0.1     s   12345 position 19 <> abort" tp0.1 Y mismatch"
                13 <> abort" tp0.1 X mismatch" ;
: tp0.2     s   depth >r 12345 position 2drop depth r>
                <> abort" tp0.2 stack depth mismatch" ;
: tp0.3     s   21 23 54321 positioned
                12345 position 19 <> abort" tp0.3 Y mismatch"
                13 <> abort" tp0.3 X mismatch" ;
: tp0.4     s   12354 hasPosition? abort" tp0.4 unpositioned"
                12345 hasPosition? 0= abort" tp0.4 positioned" ;
: tp0.5     s   depth >r  -8 12 12345 translated
                12345 position
                31 <> abort" tp0.5 y mismatch"
                5 <> abort" tp0.5 x mismatch"
                depth r> - abort" tp0.5 depth" ;

: tp0   tp0.1 tp0.2 tp0.3 tp0.4 tp0.5 ;


: s         0positionables
            13 19 12345 positioned
            21 23 54321 positioned
            29 31 15360 positioned ;
: tp1.1     s   22 44 54321 positioned  12345 position
                19 <> abort" tp1.1 Y mismatch"
                13 <> abort" tp1.1 X mismatch" ;
: tp1.2     s   22 44 54321 positioned  54321 position
                44 <> abort" tp1.1 Y mismatch"
                22 <> abort" tp1.1 X mismatch" ;
: tp1.3     s   22 44 54321 positioned  15360 position
                31 <> abort" tp1.1 Y mismatch"
                29 <> abort" tp1.1 X mismatch" ;

: tp1   tp1.1 tp1.2 tp1.3 ;

: tp    tp0 tp1 depth abort" tp: stack imbalance" ;

