\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Frame Buffer Line Drawing Template
\
\ Depends on the following words, defined PRIOR to including
\ this file:
\
\ long          Computes value dL.
\ short         Computes value dS.
\ dL            Variable containing the length of the long
\               axis of the line.
\ dS            Variable containing the length of the short
\               axis of the line.
\ accumulator   A variable used while rendering the line.
\ short+        Code (often a macro for best performance)
\               to advance the drawing pointer along the
\               short axis of the line.
\ long+         Code (often a macro for best performance)
\               to advance the drawing pointer along the
\               long axis of the line.
\ address       Computes a drawing address containing
\               pixel x0,y0.
\
\ See unsafe-draw.f.

: configured    long short ;
: error         dS @ accumulator +!
                accumulator @ dL @ >= if short+ normalize then ;
: plot          >r dot long+ error r> ;
: (line)        begin dup dL @ < while plot 1+ repeat ;
: line          configured address 0 (line) 2drop ;

