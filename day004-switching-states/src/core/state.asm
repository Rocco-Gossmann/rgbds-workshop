; State is a series of words (2byte values) that define different adresses of functions in memory

; this is how you define them.
;    state_name:: 
;        DW .load
;        DW .main
;        DW .unload
;        DW .vblank
;        DW .timer
;        DW .lcd
;        DW .serial
;        
;    .load: /* Code goes here */ ret;
;    .main: /* Code goes here */ ret;
;    .unload: /* Code goes here */ ret;
;    .vblank: /* Code goes here */ reti;
;    .timer: /* Code goes here */ reti;
;    .lcd: /* Code goes here */ reti;
;    .serial: /* Code goes here */ reti;

; If a state does not use/define certain function,you must substitue them with nop_call
;    state_name::
;        DW nop_call ;.load
;        DW .main
;        DW .unload
;        DW nop_call ;.vblank
;        DW nop_call ;.timer
;        DW nop_call ;.lcd
;        DW nop_call ;.serial
;        
;    .unload: /* Code goes here */ ret;
;    .main: /* Code goes here */ ret;


include "./state.inc"


;===============================================================================
SECTION "statehandler_memory", hram ; highram 
;-------------------------------------------------------------------------------
current_state:: DW


;===============================================================================
SECTION "statehandler_code", rom0
;-------------------------------------------------------------------------------

/*==============================================================================
 ## subroutine, that can be used, of a function of a state has node to execute
 ============================================================================*/
nop_call:: ret;

_call_current_state_function_from_a::
    push af
    push hl
        ld a, 
        ld a, [hl 
        ld l, a
        ldh a, [current_state]
        ld h, a

        add hl, bc
        call ._call_HL
    pop hl
    pop af
    ret

._call_HL:
    jp hl
    ret

_load_new_state_from_bc::
    state_call state_fnc_unload
    ret
