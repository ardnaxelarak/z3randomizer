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
	STA.w GFXStripes+$02, X

	LDA.b #$01
	STA.b NMISTRIPES

	PLY : PLX
	LDA.b #$00
	RTL

DrawSingleFloorLoot:
	REP #$20
	AND.w #$00FF
	INC A
	ASL A
	CLC : ADC.l DungeonMapMode
	ASL A
	TAX

	LDA.l MapDrawingData_floor_data_offset, X
	DEC A
	TAY

	LDA.l DungeonMapMode
	ASL A
	TAX

	SEP #$20
	LDA.l MapDrawingData_column_count, X
	DEC A
	STA.b $06

	LDA.l MapDrawingData_row_count, X
	DEC A
	STA.b $07

.next_row
	REP #$20
	LDA.w GFXStripes
	TAX
	CLC : ADC.w #$0034
	STA.w GFXStripes

	PHX
	LDA.l DungeonMapMode
	ASL A
	TAX

	SEP #$20
	LDA.b $07
	CPX.w #$0002
	BNE +
	ASL A
+
	CLC : ADC.b $07
	REP #$20
	AND.w #$00FF
	ASL #5

	CLC : ADC.l MapDrawingData_bg1_grid_start, X
	ADC.b $0E
	XBA
	PLX
	STA.w GFXStripes+$02, X
	CLC : ADC.w #$2000
	STA.w GFXStripes+$1C, X

	LDA.w #$1500
	STA.w GFXStripes+$04, X
	STA.w GFXStripes+$1E, X

	TXA
	CLC : ADC.w #$0018
	TAX

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
	STA.w GFXStripes+$00, Y
	LDA.l LootTypeIcons+2, X
	STA.w GFXStripes+$02, Y
	LDA.l LootTypeIcons+4, X
	STA.w GFXStripes+$1A, Y
	LDA.l LootTypeIcons+6, X
	STA.w GFXStripes+$1C, Y

	TYX
	PLY
	DEY : DEX #4

	LDA.l DungeonMapMode
	CMP.w #$0001
	BNE +
	LDA.b $06
	AND.w #$00FF
	BEQ +

	; skip a column if in 4x3 mode and it's not the last column
	LDA.w #$0300
	STA.w GFXStripes+$02, X
	STA.w GFXStripes+$1C, X
	DEX : DEX
+

	SEP #$20
	DEC.b $06
	BPL .next_room

	LDA.l DungeonMapMode
	CMP.b #$01
	BEQ +
	; draw an extra empty tile at the end to make up for width differences between modes
	LDA.b #$03
	STZ.w GFXStripes+$02, X
	STA.w GFXStripes+$03, X
	STZ.w GFXStripes+$1C, X
	STA.w GFXStripes+$1D, X
+

	DEC.b $07
	BMI .done

	LDA.b #$00
	XBA
	LDA.l DungeonMapMode
	ASL A
	TAX
	LDA.l MapDrawingData_column_count, X
	DEC A
	STA.b $06

	JMP .next_row

.done
	RTS
