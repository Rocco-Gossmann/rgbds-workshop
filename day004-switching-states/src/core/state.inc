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
   - AF
   - HL
   - BC
   - DE
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
    push af
    ld hl, current_state + \1 
    call _call_current_state_function_from_a
    pop af 
ENDM