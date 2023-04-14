;===============================================================================
; Workshop Day 4
;-------------------------------------------------------------------------------
; Introducing states. 
; Right now, we have only one state. That is to say, all our code has to live 
; at specific memory adresses. Lets change that, so we can esyly changes what 
; gets executed on an VBlack Interrupt or the main loop
;
;-------------------------------------------------------------------------------
; Goals
;-------------------------------------------------------------------------------
; Introduce a "State" datastructure
; - a series of memory adresses to different function, that get hooked into
;   different parts of the rom
; - Introduce a memory adress to define what state is active
; - define a subroutine, that can take that state adress and jump to a specific
;   function defined in it
; - hook up functions into main code

;===============================================================================
SECTION "DATA0", rom0
;-------------------------------------------------------------------------------
palettes: 
    DB $E4, $1B

;===============================================================================
SECTION "main", ROM0[$150]
;-------------------------------------------------------------------------------
include "core/hardware.inc"
include "core/memory.inc"
include "core/state.inc"

main::

    change_state STATE_MAIN  

; main-loop
_main_loop_start:

    .main_loop_continue:
        halt ; wait for next vblank
        nop
        jr _main_loop_start