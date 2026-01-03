RedrawLoot:
	JSL DrawLoot

	; what we wrote over
	SEP #$20
	STZ.w $0210
	RTL

FirstDrawLoot:
	; what we wrote over
	LDA.b #$08
	STA.b $17

DrawLoot:
	LDA.b $07
	STA.w $021B

	REP #$30
	PHX : PHY

	STZ.b $0E

	LDX.w DungeonID
	LDA.l DungeonMapRoomPointers, X
	STA.b $0C

	SEP #$20
	LDA.l DungeonMapFloorCountData, X
	AND.b #$0F
	CLC : ADC.w $020E
	PHA

	JSR DrawSingleFloorLoot

	INC.b $0F
	LDA.b #$80
	STA.b $0E
	PLA : DEC A
	JSR DrawSingleFloorLoot

	LDX.w GFXStripes
	LDA.b #$FF
	STA.w GFXStripes+2, X

	LDA.b #$01
	STA.b NMISTRIPES

	PLY : PLX
	LDA.b #$00
	RTL

DrawSingleFloorLoot:
	REP #$20
	AND.w #$00FF
	ASL A
	TAX

	LDA.l DungeonMapFloorToDataOffset, X
	TAY
	STZ.b $06

.next_row
	REP #$20
	LDA.w GFXStripes
	TAX
	CLC : ADC.w #$0030
	STA.w GFXStripes

	LDA.b $07
	AND.w #$00FF
	XBA
	LSR A : LSR A
	CLC : ADC.w #$1092
	ADC.b $0E
	XBA
	STA.w GFXStripes+2, X
	CLC : ADC.w #$2000
	STA.w GFXStripes+$1A, X

	LDA.w #$1300
	STA.w GFXStripes+$04, X
	STA.w GFXStripes+$1C, X

.next_room
	REP #$20
	LDA.b ($0C), Y ; get room id
	PHY

	AND.w #$00FF
	CMP.w #$000F ; $0F = empty room

	BNE .valid_room
	LDA.w #$0000
	BRA +
.valid_room
	JSL CheckLoot
+
	ASL A : ASL A : ASL A

	TXY
	TAX

	LDA.l LootTypeIcons+0, X
	STA.w GFXStripes+$06, Y
	LDA.l LootTypeIcons+2, X
	STA.w GFXStripes+$08, Y
	LDA.l LootTypeIcons+4, X
	STA.w GFXStripes+$1E, Y
	LDA.l LootTypeIcons+6, X
	STA.w GFXStripes+$20, Y

	TYX
	PLY
	INY : INX #4

	SEP #$20
	INC.b $06
	LDA.b $06
	CMP.b #$05
	BCC .next_room

	STZ.b $06
	INC.b $07
	LDA.b $07
	CMP.b #$05
	BCS .done
	JMP .next_row

.done
	RTS
