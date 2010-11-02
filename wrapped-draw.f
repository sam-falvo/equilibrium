\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Wraps unsafe-draw functionality so that we don't core-dump
\ when drawing lines with ambiguous or straight-up erroneous
\ coordinates.
\
\ Also provides rectangle drawing functionality.

variable ox     variable oy
variable dx     variable dy

include unsafe-draw

: no            S" if 0 r> drop exit then" evaluate ; immediate
: 0<=ox<W       ox @ 0< no ox @ 767 > no ;
: 0<=oy<H       oy @ 0< no oy @ 767 > no ;
: 0<=dx<W       dx @ 0< no dx @ 767 > no ;
: 0<=dy<H       dy @ 0< no dy @ 767 > no ;
: fits?         0<=ox<W 0<=oy<H 0<=dx<W 0<=dy<H -1 ;

: offleft?      dx @ 0< ;
: offright?     dx @ 767 > ;
: offtop?       dy @ 0< ;
: offbottom?    dy @ 767 > ;
: deltaX        dx @ ox @ - ;
: deltaY        dy @ oy @ - ;
: clip          ox @ x0 ! oy @ y0 ! dx @ x1 ! dy @ y1 ! line0 ;

: left          offleft? if
                    dx @ >r  dy @ >r
                        0 ox @ - deltaY deltaX */ oy @ + dy !
                        0 dx !
                        clip
                        767 ox ! dy @ oy !
                    r> dy !  r> 768 + dx !
                    r> drop
                then ;

: right         offright? if
                    dx @ >r  dy @ >r
                        768 ox @ - deltaY deltaX */ oy @ + dy !
                        767 dx !
                        clip
                        0 ox ! dy @ oy !
                    r> dy !  r> 768 - dx !
                    r> drop
                then ;

: top           offtop? if
                    dx @ >r  dy @ >r
                        0 oy @ - deltaX deltaY */ ox @ + dx !
                        0 dy !
                        clip
                        dx @ ox !  767 oy !
                    r> 768 + dy !  r> dx !
                    r> drop
                then ;

: bottom        offbottom? if
                    dx @ >r  dy @ >r
                        768 oy @ - deltaX deltaY */ ox @ + dx !
                        767 dy !
                        clip
                        dx @ ox !  0 oy !
                    r> 768 - dy !  r> dx !
                    r> drop
                then ;

: cut           left right top bottom bottom ; ( circumvents tail-call optimization )
: line          begin cut fits? until clip ;

variable orgX
variable orgY
variable extX
variable extY

: origin ( x y -- )
  orgY ! orgX ! ;

: extent ( x y -- )
  extY ! extX ! ;

: rectangle ( -- )
  orgX @ ox ! orgY @ oy ! extX @ dx ! orgY @ dy ! line
  orgX @ ox ! extY @ oy ! extX @ dx ! extY @ dy ! line
  orgX @ ox ! orgY @ oy ! orgX @ dx ! extY @ dy ! line
  extX @ ox ! orgY @ oy ! extX @ dx ! extY @ dy ! line ;


