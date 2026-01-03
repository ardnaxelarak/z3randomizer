; $CA has room_id
DrawDungeonMapRoom:
	PHB : PHK : PLB ; need to keep this in same bank as data, or else specify bank
	LDA.b $0A : PHA

	LDA.l ShowRooms_default
	AND.w #$00FF
	STA.b $0A

	PHX

	LDX.w DungeonID
	LDA.l MapField
	AND.l DungeonMask, X
	LDA.l ShowRooms_have_map
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDX.w DungeonID
	LDA.l CompassField
	AND.l DungeonMask, X
	LDA.l ShowRooms_have_compass
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDA.b $0E
	AND.w #$000F
	BEQ +
	LDA.l ShowRooms_visited_tile
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDA.b $0A : BNE + : LDA.w #$0F00 : BRA ++
+	DEC A     : BNE + : LDA.w #$174F : BRA ++
+	DEC A     : BNE + : LDA.w #$174F : BRA ++
+	DEC A     : BNE + : LDA.w #$1400 : BRA ++
+	DEC A     : BNE + : LDA.w #$1000 : BRA ++
+	DEC A     : BNE + : LDA.w #$0C00 : BRA ++
+	LDA.w #$0800
++	STA.b $0C

	PLX

	LDA.b $CA
	AND.w #$00FF
	ASL A : ASL A
	TAY

	macro DrawQuadrant(quadrant, writeOffset)
		?DrawQuadrant:
		LDA.w SupertileRoomShapes+<quadrant>, Y
		AND.w #$00FF
		CMP.w #$00FF : BEQ ?.empty
		CLC : ADC.w #$0340
		PHA
		LDA.b $0E
		AND.w #1<<(3-<quadrant>)
		BNE ?.visited 

		?.unvisited
		LDA.b $0A
		CMP.w #$0003
		BCS ?.shape

		?.square
		PLA
		LDA.b $0C
		BRA ?.write

		?.shape
		PLA
		ORA.b $0C
		BRA ?.write

		?.visited
		PLA
		ORA.w #$0800
		BRA ?.write

		?.empty
		LDA.b $0A
		CMP.w #$0001
		BEQ ?.full_square
		LDA.w #$0F00
		BRA ?.write

		?.full_square
		LDA.w #$174F

		?.write
		ORA.w #(3-<quadrant>)<<14
		STA.l $7F0000+<writeOffset>, X
		?.done
	endmacro

	%DrawQuadrant(0, $00)
	%DrawQuadrant(1, $02)
	%DrawQuadrant(2, $40)
	%DrawQuadrant(3, $42)

.done
	PLA : STA.b $0A
	PLB
	RTL

DrawEntrances:
	REP #$30
	PHX : PHY
	LDA.b $06 : PHA

	LDX.w DungeonID
	LDA.l DungeonMapRoomPointers, X
	STA.b $0C

	SEP #$20
	LDA.l DungeonMapFloorCountData, X
	AND.b #$0F
	CLC : ADC.w $020E
	DEC A
	REP #$20
	AND.w #$00FF

	JSR DrawBothFloorsEntrances

.done
	REP #$20
	PLA : STA.b $06
	PLY : PLX
	SEP #$30
	RTL

DrawBothFloorsEntrances:
	ASL A
	TAX

	LDA.l DungeonMapFloorToDataOffset, X
	TAY
	STZ.b $06

.next_room
	REP #$20
	LDA.b ($0C), Y ; get room id
	AND.w #$00FF
	CMP.w #$000F ; $0F = empty room

	BEQ +
	JSR DrawSingleRoomEntrances
+

	INY

	SEP #$20
	INC.b $06
	LDA.b $06
	CMP.b #$05
	BCC .next_room

	STZ.b $06
-	INC.b $07
	LDA.b $07
	CMP.b #$0A
	BCC .next_room

.done
	RTS

macro DrawSingleEntrance(offset)
	LDX.b $00
	STZ.w OAMBufferAux, X ; high x-bit and size bit
	TXA
	ASL #2
	TAX

	LDA.b $06
	ASL #4
	CLC : ADC.b #$90+<offset>
	STA.w OAMBuffer+0, X

	LDA.b $07
	ASL #4
	CMP.b #$50
	BCC ?+
	CLC : ADC.b #$50
?+	CLC : ADC.b #$87
	CLC : ADC.w $0213
	SEC : SBC.b $E8
	STA.w OAMBuffer+1, X

	LDA.b #$33
	STA.w OAMBuffer+2, X

	LDA.b #$23
	STA.w OAMBuffer+3, X

	INC.b $00
endmacro

DrawSingleRoomEntrances:
	STA.b $0E
	SEP #$10

	LDX.b #$FE
.next_entry
	INX : INX
	LDA.l SupertileEntrances, X
	BPL +
	JMP .done
+

	AND.w #$0FFF
	CMP.b $0E
	BNE .next_entry

	SEP #$20
	LDA.l SupertileEntrances+1, X
	PHA : PHA

	BIT.b #$40
	BEQ +
	%DrawSingleEntrance(0)
+

	PLA
	BIT.b #$20
	BEQ +
	%DrawSingleEntrance(4)
+

	PLA
	BIT.b #$10
	BEQ +
	%DrawSingleEntrance(8)
+

.done
	REP #$30
	RTS
