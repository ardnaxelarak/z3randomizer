incsrc "all_starting.asm"

org $87A943
    BRA *  ; can mirror from light world to dark world

org $B0817F
    db $01 ; fashing disabled

org $B0804B
    db $01 ; quickswap enabled

org $B0821A
    db $01 ; disable music

org $01EA79
    db $6A ; Triforce in sanctuary
