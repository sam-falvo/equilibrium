\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Frame Buffer Drawing Primitives

( After updates to the framebuffer finish, this word causes )
( SDL to translate the bitmap into the native host graphical )
( format. )
: flip      screen @ SDL_Flip ;

( Clear the framebuffer to black. )
: black     bitmap  pitch px/column *  0 fill ;

( Drawing a line quickly requires we handle four drawing )
( directions separately.  See the directions listed below: )

(       ^                 Octant 1                      )
(       |                 From left to right, bottom to )
(      |                  top, slope greater than 45    )
(      |                  degrees.                      )
(     |                                                 )
(     |                                                 )

(             --->        Octant 2                         )
(         ----            From left to right, bottom to    )
(     ----                top, slope less than 45 degrees. )

(     ----                Octant 3                            )
(         ----            From left to right, top to          )
(             --->        bottom, slope less than 45 degrees. )

(     |                   Octant 4                      )
(     |                   From left to right, top to    )
(      |                  bottom, slope greater than 45 )
(      |                  degrees.                      )
(       |                                               )
(       V                                               )

( Note we only explicitly handle four octants.  The remaining )
( octants hold symmetry with the handled octants, which we )
( support merely by swapping the coordinates of the lines. )

variable x0  variable y0
variable x1  variable y1

: x0<x1         x0 @ x1 @ < if exit then
                x0 @ x1 @ x0 ! x1 !  y0 @ y1 @ y0 ! y1 ! ;

( We note that all lines have a long and short axis component )
( to them.  We need to know how long these components are. )

variable dS  variable dL  variable -dL

( Pixels can be plotted only at integral intervals.  In )
( between each pixel, we need to accumulate a fraction of )
( how far the line has advanced along the short axis. )

variable accumulator

( When accumulator becomes an improper fraction, we must )
( alter the drawing address and renormalize.  Note that )
( we define this as a macro; this minimizes run-time )
( overhead while retaining a well-factored program. )

: normalize     S" -dL @ accumulator +!" evaluate ; immediate

( When drawing, we should use the color the user wants. )

variable color
: unsafe-color! ( u -- )
  color ! ;

: dot           S" color @ over w!" evaluate ; immediate

( This word determines the starting address for the line's )
( first pixel.  We use 2* because pixels take up two bytes )
( in the bitmap. )

: address       y0 @ pitch * x0 @ 2* + bitmap + ;

( For octant 1, advancing along the long axis involves )
( bumping our drawing address by -pitch, while advancing )
( along the short axis requires adding 2. )

: short+        S" 2 +" evaluate ; immediate
: long+         S" pitch -" evaluate ; immediate
: long          y1 @ y0 @ - abs 1+ dup dL ! negate -dL ! ;
: short         x1 @ x0 @ - abs 1+ dS ! ;
include fbline
: line1         line ;

( For octant 4, we just switch the vertical direction. )

: long+         S" pitch +" evaluate ; immediate
include fbline
    : configured    long short ;
    : error         dS @ accumulator +!
                    accumulator @ dL @ >= if short+ normalize then ;
    : plot          >r dot long+ error r> ;
    : (line)        begin dup dL @ < while plot 1+ repeat ;
    : line          configured address 0 (line) 2drop ;

: line4         line ;

( For octant 2, advancing along the long axis involves )
( bumping our drawing address by 2, while advancing )
( along the short axis requires subtracting 'pitch' bytes. )

: long+         S" 2 +" evaluate ; immediate
: short+        S" pitch -" evaluate ; immediate
: long          x1 @ x0 @ - abs 1+ dup dL ! negate -dL ! ;
: short         y1 @ y0 @ - abs 1+ dS ! ;
include fbline
: line2         line ;

( For octant 3, we just switch the vertical direction. )

: short+        S" pitch +" evaluate ; immediate
include fbline
: line3         line ;

: dx>dy?        x1 @ x0 @ - abs  y1 @ y0 @ - abs > ;
: y1>y0?        y1 @ y0 @ > ;
create linetab
    ' line1 ,   ' line2 ,   ' line4 ,   ' line3 ,
: line0         x0<x1  dx>dy? 1 and  y1>y0? 2 and or cells
                linetab + @ execute ;

\
\ plotted
\

: plotted ( x y -- )
  y0 ! x0 ! color @ address w! ;

