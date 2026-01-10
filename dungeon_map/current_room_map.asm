!CenterTile = $036A
!ConnectorPalette = $1000

DrawWackyDoorRandoStuff:
	JSL DrawBorder

	LDA.b RoomIndex
	AND.w #$00FF
	STA.l CurrentDisplayedRoom
	STA.b $CA
	LDX.w #!CenterTile
	JSL DrawFullRoomTile

	JSL ClearDoorSlotsTable

	; multiply room id by 24 to get index in doors table
	LDA.l CurrentDisplayedRoom
	TAX
	LDA.l DoorOffset, X
	AND.w #$00FF
	STA.l DisplayedRoomDoorIndex
	ASL A
	CLC : ADC.l DisplayedRoomDoorIndex
	ASL A : ASL A : ASL A
	STA.l DisplayedRoomDoorIndex

	JSL DrawConnectedRooms
	RTL

ClearDoorSlotsTable:
	LDX.w #$0026
	LDA.w #$FF0F
-	STA.l DoorSlots, X
	DEX : DEX
	BPL -
	RTL

ClearDoorSlotScratch:
	PHX
	LDX.w #$0006
	LDA.w #$FF0F
-	STA.l DoorSlotScratch, X
	DEX : DEX
	BPL -
	PLX
	RTL

DrawFullRoomTile:
	LDA.b $CA
	PHX
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	STA.b $0E
	PLX
	PHY
	JSL DrawDungeonMapRoom
	PLY
	RTL

DrawConnectedRooms:
	PHB : PHK : PLB
	LDA.l DisplayedRoomDoorIndex
	TAX
	STZ.b $00

.next_side
	JSR DrawSide
	INC.b $00
	LDA.b $00
	CMP.w #$0004
	BCC .next_side

	PLB
	RTL

CheckEdgesTable:
	LDA.b $00
	ASL A
	CLC : ADC.b $00
	ADC.b $02
	XBA
	ORA.l CurrentDisplayedRoom
	STA.b $0C

	PHX
	LDX.w #$0000
-
	LDA.w EdgeConnectionIndices, X
	BMI .done
	CMP.b $0C
	BEQ .match
	INX #4
	BRA -

.match
	INX #2
	LDA.w EdgeConnectionIndices, X
	TAX
	LDA.l NorthOpenEdge, X

.done
	PLX
	RTS

GetConnection:
	LDA.l DoorTable, X
.found
	STA.b $08
	AND.w #$00FF
	CMP.w #$0003
	BEQ .not_found

	STA.b $0C
	LDA.b $08
	JSR GetWhichDoorPosition
	XBA
	ORA.b $0C
	RTS

.not_found
	JSR CheckEdgesTable
	CMP.w #$0000
	BPL .found
	LDA.w #$FF0F
	RTS

print "DrawSide: ", pc
; $00 - Side
; $02 - Door position number on side
; $03 - Door index number on side
; $04 - Target door position
; $06 - Number of doors on side
; $08 - Room Drawn Address
DrawSide:
	JSL ClearDoorSlotScratch

	STZ.b $06
	STZ.b $02
	LDY.w #$0002

-
	JSR GetConnection
	BMI +
	INC.b $06
	PHX
	PHA
	LDA.b $02
	ASL A
	TAX
	PLA
	STA.l DoorSlotScratch, X
	PLX
+
	INX : INX
	INC.b $02
	DEY
	BPL -

	PHX

	LDY.b $06
	LDA.w DoorSlotOffsets, Y
	AND.w #$00FF
	STA.b $02

	LDY.b $00
	LDA.w DoorSlotSides, Y
	AND.w #$00FF
	CLC : ADC.b $02
	TAY

	STZ.b $02
-
	LDA.b $02
	AND.w #$00FF
	ASL A
	TAX
	LDA.l DoorSlotScratch, X
	BPL .present
.missing
	LDA.b $06
	CMP.w #$0002
	BNE +
	JSR DrawDoubleConnectorRoot
	BRA +

.present
	TYX
	STA.l DoorSlots, X
	JSR DrawSingleConnectedRoom
	INC.b $03
	INY : INY
+
	INC.b $02
	LDA.b $02
	AND.w #$00FF
	CMP.w #$0003
	BCC -

	LDA.b $06
	CMP.w #$0002
	BEQ .two
	BCS .three
	BRA .done

.two
	JSR DrawDoubleConnector
	BRA .done

.three
	JSR DrawTripleConnector

.done
	PLX
	RTS


DrawSingleConnectedRoom:
	STA.b $0A
	AND.w #$00FF
	STA.b $CA
	LDA.w DoorSlotsBG2, Y
	CLC : ADC.w #!CenterTile
	STA.b $08
	TAX
	JSL DrawFullRoomTile

	PHY
	LDA.b $06
	BEQ ++
	CMP.w #$0001
	BEQ .single

	TYX
	LDA.l DoorSlots+1, X
	AND.w #$00FF
	STA.b $04
	BRA .draw

.single
	LDA.b $02
	ASL A
	CLC : ADC.b $02
	STA.b $04

	TYX
	LDA.l DoorSlots+1, X
	AND.w #$00FF
	CLC : ADC.b $04
	STA.b $04
	ASL A
	CLC : ADC.b $04
	ASL A : ASL A
	TAY

.draw
	LDA.b $00
	BNE + : JSR DrawNorthConnectors : BRA ++ : +
	DEC A : BNE + : JSR DrawWestConnectors : BRA ++ : +
	DEC A : BNE + : JSR DrawSouthConnectors : BRA ++ : +
	DEC A : BNE + : JSR DrawEastConnectors : BRA ++ : +
++

	PLY
.done
	RTS

GetWhichDoorPosition:
	BMI .edge
	AND.w #$0300
	XBA
	RTS

.edge
	AND.w #$0F00
	XBA
	PHX
	PHA

	LDA.b $00
	BIT.w #$0001
	BEQ .north_south

.east_west
	PLX
	LDA.l EdgePositions_east_west, X
	AND.w #$00FF
	PLX
	RTS

.north_south
	PLX
	LDA.l EdgePositions_north_south, X
	AND.w #$00FF
	PLX
	RTS

macro Draw3x2Connector(offset, label)
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+0, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$00
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+2, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$02
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+4, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$04
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+6, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$40
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+8, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$42
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+10, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$44
endmacro

macro Draw2x3Connector(offset, label)
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+0, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$00
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+2, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$02
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+4, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$40
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+6, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$42
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+8, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$80
	LDA.w SingleEdgeCurrentRoomConnectors_<label>+10, Y
	EOR.w #!ConnectorPalette
	STA.l $7F0000+!CenterTile+<offset>+$82
endmacro

macro Draw2TileConnector(offset1, offset2, flip, sublabel)
	LDA.w DoorConnectionTiles_<sublabel>, Y
	BEQ ?+
	ORA.w #!ConnectorPalette
	EOR.w #<flip>
	STA.l $7F0000+<offset1>, X
?+

	LDA.w DoorConnectionTiles_<sublabel>+2, Y
	BEQ ?+
	ORA.w #!ConnectorPalette
	EOR.w #<flip>
	STA.l $7F0000+<offset2>, X
?+
endmacro

GetConnectorIndex:
	LDA.b $03
	AND.w #$00FF
	TAY
	LDA.b $06
	CMP.w #$0002
	BEQ +
	INY : INY
+	LDA.w MultiConnectorMapping, Y
	AND.w #$00FF
	INC A
	CLC : ADC.b $04 : ADC.b $04 : ADC.b $04
	ASL A : ASL A
	TAY
	RTS

DrawDoubleConnectorRoot:
	LDA.b $02
	AND.w #$00FF
	EOR.w #$FFFF
	CLC : ADC.w #$0010
	ASL A : ASL A
	PHY
	TAY
	LDX.w #!CenterTile
	LDA.b $00
	BNE + : %Draw2TileConnector(-$40, -$3E, $0000, vertical) : BRA ++
+	DEC A : BNE + : %Draw2TileConnector(-$02, $3E, $0000, horizontal) : BRA ++
+	DEC A : BNE + : %Draw2TileConnector($80, $82, $8000, vertical) : BRA ++
+	DEC A : BNE + : %Draw2TileConnector($04, $44, $4000, horizontal) : BRA ++
+
++
	PLY
	RTS

DrawEastConnectors:
	LDA.b $06 : DEC A
	BNE +
	%Draw3x2Connector($04, east)
	RTS

+	JSR GetConnectorIndex
	PHX
	LDX.b $08
	%Draw2TileConnector(-$02, $3E, $4000, horizontal)
	PLX
	RTS
	RTS

DrawWestConnectors:
	LDA.b $06 : DEC A
	BNE +
	%Draw3x2Connector(-$06, west)
	RTS

+	JSR GetConnectorIndex
	PHX
	LDX.b $08
	%Draw2TileConnector($04, $44, $0000, horizontal)
	PLX
	RTS
	RTS

DrawNorthConnectors:
	LDA.b $06 : DEC A
	BNE +
	%Draw2x3Connector(-$C0, north)
	RTS

+	JSR GetConnectorIndex
	PHX
	LDX.b $08
	%Draw2TileConnector($80, $82, $0000, vertical)
	PLX
	RTS

DrawSouthConnectors:
	LDA.b $06 : DEC A
	BNE +
	%Draw2x3Connector($80, south)
	RTS

+	JSR GetConnectorIndex
	PHX
	LDX.b $08
	%Draw2TileConnector(-$40, -$3E, $8000, vertical)
	PLX
	RTS

DrawBorder:
	LDA.w #$0F19
	STA.l $7F01DE
	LDA.w #$4F19
	STA.l $7F01F8
	LDA.w #$8F19
	STA.l $7F051E
	LDA.w #$CF19
	STA.l $7F0538

	LDX.w #$0016
-
	LDA.w #$0F1A
	STA.l $7F01E0, X
	LDA.w #$8F1A
	STA.l $7F0520, X
	DEX : DEX
	BPL -

	LDX.w #$02C0
-
	LDA.w #$0F1B
	STA.l $7F021E, X
	LDA.w #$4F1B
	STA.l $7F0238, X
	TXA
	SEC : SBC.w #$0040
	TAX
	BPL -

	RTL

DrawDoubleConnector:
	LDA.b $00
	AND.w #$0001
	TAY
	LDA.w MultiConnectorTiles_increment, Y
	AND.w #$00FF
	STA.b $0C

	LDA.b $00
	ASL A
	TAY
	LDA.w MultiConnectorTiles_start_offset, Y
	CLC : ADC.w #!CenterTile
	TAX

	LDY.b $00
	LDA.w MultiConnectorTiles_direction_index, Y
	AND.w #$00FF
	TAY

	LDA.w #$0003
	STA.b $0E
-
	LDA.w MultiConnectorTiles, Y
	ORA.w #!ConnectorPalette
	STA.l $7F0000, X
	TXA
	CLC : ADC.b $0C
	TAX
	INY : INY
	DEC.b $0E
	BPL -

	RTS

DrawTripleConnector:
	RTS

DrawBlinkerFancyMode:
	LDX.b $00
	STZ.w OAMBufferAux, X
	TXA
	ASL A : ASL A
	TAX

	REP #$20
	LDA.b LinkPosX
	AND.w #$01E0
	ASL A : ASL A : ASL A
	XBA
	CLC : ADC.w #$00A4
	STA.w OAMBuffer, X

	LDA.b LinkPosY
	AND.w #$01E0
	ASL A : ASL A : ASL A
	XBA
	CLC : ADC.w #$0064
	STA.w OAMBuffer+1, X

	SEP #$20
	LDA.b FrameCounter
	AND.b #$0C
	LSR A : LSR A
	TAY

	LDA.w $8AEB50
	STA.w OAMBuffer+2, X

	LDA.w $8AEB58, Y
	STA.w OAMBuffer+3, X
	RTL
