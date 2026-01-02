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
+	DEC A     : BNE + : LDA.w #$0F7B : BRA ++
+	DEC A     : BNE + : LDA.w #$0F7B : BRA ++
+	DEC A     : BNE + : LDA.w #$0C00 : BRA ++
+	DEC A     : BNE + : LDA.w #$1000 : BRA ++
+	DEC A     : BNE + : LDA.w #$1400 : BRA ++
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
		LDA.w #$0F7B

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
