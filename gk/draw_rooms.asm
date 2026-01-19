DrawNonexistentRoom:
	REP #$20
	LDA.w #$0F00
	STA.l $7F0000, X
	STA.l $7F0002, X
	STA.l $7F0040, X
	STA.l $7F0042, X
	JML $8AE7F2

GetVisibilityProps:
	PHX
	ASL A : ASL A
	TAX
	LDA.b $0C
	AND.l .visibility_props, X
	ORA.l .visibility_props+2, X
	STA.b $0C
	PLX
	RTS

.visibility_props:
	dw $0000, $0F00
	dw $C000, $174F
	dw $C000, $174F
	dw $0000, $1400
	dw $0000, $1000
	dw $0000, $0C00
	dw $0000, $0800

; A = room shape
; $0C = visibility props
GetQuadrantTile:
	PHA

	LDA.b $0C
	AND.w #$03FF
	BNE .square

	PLA
	ORA.b $0C
	RTS

.square
	PLA
	LDA.b $0C
	RTS

NormalDrawDungeonMapRoom:
	JSL DrawDungeonMapRoom
	JML $8AE7F2

; $CA has room_id
; $0E has quadrant flags
; X has address to draw at
DrawDungeonMapRoom:
	REP #$20
	PHB : PHK : PLB ; need to keep this in same bank as data, or else specify bank
	LDA.b $0A : PHA

	JSR GetSpecificRoomVisibility

	LDA.b $CA
	AND.w #$00FF
	ASL A : ASL A : ASL A
	TAY

	macro DrawQuadrant(quadrant, writeOffset)
		.draw_quadrant_<quadrant>:
			LDA.w #(3-<quadrant>)<<14
			STA.b $0C

			LDA.b $0E
			BIT.w #1<<(3-<quadrant>)
			BNE ..visited

			LDA.b $0A
			BRA ..continue

		..visited
			LDA.b $0B

		..continue
			AND.w #$00FF
			JSR GetVisibilityProps

			LDA.w SupertileRoomShapes+(2*<quadrant>), Y
			CMP.w #$FFFF : BNE ..get_quadrant
			LDA.b $0A
			AND.w #$00FF
			CMP.w #$0001
			BNE ..empty

		..full_square
			LDA.b $0C
			BRA ..write

		..get_quadrant
			JSR GetQuadrantTile
			BRA ..write

		..empty
			LDA.w #$0F00

		..write
			STA.l $7F0000+<writeOffset>, X
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
	STA.b $72

	SEP #$20
	LDA.l DungeonMapFloorCountData, X
	AND.b #$0F
	CLC : ADC.w DungeonMapCurrentFloor
	REP #$20
	AND.w #$00FF

	STZ.b $02
	PHA
	JSR DrawSingleFloorEntrances

	INC.b $02
	INC.b $02
	PLA
	DEC A
	JSR DrawSingleFloorEntrances

.done
	REP #$20
	PLA : STA.b $06
	PLY : PLX
	SEP #$30
	RTL

DrawSingleFloorEntrances:
	ASL A
	TAX

	LDA.l DungeonMapFloorToDataOffset, X
	TAY
	STZ.b $06

.next_room
	REP #$20
	LDA.b ($72), Y ; get room id
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
	CMP.b #$05
	BCC .next_room

.done
	REP #$20
	RTS

macro DrawSingleEntrance(offset)
	LDY.b $00
	LDA.b #$00
	STA.w OAMBufferAux, Y ; high x-bit and size bit
	TYA
	ASL #2
	TAY

	LDA.b $06
	CPX.b #$02
	BNE ?+
	ASL A
?+
	CLC : ADC.b $06
	ASL #3
	CLC : ADC.b #$90+<offset>
	STA.w OAMBuffer+0, Y

	PHX
	LDA.b $07
	CPX.b #$02
	BNE ?+
	ASL A
?+
	CLC : ADC.b $07
	ASL #3

	LDX.b $02

	CLC : ADC.l DungeonMapRoomMarkerYBase, X
	PLX
	CLC : ADC.b #$08
	CLC : ADC.w $0213
	SEC : SBC.b $E8
	STA.w OAMBuffer+1, Y

	LDA.b #$33
	STA.w OAMBuffer+2, Y

	LDA.b #$23
	STA.w OAMBuffer+3, Y

	INC.b $00
endmacro

DrawSingleRoomEntrances:
	STA.b $0E
	PHY

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
	TYX
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
	PLY
	RTS
