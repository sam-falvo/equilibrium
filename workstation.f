\ vim:ai:et:ts=4 sw=4 tw=64
\ *************************************************************
\ Workstation Facade.  Services include:
\ * abstracting framebuffer access.
\ * abstracting user input management.
\ This file is necessarily Forth, hardware, and/or OS dependent.
\
\ As presented, this code should work with a 32-bit Linux
\ installation (or, if on 64-bit installation, a 32-bit libSDL).
\
\ Written for SwiftForth for Linux.


\
\ Low-Level Framebuffer Access
\

library libSDL-1.2.so.0
    function: SDL_Init ( flags -- hasFailed )
    function: SDL_Quit ( -- )
    function: SDL_SetVideoMode ( wdth hght dpth flgs -- scrn )
    function: SDL_Flip ( screen -- )
    function: SDL_WaitEvent ( pEvent -- n )
    function: SDL_PollEvent ( pEvent -- n )
    function: SDL_Delay ( uMillies -- )
    function: SDL_GetError ( -- psz )

library libc.so.6
    function: strlen ( psz -- n )

( SDL-related constants )
32 constant SDL_INIT_VIDEO

( Desired bitmap characteristics for the game )
768 constant px/row
768 constant px/column
 16 constant bits/px
  0 constant flags_vm

( We need to hold onto a screen reference for as long as the )
( framebuffer exists. )
variable screen

( Library initialization and access )
: sdl           SDL_INIT_VIDEO SDL_Init
                abort" Unable to initialize SDL" ;
: surface       px/row px/column bits/px flags_vm SDL_SetVideoMode
                dup screen !  0= abort" Cannot open framebuffer." ;
: presented     sdl surface ;
: hidden        SDL_Quit ;

( Queries for framebuffer characteristics )
: bitmap    screen @ 20 + @ ;
: /row      screen @ 8 + @ ;    ( bytes per row we can see )
: pitch     screen @ 16 + @ ;   ( bytes per row for computer )


\
\ Low-Level UI Access
\

20 constant /SDL_Event
create event    /SDL_Event allot

: type ( -- n )
  event c@ ;

: keysym ( -- n )
  event 8 + @ ;

char a constant SDLK_a
char s constant SDLK_s
char d constant SDLK_d
char w constant SDLK_w

2 constant SDL_KEYDOWN
3 constant SDL_KEYUP

: w ( n -- n' )
  keysym SDLK_w = if 1 or then ;

: a ( n -- n' )
  keysym SDLK_a = if 2 or then ;

: s ( n -- n' )
  keysym SDLK_s = if 4 or then ;

: d ( n -- n' )
  keysym SDLK_d = if 8 or then ;

: keyd ( n -- n' )
  type SDL_KEYDOWN = if w a s d then ;

: w ( n -- n' )
  keysym SDLK_w = if -2 and then ;

: a ( n -- n' )
  keysym SDLK_a = if -3 and then ;

: s ( n -- n' )
  keysym SDLK_s = if -5 and then ;

: d ( n -- n' )
  keysym SDLK_d = if -9 and then ;

: keyu ( n -- n' )
  type SDL_KEYUP = if w a s d then ;

variable &controls
: updated ( -- )
  &controls @ keyd keyu &controls ! ;

: controls ( -- c )
  &controls @ ;

: uhoh ( -- )
  ." workstation.f: SDL says " SDL_GetError dup strlen type
  cr quit ;

\ My version of SDL does not support SDL_WaitEventTimeout, which
\ would have made this entire procedure virtually obsolete.  DOH!

: notified ( -- )
  begin event SDL_PollEvent 0= if exit then updated again ;

: synced ( uMillies -- )
  notified SDL_Delay ;

