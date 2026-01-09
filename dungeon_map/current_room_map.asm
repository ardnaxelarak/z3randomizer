!CenterTile = $036A
!ConnectorPalette = $0800

DrawWackyDoorRandoStuff:
	JSL DrawBorder

	LDA.b RoomIndex
	AND.w #$00FF
	STA.l CurrentDisplayedRoom
	STA.b $CA
	LDX.w #!CenterTile
	JSL DrawFullRoomTile

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

print "DrawSide: ", pc
; $00 - Side
; $02 - Door position number on side
; $04 - Target door position
; $06 - Number of doors on side
; $08 - Room Drawn Address
; $0A - Door Index on side
DrawSide:
	STZ.b $06
	LDY.w #$0002

-
	LDA.l DoorTable, X
	AND.w #$00FF
	CMP.w #$0003
	BEQ +
	INC.b $06
+	INX : INX
	DEY
	BPL -

	LDY.b $06
	LDA.w DoorsCurrentRoomOffsets_offsets, Y
	AND.w #$00FF
	STA.b $02

	LDY.b $00
	LDA.w DoorsCurrentRoomOffsets_index, Y
	AND.w #$00FF
	CLC : ADC.b $02
	TAY

	DEX #6
	STZ.b $02
	STZ.b $0A

-
	LDA.l DoorTable, X
	AND.w #$00FF
	CMP.w #$0003
	BEQ +
	JSR DrawSingleConnectedRoom
+
	INX : INX
	INC.b $02
	LDA.b $02
	CMP.w #$0003
	BCC -

	LDA.b $06
	CMP.w #$0002
	BEQ .two
	BCS .three

.other
	RTS

.two
	PHX
	JSR DrawDoubleConnector
	PLX
	RTS

.three
	PHX
	JSR DrawTripleConnector
	PLX
	RTS

DrawSingleConnectedRoom:
	STA.b $CA
	PHX
	LDA.w DoorsCurrentRoomOffsets, Y
	CLC : ADC.w #!CenterTile
	STA.b $08
	TAX
	JSL DrawFullRoomTile
	INY : INY
	PLX

	PHY

	LDA.b $06
	BEQ ++
	CMP.w #$0001
	BEQ .single

	JSR GetWhichDoorPosition
	STA.b $04
	BRA .draw

.single
	LDA.b $02
	ASL A
	CLC : ADC.b $02
	STA.b $04

	JSR GetWhichDoorPosition
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
	INC.b $0A
	RTS

GetWhichDoorPosition:
	LDA.l DoorTable, X
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
	LDX.b $08
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
+	LDY.b $0A
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

DrawEastConnectors:
	LDA.b $06 : DEC A
	BNE +
	%Draw3x2Connector($04, east)
	RTS

+	JSR GetConnectorIndex
	PHX
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
