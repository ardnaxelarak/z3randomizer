DoorsCurrentRoomOffsets:
.north
..3
	dw $FEBA, $FEC0, $FEC6
..2
	dw $FEBC, $FEC4
..1
	dw $FEC0
.west
..3
	dw $FF36, $FFF6, $00B6
..2
	dw $FF76, $0076
..1
	dw $FFF6
.south
..3
	dw $013A, $0140, $0146
..2
	dw $013C, $0144
..1
	dw $0140
.east
..3
	dw $FF4A, $000A, $00CA
..2
	dw $FF8A, $008A
..1
	dw $000A
.index
	db $00, $0C, $18, $24
.offsets
	db $00, $0A, $06, $00

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
	dw $41CF, $81CF, $C1CF, $01CF
..three
	dw $41CF, $01C4, $81EF, $C1EF, $01C4, $01CF
.west
..two
	dw $81CF, $41CF, $C1CF, $01CF
..three
	dw $81CF, $01C0, $41DF, $C1DF, $01C0, $01CF
.south
..two
	dw $C1CF, $01CF, $41CF, $81CF
..three
	dw $C1CF, $01C4, $01EF, $41EF, $01C4, $81CF
.east
..two
	dw $C1CF, $01CF, $81CF, $41CF
..three
	dw $C1CF, $01C0, $01DF, $81DF, $01C0, $41CF
.direction_index
	db $00, $14, $28, $3C
.start_offset
..two
	dw $FF7E, $FFBC, $00BE, $FFC6
..three
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
	db $02, $00 ; HC Basement
	db $00 ; Desert East Wing
	db $00, $02 ; TT Triple
	db $02 ; TT Big Key Chest
