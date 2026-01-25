RedrawLoot:
	JSL DrawLoot

	; what we wrote over
	SEP #$20
	STZ.w $0210
	RTL

FirstDrawLoot:
	LDA.b #$FF
	STA.w $0215
	LDA.b #$80
	STA.w $0216
	STA.w $0218
	LDA.l DRMode
	BEQ +
		LDA.w DungeonID
		ASL A
		TAX
		LDA.l DungeonMapData.floor, X
		STA.b $A4
+

	; what we wrote over
	LDA.b #$08
	STA.b $17

DrawLoot:
	LDA.b $07
	STA.w $021B

	LDA.l DRMode
	BNE .skip

	REP #$30
	PHX : PHY

	STZ.b $0E

	LDX.w DungeonID
	LDA.l DungeonMapRoomPointers, X
	STA.b $72

	SEP #$20
	LDA.l DungeonMapFloorCountData, X
	AND.b #$0F
	CLC : ADC.w DungeonMapCurrentFloor
	PHA

	JSR DrawSingleFloorLoot

	INC.b $0F
	LDA.b #$80
	STA.b $0E
	PLA : DEC A
	JSR DrawSingleFloorLoot

	LDX.w GFXStripes
	LDA.b #$FF
	STA.w GFXStripes+$02, X

	LDA.b #$01
	STA.b NMISTRIPES

	PLY : PLX
.skip
	LDA.b #$00
	RTL

DrawSingleFloorLoot:
	REP #$20
	AND.w #$00FF
	ASL A
	TAX

	LDA.l DungeonMapFloorToDataOffset, X
	CLC : ADC.w #$0018 ; get to end of floor
	TAY

	SEP #$20
	LDA.b #$04
	STA.b $06

	LDA.b #$04
	STA.b $07

.next_row
	REP #$20
	LDA.w GFXStripes
	TAX
	CLC : ADC.w #$0030
	STA.w GFXStripes

	SEP #$20
	LDA.b $07
	CLC : ADC.b $07
	REP #$20
	AND.w #$00FF
	ASL #5

	CLC : ADC.w #$1092
	ADC.b $0E
	XBA
	STA.w GFXStripes+$02, X
	CLC : ADC.w #$2000
	STA.w GFXStripes+$1A, X

	LDA.w #$1300
	STA.w GFXStripes+$04, X
	STA.w GFXStripes+$1C, X

	TXA
	CLC : ADC.w #$0016
	TAX

.next_room
	REP #$20
	LDA.b ($72), Y ; get room id
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
	STA.w GFXStripes+$00, Y
	LDA.l LootTypeIcons+2, X
	STA.w GFXStripes+$02, Y
	LDA.l LootTypeIcons+4, X
	STA.w GFXStripes+$18, Y
	LDA.l LootTypeIcons+6, X
	STA.w GFXStripes+$1A, Y

	TYX
	PLY
	DEY : DEX #4

	SEP #$20
	DEC.b $06
	BPL .next_room

	DEC.b $07
	BMI .done

	LDA.b #$00
	XBA
	LDA.b #$04
	STA.b $06

	JMP .next_row

.done
	RTS
