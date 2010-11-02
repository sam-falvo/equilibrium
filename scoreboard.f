\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Implements the scoreboard using 7-segment-like font.
\ We actually implement 8 segments, as shown below:
\
\         A
\        ###
\     F#     # B
\      #  G  #
\        ###
\     E#  #  # C
\      #  H# #
\        ###
\         D
\
\ The additional 'H' segment allows us to render a capital
\ R for the word "SCORE" without looking goofy.
\
\ The segment table contains a set of bytes, each bit of
\ which corresponds to a given segment:
\
\       H G F E D C B A
\
\ Fonts start at ASCII code $20 through $39.  Undefined
\ characters appear as spaces.  $22 is undefined because
\ Forth's inability to embed quotation marks in strings
\ conveniently.

variable penX
variable penY

: binary
  2 base ! ;

binary
create segmentTable
    00000000 ( $20   space ) c,
    01101101 ( $21 ! S ) c,
    00000000 ( $22 " illegal ) c,
    00111001 ( $23 # C ) c,
    00111111 ( $24 $ O ) c,
    11110011 ( $25 % R ) c,
    01111001 ( $26 & E ) c,
    00000000 ( $27 ' illegal ) c,
    00000000 ( $28 ( illegal ) c,
    00000000 ( $29 ] illegal ) c,
    00000000 ( $2A * illegal ) c,
    00000000 ( $2B + illegal ) c,
    00000000 ( $2C , illegal ) c,
    00000000 ( $2D - illegal ) c,
    00000000 ( $2E . illegal ) c,
    00000000 ( $2F / illegal ) c,
    00111111 ( $30 0 ) c,
    00000110 ( $31 1 ) c,
    01011011 ( $32 2 ) c,
    01001111 ( $33 3 ) c,
    01100110 ( $34 4 ) c,
    01101101 ( $35 5 ) c,
    01111101 ( $36 6 ) c,
    00000111 ( $37 7 ) c,
    01111111 ( $38 8 ) c,
    01101111 ( $39 9 ) c,
decimal

: *A ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ oy !  penX @ 16 + dx !  penY @ dy !  line
  then 2/ ;

: *B ( s -- s' )
  dup 1 and if
    penX @ 16 + ox !  penY @ oy !  penX @ 16 + dx !  penY @ 16 + dy !  line
  then 2/ ;

: *C ( s -- s' )
  dup 1 and if
    penX @ 16 + ox !  penY @ 16 + oy !  penX @ 16 + dx !  penY @ 32 + dy !  line
  then 2/ ;

: *D ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ 32 + oy !  penX @ 16 + dx !  penY @ 32 + dy !  line
  then 2/ ;

: *E ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ 16 + oy !  penX @ dx !  penY @ 32 + dy !  line
  then 2/ ;

: *F ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ oy !  penX @ dx !  penY @ 16 + dy !  line
  then 2/ ;

: *G ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ 16 + oy !  penX @ 16 + dx !  penY @ 16 + dy !  line
  then 2/ ;

: *H ( s -- s' )
  dup 1 and if
    penX @ ox !  penY @ 16 + oy !  penX @ 16 + dx !  penY @ 32 + dy !  line
  then 2/ ;

: rendered ( c -- )
  $20 - segmentTable + c@ *A *B *C *D *E *F *G *H drop ;

: written ( c -- )
  rendered 20 penX +! ;

: labelled ( caddr u -- )
  begin dup while over c@ written 1 /string repeat 2drop ;

: scoreboard ( fk -- )
  drop  0 penX ! 0 penY !  S" !#$%& 0" labelled
  controls s>d <# 32 hold # # # #> labelled  ;

