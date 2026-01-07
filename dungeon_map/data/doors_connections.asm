DoorConnectionTiles:
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
	dw $81D2, $81D0 ; $0B left-middle -> left-right
	dw $41D3, $81D3 ; $0C left-middle -> middle-right
	dw $01D2, $01D0 ; $0D left-right -> left-middle
	dw $01C0, $01C0 ; $0E left-right -> left-right
	dw $01D0, $41D2 ; $0F left-right -> middle-right
	dw $C1D3, $01D3 ; $10 middle-right -> left-middle
	dw $81D0, $C1D2 ; $11 middle-right -> left-right
	dw $01C1, $01C2 ; $12 middle-right -> middle-right
	dw $41C2, $01C2 ; $13 triple -> triple
