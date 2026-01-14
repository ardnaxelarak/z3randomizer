!CenterTile = $026A
!ConnectorPalette = $1000
!DoorSlotCount = 25

DrawWackyDoorRandoStuff:
	JSL DrawTopAreaBorder
	JSL DrawBottomAreaBorder

	STZ.w GFXStripes

	LDA.l CachedDungeonID
	AND.w #$00FF
	CMP.w DungeonID
	BNE .different_dungeon

	LDA.w EntranceIndex
	STA.l CurrentDoorEntrance

	JSL DetectLinksSection
	INC A
	XBA
	ASL A : ASL A : ASL A : ASL A
	ORA.b RoomIndex
	STA.l CurrentDisplayedRoom
	BRA DrawCurrentSupertile

.different_dungeon
	JSL FindFirstEntrance
	TYA
	STA.l CurrentDoorEntrance

	ASL A
	TAX
	LDA.l EntranceData_room_id, X
	STA.l CurrentDisplayedRoom

	JSL DetectEntranceSection
	INC A
	XBA
	ASL A : ASL A : ASL A : ASL A
	ORA.l CurrentDisplayedRoom
	STA.l CurrentDisplayedRoom

DrawCurrentSupertile:
	LDA.w #$0000
	STA.l DoorSlotCursor

	LDA.l CurrentDisplayedRoom
	STA.b $CA
	LDX.w #!CenterTile
	LDY.w #$0000
	JSL DrawFullRoomTile

	JSL ClearDoorSlotsTable
	LDA.l CurrentDisplayedRoom
	STA.l DoorSlots

	; multiply room id by 24 to get index in doors table
	LDA.l CurrentDisplayedRoom
	AND.w #$00FF
	TAX
	LDA.l DoorOffset, X
	AND.w #$00FF
	STA.l DisplayedRoomDoorIndex
	ASL A
	CLC : ADC.l DisplayedRoomDoorIndex
	ASL A : ASL A : ASL A
	STA.l DisplayedRoomDoorIndex

	JSL DrawConnectedRooms

	SEP #$20
	LDX.w GFXStripes
	LDA.b #$FF
	STA.w GFXStripes+2, X

	LDA.b #$01
	STA.b NMISTRIPES
	REP #$20

	RTL

ClearDoorSlotsTable:
	LDX.w #2*!DoorSlotCount-2
	LDA.w #$FF0F
-	STA.l DoorSlots, X
	DEX : DEX
	BPL -
	RTL

ClearDoorSlotScratch:
	PHX
	LDX.w #$0004
	LDA.w #$FF0F
-	STA.l DoorSlotScratch, X
	DEX : DEX
	BPL -
	PLX
	RTL

DrawFullRoomTile:
	LDA.b $CA
	AND.w #$00FF
	PHX
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	STA.b $0E
	PLX
	PHY
	JSL DrawDungeonMapRoom
	PLY

	LDA.b $CA
	AND.w #$0FFF

	CMP.w #$003F : BEQ .top_right
	CMP.w #$0096 : BEQ .top_right
	CMP.w #$007E : BEQ .top_left
	CMP.w #$001B : BEQ .bottom_right
	BRA +

.top_right
	LDA.w #$01C0|!ConnectorPalette
	STA.l $7F0002, X
	BRA +

.top_left
	LDA.w #$01C0|!ConnectorPalette
	STA.l $7F0000, X
	BRA +

.bottom_right
	LDA.w #$01C0|!ConnectorPalette
	STA.l $7F0042, X

+
	LDA.b $00 : PHA
	LDA.b $02 : PHA
	LDA.b $06 : PHA
	LDA.b $08 : PHA
	LDA.b $0E : PHA
	JSL DrawSingleRoomLoot
	PLA : STA.b $0E
	PLA : STA.b $08
	PLA : STA.b $06
	PLA : STA.b $02
	PLA : STA.b $00

	RTL

DrawSingleRoomLoot:
	PHX : PHY

	TYX

	LDA.w GFXStripes
	TAY
	CLC : ADC.w #$0010
	STA.w GFXStripes

	LDA.l DoorSlotsBG1, X
	XBA
	STA.w GFXStripes+$02, Y
	XBA
	CLC : ADC.w #$0020
	XBA
	STA.w GFXStripes+$0A, Y

	LDA.w #$0300
	STA.w GFXStripes+$04, Y
	STA.w GFXStripes+$0C, Y

	LDA.b $CA
	JSL CheckLoot

	ASL A : ASL A : ASL A

	TAX

	LDA.l LootTypeIcons+0, X
	STA.w GFXStripes+$06, Y
	LDA.l LootTypeIcons+2, X
	STA.w GFXStripes+$08, Y
	LDA.l LootTypeIcons+4, X
	STA.w GFXStripes+$0E, Y
	LDA.l LootTypeIcons+6, X
	STA.w GFXStripes+$10, Y

	PLY : PLX
	RTL

DrawConnectedRooms:
	PHB : PHK : PLB

	LDA.l ShowRooms_default
	AND.w #$00FF
	STA.b $0A

	LDX.w DungeonID
	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowRooms_have_map
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDX.w DungeonID
	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowRooms_have_compass
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDA.l DisplayedRoomDoorIndex
	TAX
	STZ.b $00

.next_side
	JSR DrawSide
	INC.b $00
	LDA.b $00
	CMP.w #$0004
	BCC .next_side

	JSR DrawStairs
	JSR DrawDropOrWarp

	PLB
	RTL

CheckEdgesTable:
	LDA.b $00
	ASL A
	CLC : ADC.b $00
	ADC.b $02
	XBA
	STA.b $0C
	LDA.l CurrentDisplayedRoom
	AND.w #$00FF
	ORA.b $0C
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

CheckInRoomTable:
	LDA.b $00
	ASL A
	CLC : ADC.b $00
	ADC.b $02
	XBA
	STA.b $0C
	LDA.l CurrentDisplayedRoom
	AND.w #$00FF
	ORA.b $0C
	STA.b $0C

	PHX
	LDX.w #$0000
-
	LDA.w InRoomConnectionIndices, X
	BMI .done
	CMP.b $0C
	BEQ .match
	INX #4
	BRA -

.match
	INX #2
	LDA.w InRoomConnectionIndices, X
	TAX
	LDA.l InroomStairsTable, X

.done
	PLX
	RTS

GetConnection:
	LDA.b $02
	STA.b $04
	LDA.l DoorTable, X
.found
	STA.b $08
	AND.w #$00FF
	CMP.w #$0003
	BEQ .not_found

	STA.b $0C
	STA.b $CA
	LDA.b $08
	JSR GetWhichDoorPosition
	PHA
	XBA
	ORA.b $0C
	STA.b $0C

	PLA
	CLC : ADC.b $00 : ADC.b $00 : ADC.b $00
	PHX
	TAX
	LDA.l IncomingDoorMap, X
	AND.w #$00FF
	PLX
	STA.b $CC
	JSR GetDoorSection
	INC A
	ASL A : ASL A : ASL A : ASL A
	XBA
	ORA.b $0C
	STA.b $0C

	JSR CheckCanSeeConnector
	BCC .nope

	LDA.b $0C
	RTS

.not_found
	JSR CheckEdgesTable
	CMP.w #$FFFF
	BNE .found
	JSR CheckInRoomTable
	CMP.w #$FFFF
	BEQ .nope
	PHA
	LDA.w #$0003
	STA.b $04
	PLA
	BRA .found

.nope
	LDA.w #$FF0F
	RTS

CheckCanSeeConnector:
	LDA.b $0A
	CMP.w #$0001
	BCS .yep

	PHX

	LDA.b $0C
	AND.w #$00FF
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	AND.w #$000F
	BEQ .plx_nope

	LDA.l CurrentDisplayedRoom
	AND.w #$00FF
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	AND.w #$000F
	BEQ .plx_nope

	PLX

.yep
	SEC
	RTS

.plx_nope
	PLX
	CLC
	RTS

; $0C - room id
; $0D - room connection position
; $0F - side
GetQuadrantMask:
	LDA.b $0D
	AND.w #$0003
	CMP.w #$0003
	BNE .normal
	LDA.b $0C
	AND.w #$00FF
	CMP.w #$005E : BEQ .bottom_left
	CMP.w #$007E : BEQ .bottom_left
	CMP.w #$000B : BEQ .top_right
	CMP.w #$001B : BEQ .top_right
.bottom_right
	LDA.w #$0001
	RTS
.bottom_left
	LDA.w #$0002
	RTS
.top_right
	LDA.w #$0004
	RTS
.normal
	SEP #$20
	CLC : ADC.b $0F : ADC.b $0F : ADC.b $0F
	REP #$20
	ASL A
	PHX
	TAX
	LDA.l QuadrantMasks, X
	PLX
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
	LDA.l CurrentDisplayedRoom
	STA.b $CA
	LDA.b $00
	ASL A
	CLC : ADC.b $00
	ADC.b $02
	JSR CheckDoorSection
	BCC +

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
	JSR DrawTripleConnectorRoot
	JSR DrawTripleConnector

.done
	PLX
	RTS

DrawStairs:
	PHX
	LDA.l CurrentDisplayedRoom
	AND.w #$00FF
	TAX
	LDA.w SpiralPropsIndex, X
	AND.w #$00FF
	TAY
	LDA.l SpiralOffset, X
	AND.w #$00FF
	ASL A : ASL A
	STA.b $00

	LDA.w SpiralProps, Y
	AND.w #$00FF
	STA.b $06
	BEQ .done

	STZ.b $02
	INY

.next_room
	LDA.w SpiralProps, Y
	AND.w #$00FF
	ASL A : ASL A
	CLC : ADC.b $00
	TAX

	LDA.l CurrentDisplayedRoom
	STA.b $CA
	LDA.b $02
	JSR CheckStairSection
	BCC .skip

	PHY
	LDA.b $02
	CLC : ADC.w #$0015
	ASL A
	TAY

	LDA.l SpiralTable, X
	AND.w #$00FF
	STA.b $CA

	LDA.l SpiralTable, X
	JSR GetIncomingStairSection
	INC A
	ASL A : ASL A : ASL A : ASL A
	XBA
	ORA.b $CA
	STA.b $CA

	JSR GetSpecificRoomVisibility
	BNE +
	LDA.b $0E
	AND.w #$000F
	BNE +
	BRA .ply_skip
+

	TYX
	LDA.b $CA
	STA.l DoorSlots, X

	LDA.w DoorSlotsBG2, Y
	CLC : ADC.w #!CenterTile
	TAX

	LDA.b $02
	ASL A
	CLC : ADC.w #$0DF0
	STA.l $7F0000-$40, X
	INC A
	STA.l $7F0002-$40, X
	JSL DrawFullRoomTile
.ply_skip
	PLY

.skip
	INY : INY
	INC.b $02
	DEC.b $06
	BNE .next_room

.done
	PLX
	RTS

GetCurrentRoomVisibility:
	LDA.l CurrentDisplayedRoom
	STA.b $CA

GetSpecificRoomVisibility:
	PHX
	LDA.l ShowRooms_default
	AND.w #$00FF
	STA.b $0A

	LDX.w DungeonID
	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowRooms_have_map
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDX.w DungeonID
	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowRooms_have_compass
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	LDA.b $CA
	AND.w #$00FF
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	AND.w #$000F
	STA.b $0E
	BEQ +
	LDA.l ShowRooms_visited_tile
	AND.w #$00FF
	CMP.b $0A
	BCC +
	STA.b $0A
+

	PLX
	LDA.b $0A
	RTS

DrawDropOrWarp:
	PHX
	LDA.l CurrentDisplayedRoom
	STA.b $00

	LDX.w #$0000
.check_next_drop
	LDA.l FallTable, X
	CMP.w #$FFFF
	BEQ .no_drop
	CMP.b $00
	BEQ .found_drop
	INX : INX : INX : INX
	BRA .check_next_drop

.no_drop
	LDX.w #$0000
.check_next_warp
	LDA.l WarpTable, X
	CMP.w #$FFFF
	BEQ .done
	CMP.b $00
	BEQ .found_warp
	INX : INX : INX : INX
	BRA .check_next_warp

.found_drop
	LDA.w #$0DE0
	PHA
	LDA.l FallTable+2, X
	BRA .draw_room

.found_warp
	LDA.w #$0DE2
	PHA
	LDA.l WarpTable+2, X

.draw_room
	STA.b $CA

	JSR GetSpecificRoomVisibility
	BNE +
	LDA.b $0E
	AND.w #$000F
	BNE +

	PLA
	BRA .done

+
	PLA
	STA.l $7F0574
	INC A
	STA.l $7F0576

	LDX.w #$0030
	LDA.b $CA
	STA.l DoorSlots, X

	LDA.w DoorSlotsBG2, X
	CLC : ADC.w #!CenterTile
	TXY
	TAX

	JSL DrawFullRoomTile

.done
	PLX
	RTS

DrawSingleConnectedRoom:
	STA.b $CA
	LDA.w DoorSlotsBG2, Y
	CLC : ADC.w #!CenterTile
	STA.b $08
	TAX
	JSL DrawFullRoomTile

	PHY

	TYX
	LDA.l DoorSlots+1, X
	AND.w #$000F
	CMP.w #$0003
	BNE +
	LDA.l DoorSlots, X
	AND.w #$00FF
	CMP.w #$005E : BEQ .left
	CMP.w #$007E : BEQ .left
.right
	LDA.w #$0002
	BRA +
.left
	LDA.w #$0000
+
	STA.b $04

	LDA.b $06
	BEQ ++
	CMP.w #$0001
	BNE .draw

.single
	LDA.b $02
	ASL A
	CLC : ADC.b $02
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
	PLX

	LDA.b $00
	BEQ .north
	DEC A : BEQ .west
	DEC A : BEQ .south

.east
	LDA.l EdgePositions_east, X
	BRA .done

.north
	LDA.l EdgePositions_north, X
	BRA .done

.west
	LDA.l EdgePositions_west, X
	BRA .done

.south
	LDA.l EdgePositions_south, X

.done
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

DrawTripleConnectorRoot:
	LDA.w #$0013
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

DrawTopAreaBorder:
	LDA.w #$0F19
	STA.l $7F00DE
	LDA.w #$4F19
	STA.l $7F00F8
	LDA.w #$8F19
	STA.l $7F041E
	LDA.w #$CF19
	STA.l $7F0438

	LDX.w #$0016
-
	LDA.w #$0F1A
	STA.l $7F00E0, X
	LDA.w #$8F1A
	STA.l $7F0420, X
	DEX : DEX
	BPL -

	LDX.w #$02C0
-
	LDA.w #$0F1B
	STA.l $7F011E, X
	LDA.w #$4F1B
	STA.l $7F0138, X
	TXA
	SEC : SBC.w #$0040
	TAX
	BPL -

	RTL

DrawBottomAreaBorder:
	LDA.w #$0DE4
	STA.l $7F055E
	STA.l $7F0572
	LDA.w #$4DE4
	STA.l $7F0570
	STA.l $7F0578
	LDA.w #$8DE4
	STA.l $7F061E
	STA.l $7F0632
	LDA.w #$CDE4
	STA.l $7F0630
	STA.l $7F0638

	LDX.w #$000E
-
	LDA.w #$0DE5
	STA.l $7F0560, X
	LDA.w #$8DE5
	STA.l $7F0620, X
	DEX : DEX
	BPL -

	LDX.w #$0002
-
	LDA.w #$0DE5
	STA.l $7F0574, X
	LDA.w #$8DE5
	STA.l $7F0634, X
	DEX : DEX
	BPL -

	LDX.w #$0040
-
	LDA.w #$0DE6
	STA.l $7F059E, X
	STA.l $7F05B2, X
	LDA.w #$4DE6
	STA.l $7F05B0, X
	STA.l $7F05B8, X
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
	LDA.b $00
	AND.w #$0001
	TAY
	LDA.w MultiConnectorTiles_increment, Y
	AND.w #$00FF
	STA.b $0C

	LDA.b $00
	ASL A
	TAY
	LDA.w MultiConnectorTiles_start_offset_three, Y
	CLC : ADC.w #!CenterTile
	TAX

	LDY.b $00
	LDA.w MultiConnectorTiles_direction_index, Y
	AND.w #$00FF
	TAY

	LDA.w #$0005
	STA.b $0E
-
	LDA.w MultiConnectorTiles+8, Y
	ORA.w #!ConnectorPalette
	STA.l $7F0000, X
	TXA
	CLC : ADC.b $0C
	TAX
	INY : INY
	DEC.b $0E
	BPL -

	RTS

DrawDoorsMapSprites:
	LDA.l CurrentDisplayedRoom
	CMP.b RoomIndex
	BNE +
	JSR DrawDoorsMapBlinker
+
	JSR DrawDoorsStairs
	JSR DrawDoorsMapCursor
	JSR DrawDoorsEntrances

	REP #$20
	LDX.w DungeonID
	LDA.l DungeonMask, X
	AND.l CompassField
	BEQ +
	LDA.l DungeonMapBossRooms, X
	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	AND.w #$8000
	BNE +
	JSR DrawDoorsMapBossRoom
	JSR DrawDoorsMapBossIcon
+
	SEP #$20
	RTL

DrawDoorsMapBlinker:
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
	CLC : ADC.w #$0044
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

	INC.b $00
	RTS

DrawDoorsMapBossRoom:
	LDX.w DungeonID
	LDA.l DungeonMapBossRooms, X
	CMP.w #$000F
	BNE +
	RTS
+
	STA.b $0E

	LDX.b #!DoorSlotCount*2-2
-
	LDA.l DoorSlots, X
	AND.w #$00FF
	CMP.b $0E
	BEQ .found
	DEX : DEX
	BPL -
	RTS

.found
	SEP #$20
	LDA.b FrameCounter
	AND.b #$10
	BNE .draw
	REP #$20
	RTS

.draw
	LDY.b $00
	LDA.b #$00
	STA.w OAMBufferAux, Y
	TYA
	ASL A : ASL A
	TAY

	REP #$20
	LDA.l DoorSlotsSprites, X
	LDX.w DungeonID
	XBA
	CLC : ADC.l $8AEE6D, X
	DEC A
	XBA
	STA.w OAMBuffer, Y

	LDA.w #$3331
	STA.w OAMBuffer+2, Y

	INC.b $00
	RTS

DrawDoorsMapBossIcon:
	LDX.w DungeonID
	LDA.l DungeonMapBossRooms, X
	CMP.w #$000F
	BNE +
	RTS
+

	SEP #$20
	LDY.b $00
	LDA.b #$02
	STA.w OAMBufferAux, Y
	TYA
	ASL A : ASL A
	TAY

	REP #$20
	LDA.w #$4830
	STA.w OAMBuffer, Y

	LDA.w #$3103
	STA.w OAMBuffer+2, Y

	INC.b $00
	RTS

DrawDoorsMapCursor:
	LDA.l DoorSlotCursor
	ASL A
	TAX
	LDA.l DoorSlotsSprites, X
	STA.b $0E
	LDA.l DoorSlotsSprites+1, X
	STA.b $0F

	LDY.b #$03

.next_object
	LDX.b $00
	LDA.b #$02
	STA.w OAMBufferAux, X
	TXA
	ASL A : ASL A
	TAX

	LDA.b $0E
	CLC : ADC.w $8AEB9A, Y
	STA.w OAMBuffer, X

	LDA.b $0F
	CLC : ADC.w $8AEB9E, Y
	DEC A
	STA.w OAMBuffer+1, X

	STZ.w OAMBuffer+2, X

	LDA.b FrameCounter
	AND.b #$04
	BNE +
	LDA.b #$05
+
	ASL A
	ORA.w $8AEBA2, Y
	STA.w OAMBuffer+3, X

	INC.b $00
	DEY
	BPL .next_object

	RTS

; $00 - direction to move
; $01 - current spot
MoveDoorsMapCursor:
	PHP
	SEP #$30
	LDA.l DoorSlotCursor
	STA.b $01

.move_again
	LDA.b $01
	ASL A : ASL A
	CLC : ADC.b $00
	TAX
	LDA.l NextCursorSlot, X
	BPL .easy
	CMP.b #$FF
	BEQ .no_move
	BIT.b #$40
	BNE .almost_easy

	AND.b #$0F
	TAX
	LDA.l NextCursorSpecial_center_offset, X
	TAX
	DEX
.try_next
	INX
	LDA.l NextCursorSpecial_center, X
	BMI .no_move
	PHX
	ASL A
	TAX
	LDA.l DoorSlots+1, X
	PLX
	CMP.b #$00
	BMI .try_next
	LDA.l NextCursorSpecial_center, X
	STA.b $01
	BRA .write

.almost_easy
	BIT.b #$20
	BNE .from_end

.from_start
	AND.b #$0F
	TAX
	LDA.l NextCursorSpecial_start_direction, X
	STA.b $00
	LDA.l NextCursorSpecial_start_index, X
	BRA .easy

.from_end
	AND.b #$0F
	TAX
	LDA.l NextCursorSpecial_end_direction, X
	STA.b $00
	LDA.l NextCursorSpecial_end_index, X
	BRA .easy

.easy
	STA.b $01

.check
	LDA.b $01
	ASL A
	TAX
	LDA.l DoorSlots+1, X
	BMI .move_again

.write
	LDA.b $01
	STA.l DoorSlotCursor
	LDA.b #$20
	STA.w $012F
	BRA .done

.no_move
	LDA.b #$3C
	STA.w $012E

.done
	PLP
	RTL

DoorsMapSelectCursor:
	PHP
	SEP #$30

	LDA.l DoorSlotCursor
	BEQ .done

	ASL A
	TAX

	REP #$30

	LDA.l DoorSlots, X
	AND.w #$F0FF
	STA.l CurrentDisplayedRoom
	STZ.w GFXStripes
	JSL ClearDoorsMapBG1
	JSL ClearDoorsMapBG2
	JSL DrawCurrentSupertile

	SEP #$30

	LDA.b #$08
	STA.b $17

	LDA.b #$20
	STA.w $012F

.done
	PLP
	RTL

DoorsMapNextEntrance:
	PHP
	REP #$30
	LDA.l CurrentDoorEntrance
	TAY

.check_next
	INY
	CPY.w #$0085
	BCC +
	LDY.w #$0000
+
	TYA
	CMP.l CurrentDoorEntrance
	BEQ .done

	TYX
	LDA.l $82D1EF, X
	AND.w #$00FF
	CMP.w DungeonID

	BNE .check_next

	TYA
	ASL A
	TAX
	LDA.l EntranceData_room_id, X
	STA.b $CA

	JSR GetSpecificRoomVisibility
	BNE .acceptable

	LDA.w #$0001
	STA.b $00

	LDA.l EntranceData_x_coordinate, X
	LSR A
	AND.w #$00FF
	CMP.w #$0080
	BCS +
	LDA.b $00
	ASL A
	STA.b $00
+

	LDA.l EntranceData_y_coordinate, X
	LSR A
	AND.w #$00FF
	CMP.w #$0080
	BCS +
	LDA.b $00
	ASL A
	ASL A
	STA.b $00
+

	LDA.b $00
	AND.b $0E
	BEQ .check_next

.acceptable
	PHX
	JSL DetectEntranceSection
	PLX
	INC A
	ASL A : ASL A : ASL A : ASL A
	XBA
	ORA.l EntranceData_room_id, X
	STA.l CurrentDisplayedRoom

	TYA
	STA.l CurrentDoorEntrance

	STZ.w GFXStripes
	JSL ClearDoorsMapBG1
	JSL ClearDoorsMapBG2
	JSL DrawCurrentSupertile

	SEP #$30

	LDA.b #$08
	STA.b $17

	LDA.b #$20
	STA.w $012F

.done
	PLP
	RTL

FindFirstEntrance:
	PHP
	REP #$30
	LDY.w #$0000

.check_next
	INY
	CPY.w #$0085
	BCC +
	LDY.w #$FFFF
	PLP
	RTL
+

	TYX
	LDA.l $82D1EF, X
	AND.w #$00FF
	CMP.w DungeonID

	BNE .check_next

	TYA
	ASL A
	TAX
	LDA.l EntranceData_room_id, X
	STA.b $CA

	JSR GetSpecificRoomVisibility
	BNE .acceptable

	LDA.w #$0001
	STA.b $00

	LDA.l EntranceData_x_coordinate, X
	LSR A
	AND.w #$00FF
	CMP.w #$0080
	BCS +
	LDA.b $00
	ASL A
	STA.b $00
+

	LDA.l EntranceData_y_coordinate, X
	LSR A
	AND.w #$00FF
	CMP.w #$0080
	BCS +
	LDA.b $00
	ASL A
	ASL A
	STA.b $00
+

	LDA.b $00
	AND.b $0E
	BEQ .check_next

.acceptable
	PLP
	RTL

DoorsMapChangeDungeon:
	PHP
	SEP #$30
	LDA.w DungeonID
	STA.b $00

.next
	LDA.w DungeonID
	ASL A
	TAX

	LDA.b $F6
	BIT.b #$20
	BNE +
	INX
+	LDA.l DungeonMapData.prev, X
	CMP.b $00
	BEQ .done

	STA.w DungeonID
	JSL FindFirstEntrance
	CPY.b #$FF
	BEQ .next

	LDA.b #$04
	STA.w SubModuleInterface
	REP #$20
	LDA.w #$0000

.done
	PLP
	RTL

ClearDoorsMapBG1:
	LDA.w #$000B
	STA.b $00
	LDA.w #$1090
	STA.b $02
	LDA.w GFXStripes
	TAY
	CLC : ADC.w #$0054
	STA.w GFXStripes

.next_row
	LDA.b $02
	XBA
	STA.w GFXStripes+2, Y
	LDA.w #$1640
	STA.w GFXStripes+4, Y
	LDA.w #$0300
	STA.w GFXStripes+6, Y

	LDA.b $02
	CLC : ADC.w #$0020
	STA.b $02
	INY #6
	DEC.b $00
	BPL .next_row

	LDA.w #$D012
	STA.w GFXStripes+2, Y
	LDA.w #$F012
	STA.w GFXStripes+8, Y
	LDA.w #$1640
	STA.w GFXStripes+4, Y
	STA.w GFXStripes+10, Y
	LDA.w #$0300
	STA.w GFXStripes+6, Y
	STA.w GFXStripes+12, Y
	RTL

ClearDoorsMapBG2:
; main area
	LDX.w #$0120
	LDA.w #$000B
	STA.b $00
	STA.b $02
	LDA.w #$0300
.next_main
	STA.l $7F0000, X
	INX : INX
	DEC.b $02
	BPL .next_main

	LDA.w #$000B
	STA.b $02
	TXA
	CLC : ADC.w #$0028
	TAX

	LDA.w #$0300
	DEC.b $00
	BPL .next_main

; stairs area
	LDX.w #$0560
	LDA.w #$0007
	STA.b $02
.next_stairs
	LDA.w #$0DE5
	STA.l $7F0000, X
	LDA.w #$0300
	STA.l $7F0040, X
	STA.l $7F0080, X
	INX : INX
	DEC.b $02
	BPL .next_stairs

; drop area
	LDX.w #$0574
	LDA.w #$0DE5
	STA.l $7F0574
	STA.l $7F0576
	LDA.w #$0300
	STA.l $7F05B4
	STA.l $7F05B6
	STA.l $7F05F4
	STA.l $7F05F6

	RTL

GetRoomEntrance:
	PHX : PHY
	LDY.w #$0076 ; entrance IDs 76 - 82 are dropdowns, handle those later
-
	DEY
	BMI .not_found

	TYX
	LDA.l EntranceData_dungeon_id, X
	AND.w #$00FF
	CMP.w DungeonID
	BNE -

	TYA
	ASL A
	TAX
	LDA.l EntranceData_room_id, X
	CMP.w $CA
	BNE -

	LDA.l EntranceData_x_coordinate, X
	AND.w #$01FF
	CMP.w #$00B9
	BCC .left
	CMP.w #$0149
	BCC .middle

.right
	LDA.w #$0004
	BRA .done

.middle
	LDA.w #$0002
	BRA .done

.left
	LDA.w #$0000
	BRA .done

.not_found
	LDA.w #$FFFF

.done
	PLY : PLX
	RTS

GetRoomDropdown:
	PHX : PHY
	LDY.w #$0083 ; entrance IDs 76 - 82 are dropdowns
-
	DEY
	CPY.w #$0076
	BCC .not_found

	TYX
	LDA.l EntranceData_dungeon_id, X
	AND.w #$00FF
	CMP.w DungeonID
	BNE -

	TYA
	ASL A
	TAX
	LDA.l EntranceData_room_id, X
	CMP.w $CA
	BNE -

	LDA.l EntranceData_x_coordinate, X
	AND.w #$01FF
	CMP.w #$00B9
	BCC .left
	CMP.w #$0149
	BCC .middle

.right
	LDA.w #$0004
	BRA .done

.middle
	LDA.w #$0002
	BRA .done

.left
	LDA.w #$0000
	BRA .done

.not_found
	LDA.w #$FFFF

.done
	PLY : PLX
	RTS

DrawDoorsEntrances:
	REP #$30
	LDX.w #!DoorSlotCount*2

.next_room
	DEX : DEX
	BPL +
	JMP .done
+

	LDA.l DoorSlots, X
	BMI .next_room

	AND.w #$00FF
	STA.b $CA

	JSR GetRoomEntrance
	STA.b $02
	CMP.w #$0000
	BMI .check_dropdown

	JSR GetSpecificRoomVisibility
	BNE .draw_entrance

	PHX
	LDA.b $02
	TAX
	LDA.l EntranceQuadrantMasks, X
	PLX
	AND.b $0E
	BEQ .check_dropdown

.draw_entrance
	SEP #$30
	LDY.b $00
	LDA.b #$00
	STA.w OAMBufferAux, Y
	TYA
	ASL A : ASL A
	TAY

	LDA.l DoorSlotsSprites, X
	CLC : ADC.b $02 : ADC.b $02
	STA.w OAMBuffer, Y

	LDA.l DoorSlotsSprites+1, X
	CLC : ADC.b #$07
	STA.w OAMBuffer+1, Y

	REP #$30
	LDA.w #$2333
	STA.w OAMBuffer+2, Y
	INC.b $00

.check_dropdown
	JSR GetRoomDropdown
	STA.b $02
	CMP.w #$0000
	BMI .next_room

	JSR GetSpecificRoomVisibility
	BNE .draw_dropdown

	PHX
	LDA.b $02
	TAX
	LDA.l DropdownQuadrantMasks, X
	PLX
	AND.b $0E
	BEQ .next_room

.draw_dropdown
	SEP #$30
	LDY.b $00
	LDA.b #$00
	STA.w OAMBufferAux, Y
	TYA
	ASL A : ASL A
	TAY

	LDA.l DoorSlotsSprites, X
	CLC : ADC.b $02 : ADC.b $02
	STA.w OAMBuffer, Y

	LDA.l DoorSlotsSprites+1, X
	STA.w OAMBuffer+1, Y

	REP #$30
	LDA.w #$A333
	STA.w OAMBuffer+2, Y
	INC.b $00

	JMP .next_room

.done
	SEP #$30
	RTS

DrawDoorsStairs:
	LDA.l CurrentDisplayedRoom
	TAX
	LDA.l SpiralPropsIndex, X
	TAX
	LDA.l SpiralProps, X
	BNE +
	JMP .done
+

	STA.b $0C
	STZ.b $0D

	REP #$30
	JSR GetCurrentRoomVisibility
	SEP #$30

.next_sprite
	INX : INX
	LDA.l SpiralProps, X


	PHX
	ASL A
	TAX

	PHX
	LDA.b $0D
	CLC : ADC.b #$15
	ASL A
	TAX
	LDA.l DoorSlots, X
	PLX
	CMP.b #$0F
	BEQ .skip

	REP #$30
	LDA.l CurrentDisplayedRoom
	STA.b $CA
	LDA.b $0D
	AND.w #$00FF
	JSR CheckStairSection
	SEP #$30
	BCC .skip

	LDA.b $0A
	CMP.b #$04
	BCS .draw

	LDA.l SpiralLabelQuadrantMasks, X
	AND.b $0E
	BEQ .skip

.draw
	LDY.b $00
	LDA.b #$00
	STA.w OAMBufferAux, Y
	TYA
	ASL A : ASL A
	TAY

	LDA.l DoorSlotsSprites
	CLC : ADC.l SpiralLabelOffsets, X
	STA.w OAMBuffer, Y

	LDA.l DoorSlotsSprites+1
	CLC : ADC.l SpiralLabelOffsets+1, X
	STA.w OAMBuffer+1, Y

	LDA.b #$39
	CLC : ADC.b $0D
	STA.w OAMBuffer+2, Y

	LDA.b #$33
	STA.w OAMBuffer+3, Y
	INC.b $00

.skip
	PLX
	INC.b $0D
	DEC.b $0C
	BNE .next_sprite

.done
	RTS

DetectLinksSection:
	LDA.b RoomIndex
	ASL A
	TAX
	LDA.l SplitRooms, X
	TAX
	LDA.l SplitRooms, X
	AND.w #$00FF
	STA.b $00
	BNE +
	RTL
+

	LDA.b LinkPosX
	LSR A
	AND.w #$00FF
	INC A
	STA.b $02

	LDA.b LinkPosY
	LSR A
	AND.w #$00FF
	INC A
	STA.b $04

	LDA.b LinkLayer
	AND.w #$00FF
	INC A
	STA.b $06

DetectSection:
	INX
.next_section
	PHX
	LDA.l SplitRooms+1, X
	TAX
.next_area
	LDA.l SplitRooms, X
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .not_this_section

	AND.w $06
	BEQ .not_this_area

	LDA.l SplitRooms+1, X ; x minimum
	AND.w #$00FF
	CMP.b $02
	BCS .not_this_area

	LDA.l SplitRooms+2, X ; x maximum
	AND.w #$00FF
	INC A
	CMP.b $02
	BCC .not_this_area

	LDA.l SplitRooms+3, X ; y minimum
	AND.w #$00FF
	CMP.b $04
	BCS .not_this_area

	LDA.l SplitRooms+4, X ; y maximum
	AND.w #$00FF
	INC A
	CMP.b $04
	BCC .not_this_area

	BRA .found

.not_this_area
	INX #5
	BRA .next_area

.not_this_section
	PLX
	TXA : CLC : ADC.w #$000D : TAX
	DEC.b $00
	BNE .next_section
	BRA .done

.found
	PLX

.done
	LDA.b $00
	RTL

DetectEntranceSection:
	TYA
	ASL A
	TAX
	LDA.l EntranceData_room_id, X

	ASL A
	TAX
	LDA.l SplitRooms, X
	TAX
	LDA.l SplitRooms, X
	AND.w #$00FF
	STA.b $00
	BNE +
	RTL
+

	PHX
	TYA
	ASL A
	TAX
	LDA.l EntranceData_x_coordinate, X
	LSR A
	AND.w #$00FF
	INC A
	STA.b $02

	TYA
	ASL A
	TAX
	LDA.l EntranceData_y_coordinate, X
	LSR A
	AND.w #$00FF
	INC A
	STA.b $04

	TYX
	LDA.l EntranceData_layer, X
	AND.w #$00FF
	INC A
	STA.b $06

	PLX
	JMP DetectSection
