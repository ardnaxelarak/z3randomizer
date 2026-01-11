DoorSlotsSprites:
; center
	dw $68A8
; north
	dw $4090, $40A8, $40C0
	dw $4098, $40B8
; west
	dw $5080, $6880, $8080
	dw $5880, $7880
; south
	dw $9090, $90A8, $90C0
	dw $9098, $90B8
; east
	dw $50D0, $68D0, $80D0
	dw $58D0, $78D0

DoorSlotsBG1:
; center
	dw $11B5
; north
	dw $1112, $1115, $1118
	dw $1113, $1117
; west
	dw $1150, $11B0, $1210
	dw $1170, $15F0
; south
	dw $1252, $1255, $1258
	dw $1253, $1257
; east
	dw $115A, $11BA, $121A
	dw $117A, $11FA

DoorSlotsBG2:
; center
	dw $0000
; north
	dw $FEBA, $FEC0, $FEC6
	dw $FEBC, $FEC4
; west
	dw $FF36, $FFF6, $00B6
	dw $FF76, $0076
; south
	dw $013A, $0140, $0146
	dw $013C, $0144
; east
	dw $FF4A, $000A, $00CA
	dw $FF8A, $008A

DoorSlotSides:
	db $02, $0C, $16, $20

DoorSlotOffsets:
	db $02, $02, $06, $00

; up, left, down, right
NextCursorSlot:
	db $80, $81, $82, $83
; top
	db $FF, $C1, $00, $04
	db $FF, $04, $00, $05
	db $FF, $05, $00, $C3
	db $FF, $01, $00, $02
	db $FF, $02, $00, $03
; left
	db $C0, $FF, $09, $00
	db $09, $FF, $0A, $00
	db $0A, $FF, $C2, $00
	db $06, $FF, $07, $00
	db $07, $FF, $08, $00
; bottom
	db $00, $E1, $FF, $0E
	db $00, $0E, $FF, $0F
	db $00, $0F, $FF, $E3
	db $00, $0B, $FF, $0C
	db $00, $0C, $FF, $0D
; right
	db $E0, $00, $13, $FF
	db $13, $00, $14, $FF
	db $14, $00, $E2, $FF
	db $10, $00, $11, $FF
	db $11, $00, $12, $FF

NextCursorSpecial:
.center
	db $02, $04, $05, $01, $03, $FF
	db $07, $09, $0A, $06, $08, $FF
	db $0C, $0E, $0F, $0B, $0D, $FF
	db $11, $13, $14, $10, $12, $FF
.center_offset
	db $00, $06, $0C, $12
.start_index
	db $01, $06, $0B, $10
.start_direction
	db $03, $02, $03, $02
.end_index
	db $03, $08, $0D, $12
.end_direction
	db $01, $00, $01, $00

SingleEdgeCurrentRoomConnectors:
.north
	dw $01C0, $0300, $01C0, $0300, $01C0, $0300 ; left -> left
	dw $01C1, $41C1, $81D0, $81D1, $01C0, $0300 ; left -> middle
	dw $41D1, $41D0, $01C1, $41C1, $81D0, $81D1 ; left -> right
	dw $01C0, $0300, $01D0, $01D1, $01C1, $41C1 ; middle -> left
	dw $01C1, $41C1, $01C1, $41C1, $01C1, $41C1 ; middle -> middle
	dw $0300, $01C0, $41D1, $41D0, $01C1, $41C1 ; middle -> right
	dw $01D0, $01D1, $01C1, $41C1, $C1D1, $C1D0 ; right -> left
	dw $01C1, $41C1, $C1D1, $C1D0, $0300, $01C0 ; right -> middle
	dw $0300, $01C0, $0300, $01C0, $0300, $01C0 ; right -> right
.west
	dw $01C4, $01C4, $01C4, $0300, $0300, $0300 ; top -> top
	dw $01C5, $81D4, $01C4, $C1C5, $81D5, $0300 ; top -> middle
	dw $41D5, $01C5, $81D4, $41D4, $C1C5, $81D5 ; top -> bottom
	dw $01C4, $C1D4, $01C5, $0300, $C1D5, $C1C5 ; middle -> top
	dw $01C5, $01C5, $01C5, $C1C5, $C1C5, $C1C5 ; middle -> middle
	dw $0300, $41D5, $01C5, $01C4, $41D4, $C1C5 ; middle -> bottom
	dw $C1D4, $01C5, $01D5, $C1D5, $C1C5, $01D4 ; bottom -> top
	dw $01C5, $01D5, $0300, $C1C5, $01D4, $01C4 ; bottom -> middle
	dw $0300, $0300, $0300, $01C4, $01C4, $01C4 ; bottom -> bottom
.south
	dw $01C0, $0300, $01C0, $0300, $01C0, $0300 ; left -> left
	dw $01C0, $0300, $01D0, $01D1, $01C1, $41C1 ; left -> middle
	dw $01D0, $01D1, $01C1, $41C1, $C1D1, $C1D0 ; left -> right
	dw $01C1, $41C1, $81D0, $81D1, $01C0, $0300 ; middle -> left
	dw $01C1, $41C1, $01C1, $41C1, $01C1, $41C1 ; middle -> middle
	dw $01C1, $41C1, $C1D1, $C1D0, $0300, $01C0 ; middle -> right
	dw $41D1, $41D0, $01C1, $41C1, $81D0, $81D1 ; right -> left
	dw $0300, $01C0, $41D1, $41D0, $01C1, $41C1 ; right -> middle
	dw $0300, $01C0, $0300, $01C0, $0300, $01C0 ; right -> right
.east
	dw $01C4, $01C4, $01C4, $0300, $0300, $0300 ; top -> top
	dw $01C4, $C1D4, $01C5, $0300, $C1D5, $81C5 ; top -> middle
	dw $C1D4, $01C5, $01D5, $C1D5, $81C5, $01D4 ; top -> bottom
	dw $01C5, $81D4, $01C4, $81C5, $81D5, $0300 ; middle -> top
	dw $01C5, $01C5, $01C5, $81C5, $81C5, $81C5 ; middle -> middle
	dw $01C5, $01D5, $0300, $81C5, $01D4, $01C4 ; middle -> bottom
	dw $41D5, $01C5, $81D4, $41D4, $81C5, $81D5 ; bottom -> top
	dw $0300, $41D5, $01C5, $01C4, $41D4, $81C5 ; bottom -> middle
	dw $0300, $0300, $0300, $01C4, $01C4, $01C4 ; bottom -> bottom

MultiConnectorMapping:
.two
	db $02, $00
.three
	db $02, $01, $00

MultiConnectorTiles:
.north
..two
	dw $41C7, $81C7, $C1C7, $01C7
..three
	dw $41C7, $01C4, $81F7, $C1F7, $01C4, $01C7
.west
..two
	dw $81C7, $41C7, $C1C7, $01C7
..three
	dw $81C7, $01C0, $41E7, $C1E7, $01C0, $01C7
.south
..two
	dw $C1C7, $01C7, $41C7, $81C7
..three
	dw $C1C7, $01C4, $01F7, $41F7, $01C4, $81C7
.east
..two
	dw $C1C7, $01C7, $81C7, $41C7
..three
	dw $C1C7, $01C0, $01E7, $81E7, $01C0, $41C7
.direction_index
	db $00, $14, $28, $3C
.start_offset
..two
	dw $FF7E, $FFBC, $00BE, $FFC6
..three
	dw $FF7C, $FF7C, $00BC, $FF86
.increment
	db $02, $40

EdgePositions:
.north_south
	db $01, $00 ; HC Basement
	db $02 ; Desert West Wing
	db $00, $01, $02 ; Desert Lobby
	db $00 ; Desert East Wing
	db $01, $02 ; TT
	db $00, $01 ; different TT
.east_west
	db $02 ; TT Attic
	db $02, $02 ; Desert North Hall
	db $00, $02 ; HC Basement
	db $00 ; Desert East Wing
	db $00, $02 ; TT Triple
	db $02 ; TT Big Key Chest

EdgeConnectionIndices:
; North
	dw $0182, $0000
	dw $0082, $0003
	dw $0283, $0006
	dw $0084, $0009
	dw $0184, $000C
	dw $0284, $000F
	dw $0085, $0012
	dw $01DB, $0015
	dw $02DB, $0018
	dw $00DC, $001B
	dw $01DC, $001E

; South
	dw $0772, $0021
	dw $0672, $0024
	dw $0873, $0027
	dw $0674, $002A
	dw $0774, $002D
	dw $0874, $0030
	dw $0675, $0033
	dw $07CB, $0036
	dw $08CB, $0039
	dw $06CC, $003C
	dw $07CC, $003F

; West
	dw $0565, $0042
	dw $0574, $0045
	dw $0575, $0048
	dw $0382, $004B
	dw $0582, $004E
	dw $0385, $0051
	dw $03CC, $0054
	dw $05CC, $0057
	dw $05DC, $005A

; East
	dw $0B64, $005D
	dw $0B73, $0060
	dw $0B74, $0063
	dw $0981, $0066
	dw $0B81, $0069
	dw $0984, $006C
	dw $09CB, $006F
	dw $0BCB, $0072
	dw $0BDB, $0075

	dw $FFFF

InRoomConnectionIndices:
	dw $020B, $0000
	dw $081B, $0002
	dw $023F, $0004
	dw $081F, $0006
	dw $007E, $0008
	dw $065E, $000A
	dw $0296, $000C
	dw $083D, $000E
	dw $FFFF
