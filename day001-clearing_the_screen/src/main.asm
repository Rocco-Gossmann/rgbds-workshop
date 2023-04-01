SECTION "main", ROM0[$150]

include "core/hardware.inc"
include "core/memory.inc"

main::
    ; Disable screen
    set_mem_bit cLCDC, 7

    ; fill map 0 (32*32 Byte) with zeros
    fill_mem cBGMAP0, $0400, 0

    ; Enable screen
    reset_mem_bit cLCDC, 7

; main-loop
:   halt
    nop
    jr :- 


