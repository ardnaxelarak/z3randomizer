SpiralPropsIndex:
db $00, $04, $07, $00, $01, $00, $00, $0D, $00, $10, $04, $00, $15, $00, $0A, $00
db $00, $07, $00, $00, $00, $01, $07, $1C, $00, $00, $21, $00, $26, $01, $0A, $00
db $00, $00, $00, $00, $00, $00, $29, $30, $01, $00, $00, $00, $00, $00, $00, $00
db $00, $35, $00, $00, $3A, $00, $00, $00, $01, $00, $04, $00, $00, $00, $00, $3D
db $40, $07, $07, $00, $00, $01, $00, $00, $00, $00, $43, $00, $07, $07, $07, $00
db $00, $00, $00, $01, $48, $00, $00, $00, $00, $00, $00, $00, $07, $07, $00, $4B
db $00, $00, $00, $01, $50, $00, $07, $00, $00, $00, $53, $01, $01, $00, $58, $00
;   0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
db $5B, $01, $04, $00, $00, $00, $60, $67, $00, $00, $00, $00, $00, $00, $00, $6E
db $01, $00, $00, $00, $00, $00, $00, $71, $00, $00, $00, $00, $76, $00, $04, $00
db $00, $07, $00, $04, $00, $00, $00, $01, $7D, $0A, $00, $00, $00, $00, $04, $00
db $01, $00, $04, $00, $00, $01, $07, $00, $00, $00, $00, $0A, $00, $00, $07, $00
db $80, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $01, $00, $07, $00
db $85, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
db $8A, $04, $8F, $00, $00, $00, $00, $00, $00, $00, $0A, $00, $00, $00, $00, $00
db $04

SpiralProps:
db $00 ;null row
db $01, $00, $00 ; ($01) Single Top-Left Staircase
db $01, $00, $01 ; ($04) Single Top-Middle Staircase
db $01, $00, $02 ; ($07) Single Top-Right Staircase
db $01, $00, $05 ; ($0A) Single Staircase at Top of Bottom Left Quadrant

db $01, $00, $04 ; ($0D) Moldorm
db $02, $00, $00, $01, $02 ; ($10) Pod Basement
db $03, $00, $00, $01, $01, $02, $02 ; ($15) GT Entrance
db $02, $00, $03, $01, $04 ; ($1C) Hera Below Moldorm
db $03, $00, $01, $01, $02 ; ($21) PoD Bridge
db $01, $00, $08 ; ($26) GT Ice Armos
db $03, $00, $01, $01, $02, $02, $09 ; ($29) Swamp Statue
db $02, $00, $03, $01, $04 ; ($30) Hera Big Chest
db $02, $00, $04, $02, $09 ; ($35) Hera Startiles (middle value unused)
db $01, $00, $08 ; ($3A) West Swamp
db $01, $00, $05 ; ($3D) Ice Hamlift
db $01, $00, $07 ; ($40) Aga Guards
db $02, $00, $00, $01, $02 ; ($43) Pod Entrance
db $01, $00, $08 ; ($48) Swamp Attic
db $03, $03, $05, $04, $06 ; ($4B) Ice U (1st three values unused)
db $01, $00, $05 ; ($50) TT Attic Left
db $02, $00, $01, $01, $02 ; ($53) Pod Rupees
db $01, $00, $04 ; ($58) Ice Gators
db $02, $01, $00, $02, $01 ; ($5B) HC Tiny (first value placeholder)
db $03, $00, $01, $01, $02, $02, $09 ; ($60) Swamp Sunken
db $03, $01, $00, $02, $08, $03, $09 ; ($67) Hera Entrance (first value unused)
db $01, $00, $08 ; ($6E) Ice Hookshot
db $02, $01, $00, $03, $08 ; ($71) Hera Basement (first and third values unused)
db $03, $00, $00, $01, $02, $03, $08 ; ($76) GT Circle (third value unused)
db $01, $00, $07 ; ($7D) Mire Entrance
db $02, $00, $02, $02, $09 ; ($80) Tower Usains (2nd value unused)
db $02, $00, $02, $02, $09 ; ($85) Tower Dark2 (2nd value unused)
db $02, $00, $02, $02, $09 ; ($8A) Tower Dark1 (2nd value unused)
db $01, $00, $09 ; ($8F) Mire2

SpiralLabelOffsets:
db 1, -9
db 5, -9
db 9, -9
db -6, -1
db 15, -1
db 1, 0
db 5, 0
db 9, 0
db -6, 7
db 15, 7
