;===============================================================================
SECTION "state_main", rom0
;-------------------------------------------------------------------------------
include "core/hardware.inc"
include "core/memory.inc"

;===============================================================================
STATE_MAIN:: DB $60  ; C0  ==  load + main + no unload  + no interrupts
;-------------------------------------------------------------------------------
    DW .load
    DW .main

;===============================================================================
; Consts
;-------------------------------------------------------------------------------
palettes: DB $E4, $1B


;===============================================================================
.load:
;-------------------------------------------------------------------------------
    di ; Stop all enventually running interrupts
    reset_mem_bit cLCDC, 7 ; Disable screen

    ; Init memory
    set_byte cBGPALETT, [palettes] ; set background Palette
    
    copy_mem asset_gfx_tiles, cTILEDATA0, 6144 ; copy TileSet 
    fill_mem cBGMAP0, $0400, 2 ; fill map 0 (32*32 Byte) with tile $02

    ; Activate VBlank interrupt
    set_byte cINTERRUPTS, INT_VBLANK ; enable LCD and VBlank interrupt 
    
    set_mem_bit cLCDC, 7 ; Enable screen
    ei ; enable interrupts

    ret


;===============================================================================
.main:
;-------------------------------------------------------------------------------
    call buttons_update

    ; check if START was pressed 
    .press_check:
        ldh a, [buttons_pressed] ; load the pressed buttons
        and %10000000            ; filter the start button
        jp z, .release_check ; if not pressed, check for release
            ; else change palette
            set_byte cBGPALETT,  [palettes+1]; set background Palette
            jp .end  ; Skip check for release


    ; else check if START was released
    .release_check:
        ldh a, [buttons_released]   ; load the relase buttons
        and %10000000      ; filter start button
        jp z, .end ; if not releassed, continue loop

            ; else reset palatte
            set_byte cBGPALETT,  [palettes]; set background Palette


    .end:
    ret