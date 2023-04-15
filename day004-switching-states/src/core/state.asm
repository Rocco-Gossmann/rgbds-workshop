
include "./state.inc"


;===============================================================================
SECTION "statehandler_memory", hram ; highram 
;-------------------------------------------------------------------------------
current_state_function_mask:: DB
current_state:: 
.load:      DW
.main:      DW
.unload:    DW
.vblank:    DW
.timer:     DW
.lcd:       DW
.serial:    DW


;===============================================================================
SECTION "statehandler_code", rom0
;-------------------------------------------------------------------------------

/*==============================================================================
 ## subroutine, that can be used, of a function of a state has node to execute
 ============================================================================*/
nop_call:: ret;

_load_new_state_from_bc::
    push_all

    push bc
    state_call state_fnc_unload
    pop bc

    ld hl, current_state+1

    ld a, [bc] ; get function map
    inc bc
    ldh [current_state_function_mask], a

    ld d, a   ;<-- d now holds the function mask
    rl d      ; prime d for reading the mask

    ld e, 7 ; <-- there are 7 functions in a state
            ;     so the loop needs to run 7 times
   
    .loopstart:

        ld [hl], LOW(nop_call)
        dec hl
        ld [hl], HIGH(nop_call)     ; set default value
        inc hl

        rl d  ; check what should happen with the next function
        jr nc, .loopcontinue 
        ; if state defines function

            ld a, [bc]    ; Copy BC to current_state
            ld [hld], a
            inc bc

            ld a, [bc]      ; Copy BC to current_state
            ld [hli], a
            inc bc

        .loopcontinue:
        inc hl
        inc hl

        dec e
        jr z, .loopend
        jr .loopstart

    .loopend:
    pop_all

    push_all
    state_call state_fnc_load
    pop_all
    ret
