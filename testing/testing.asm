incsrc "all_starting.asm"

org $87A943
    db $80 ; BRA to allow mirroring from light world to dark world

org $B0817F
    db $01 ; flashing disabled

org $B0804B
    db $01 ; quickswap enabled

org $B0821A
    db $01 ; disable music

org $81EA79
    db $6A ; Triforce in sanctuary
