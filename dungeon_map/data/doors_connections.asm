DoorConnectionTiles:
.vertical
	dw $0000, $0000 ; $00
	dw $01C0, $0000 ; $01 left -> left
	dw $01D0, $01D1 ; $02 left -> middle
	dw $81C3, $41C3 ; $03 left -> right
	dw $81D0, $81D1 ; $04 middle -> left
	dw $01C1, $41C1 ; $05 middle -> middle
	dw $C1D1, $C1D0 ; $06 middle -> right
	dw $01C3, $C1C3 ; $07 right -> left
	dw $41D1, $41D0 ; $08 right -> middle
	dw $0000, $01C0 ; $09 right -> right
	dw $41C2, $41C1 ; $0A left-middle -> left-middle
	dw $81D2, $C1D0 ; $0B left-middle -> left-right
	dw $41D3, $81D3 ; $0C left-middle -> middle-right
	dw $01D2, $41D0 ; $0D left-right -> left-middle
	dw $01C0, $01C0 ; $0E left-right -> left-right
	dw $01D0, $41D2 ; $0F left-right -> middle-right
	dw $C1D3, $01D3 ; $10 middle-right -> left-middle
	dw $81D0, $C1D2 ; $11 middle-right -> left-right
	dw $01C1, $01C2 ; $12 middle-right -> middle-right
	dw $41C2, $01C2 ; $13 triple -> triple
.horizontal
	dw $0300, $0300 ; $00
	dw $01C4, $0300 ; $01 top -> top
	dw $C1D5, $C1D4 ; $02 top -> middle
	dw $81C7, $41C7 ; $03 top -> bottom
	dw $81D4, $81D5 ; $04 middle -> top
	dw $01C5, $41C5 ; $05 middle -> middle
	dw $01D5, $01D4 ; $06 middle -> bottom
	dw $C1C7, $01C7 ; $07 bottom -> top
	dw $41D5, $41D4 ; $08 bottom -> middle
	dw $0300, $01C4 ; $09 bottom -> bottom
	dw $41C6, $41C5 ; $0A top-middle -> top-middle
	dw $41D6, $01D4 ; $0B top-middle -> top-bottom
	dw $41D7, $81D7 ; $0C top-middle -> middle-bottom
	dw $01D6, $41D4 ; $0D top-bottom -> top-middle
	dw $01C4, $01C4 ; $0E top-bottom -> top-bottom
	dw $C1D4, $81D6 ; $0F top-bottom -> middle-bottom
	dw $C1D7, $01D7 ; $10 middle-bottom -> top-middle
	dw $81D4, $C1D6 ; $11 middle-bottom -> top-bottom
	dw $01C5, $01C6 ; $12 middle-bottom -> middle-bottom
	dw $41C6, $01C6 ; $13 triple -> triple
