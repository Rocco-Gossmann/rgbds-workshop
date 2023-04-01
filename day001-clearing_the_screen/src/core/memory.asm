SECTION "core.memory", ROM0

include "./utils.inc"

_fill_BC_bytes_at_HL_with_A::
    push hl
    push bc
    push af

:   check_BC_zero
    jp z, :+
        pop af
        push af

        ld [hli], a
        dec bc
    jp :-
    
:   pop af
    pop bc
    pop hl
    ret