DoorConnectionTiles:
.horizontal
	dw $0300, $0300 ; $00
	dw $03DF, $0300 ; $01 top -> top
	dw $03CC, $03CB ; $02 top -> middle
	dw $03CF, $C3CF ; $03 top -> bottom
	dw $43CC, $43CB ; $04 middle -> top
	dw $03CD, $83CD ; $05 middle -> middle
	dw $C3CB, $C3CC ; $06 middle -> bottom
	dw $C3CF, $03CF ; $07 bottom -> top
	dw $83CB, $83CC ; $08 bottom -> middle
	dw $0300, $03DF ; $09 bottom -> bottom
	dw $83CD, $83DD ; $0A top-middle -> top-middle
	dw $C3DC, $C3CC ; $0B top-middle -> top-bottom
	dw $03CE, $C3CE ; $0C top-middle -> middle-bottom
	dw $43DC, $83CC ; $0D top-bottom -> top-middle
	dw $03DF, $03DF ; $0E top-bottom -> top-bottom
	dw $03CC, $03DC ; $0F top-bottom -> middle-bottom
	dw $43CE, $83CE ; $10 middle-bottom -> top-middle
	dw $43CC, $43DC ; $11 middle-bottom -> top-bottom
	dw $03CD, $03DD ; $12 middle-bottom -> middle-bottom
	dw $03DD, $03DD ; $13 triple -> triple

.vertical
	dw $0300, $0300 ; $00
	dw $03CA, $0300 ; $01 left -> left
	dw $83D7, $83DB ; $02 left -> middle
	dw $C3CF, $03CF ; $03 left -> right
	dw $03D7, $03DB ; $04 middle -> left
	dw $03C7, $43C7 ; $05 middle -> middle
	dw $43DB, $43D7 ; $06 middle -> right
	dw $43CF, $83CF ; $07 right -> left
	dw $C3DB, $C3D7 ; $08 right -> middle
	dw $0300, $03CA ; $09 right -> right
	dw $43C8, $43C7 ; $0A left-middle -> left-middle
	dw $43D8, $43D7 ; $0B left-middle -> left-right
	dw $83D9, $43D9 ; $0C left-middle -> middle-right
	dw $C3D8, $C3D7 ; $0D left-right -> left-middle
	dw $03CA, $03CA ; $0E left-right -> left-right
	dw $83D7, $83D8 ; $0F left-right -> middle-right
	dw $03D9, $C3D9 ; $10 middle-right -> left-middle
	dw $03D7, $03D8 ; $11 middle-right -> left-right
	dw $03C7, $03C8 ; $12 middle-right -> middle-right
	dw $43C8, $03C8 ; $13 triple -> triple
