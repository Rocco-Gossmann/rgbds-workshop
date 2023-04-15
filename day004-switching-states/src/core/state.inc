; State is a series of words (2byte values) that define different adresses of functions in memory

; this is, what a state definition defining all available function looks like
;    state_name:: DB [function map] 
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


; the [function map]  defines, which of the functions this defined, 
;                     what follows, is the list of function adresses
;                     that MUST BE IN THE ORDER ABOVE 
;                     You may, hover skip all functions in the list,
;                     that are not activated according to the [function map]s bitmap

;          bits are :   64 ($40)= set to activate the .load function
;                       32 ($20)= set to activate the .main function
;                       16 ($10)= set to activate the .unload function

;                        8 ($08)= set if state proveides a the .vblank - interrupt function
;                        4 ($04)= set if state proveides a the .timer - interrupt function
;                        2 ($02)= set if state proveides a the .state / .timer - interrupt function
;                        1 ($01)= set if state proveides a the .serial - interrupt function
;                     



; A state providing a .main, .blank and unload function, would lock like thies
;    state_name::  DB %00111000 ; ($38)
;        DW .main
;        DW .unload
;        DW .vblank 
;        
;    .unload: /* Code goes here */ ret;
;    .main: /* Code goes here */ ret;
;    .vblank: /* Code goes here */ ret;



include "memory.inc"
include "utils.inc"

state_fnc_load   equ 0
state_fnc_main   equ 2 
state_fnc_unload equ 4 
state_fnc_vblank equ 6
state_fnc_timer  equ 8 
state_fnc_lcd    equ 10 
state_fnc_serial equ 12 


/*==============================================================================
 ## swtich_state(n16 state_definition_adress)
 changes, what state is currently executed
 ------------------------------------------------------------------------------
 ### Input:
   - state_definition_adress: the adress of the State-Structure, that defines the
                              the adresses of the new functions 
 ### Destroys:
   - BC
 ============================================================================*/
MACRO change_state
    ld bc, \1
    call _load_new_state_from_bc
ENDM

/*==============================================================================
 ## state_call(n8 function_offset)
 changes, what state is currently executed
 ------------------------------------------------------------------------------
 ### Input:
   - function_offset: the offset of the function to call in the state structure

 ### Destroys:
   - AF
   - HL
   - BC
   - DE
 ============================================================================*/
MACRO state_call  
    ld hl, current_state + \1   ; 3 bytes
    call_HL
ENDM

MACRO state_init 
  ld hl, nop_call
  ld a, h
  ldh [current_state.unload], a
  ld a, l
  ldh [current_state.unload+1], a
ENDM