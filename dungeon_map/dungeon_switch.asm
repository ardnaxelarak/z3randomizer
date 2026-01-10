CheckSwitchMap:
	LDA.l DRMode
	BEQ +
	LDA.l DungeonMapMode
	BNE +

	; fancy door map, will figure out later
	LDA.w #$0002 ; ignore input! nothing to see here!
	RTL

+
	SEP #$20
	LDA.b $F6
	AND.b #$30
	BNE +

	; what we wrote over
	REP #$20
	LDA.w DungeonMapFloorCountData, X
	AND.w #$000F
	CLC : ADC.b $00
	RTL

+	PHA
	TXA
	ASL A
	TAX
	PLA
	BIT.b #$20
	BNE +
	INX
+	LDA.l DungeonMapData.prev, X
	STA.w DungeonID

	LDA.b #$04
	STA.w SubModuleInterface
	REP #$20
	LDA.w #$0000
	RTL

DungeonMapSwitch_Submodule:
	JSL $80893D
	JSL $80833F

	LDA.b #$09
	STA.b $14
	STA.w $0710

	LDA.b #$01
	STA.w SubModuleInterface
	STA.w $020D
	STZ.w $0213
	STZ.w $021B
	STZ.w $021C
	STZ.b $06
	STZ.b $07

	LDA.w DungeonID
	CMP.l CachedDungeonID
	BEQ .current_dungeon

	ASL A
	TAX
	LDA.l DungeonMapData.floor, X
	STA.b CurrentFloor
	BRA .continue

.current_dungeon
	LDA.l CachedCurrentFloor
	STA.b CurrentFloor

.continue
	REP #$20
	STZ.b $E0
	STZ.b $E2
	STZ.b $E4
	STZ.b $E6
	STZ.b $E8
	STZ.b $EA
	JML $98BCA1

SkipMapSprites:
	STZ.b $00

	LDA.b $02 : PHA
	LDA.b $03 : PHA
	LDA.b $04 : PHA

	LDA.l DRMode
	BNE +
	LDA.w SubModuleInterface
	CMP.b #$04
	BEQ +
	JSL DrawEntrances
+

	PLA : STA.b $04
	PLA : STA.b $03
	PLA : STA.b $02

	STZ.b $0E
	STZ.b $0F

	LDA.w SubModuleInterface
	CMP.b #$04
	BNE +
		JML $8AEAFC
+

	LDA.l DRMode
	BEQ +
	LDA.l DungeonMapMode
	BEQ .no_vanilla_draw
		JML $8AEADE
	.no_vanilla_draw
		JSL DrawBlinkerFancyMode
		JML $8AEAFC
+

	LDA.l CachedDungeonID
	CMP.w DungeonID
	BEQ +
		JML $8AEAF3
+	JML $8AEADE

CacheCurrentDungeon:
	STA.l $7EC206
	SEP #$20
	LDA.w DungeonID
	STA.l CachedDungeonID
	LDA.b CurrentFloor
	STA.l CachedCurrentFloor
	REP #$20
	RTL

RestoreCurrentDungeon:
	LDA.b #$F3
	STA.w $012C ; what we wrote over
	LDA.l CachedDungeonID
	STA.w DungeonID
	LDA.l CachedCurrentFloor
	STA.b CurrentFloor
	RTL

RestoreDungeonMapFloorIndex:
	STZ.w $020F ; first part we wrote over

	LDA.w $021B
	STA.b $07
	STZ.b $06

	LDA.b $0A ; the rest of what we wrote over
	AND.b #$08
	RTL

DrawDungeonLabel:
	LDY.b #$00
	LDA.w DungeonID
	ASL A
	TAX
	LDA.b NMISTRIPES
	BEQ +
	LDY.b #$20
+

	REP #$20
	LDA.w #$E660
	STA.w GFXStripes+$02, Y
	LDA.w #$0300
	STA.w GFXStripes+$04, Y

	LDA.l DungeonLabels+0, X
	STA.w GFXStripes+$06, Y
	LDA.l DungeonLabels+2, X
	STA.w GFXStripes+$08, Y
	SEP #$20
	LDA.b #$FF
	STA.w GFXStripes+$0A, Y
	LDA.b #$01
	STA.b NMISTRIPES

	INC.w $020D ; what we wrote over
	RTL

StartCurrentRoomSearch:
	LDA.w DungeonMapFloorCountData, X
	LSR A : LSR A : LSR A : LSR A
	STA.b $00
	LDA.w DungeonMapFloorCountData, X
	AND.b #$0F
	CLC : ADC.b $00
	ASL A
	TAY
	RTL

FindCurrentRoom:
	PHX
	TYA
	%ADD_MapMode()
	LDA.l MapDrawingData_floor_data_offset, X
	STA.b $0C
	LDY.w #$0000

	%LDX_MapMode()

	SEP #$20

.next_room_check
	CPY.b $0C
	BCS .not_found

	LDA.b [$72], Y
	INY
	CMP.b $0E
	BEQ .found

	LDA.b $00
	CMP.l MapDrawingData_floor_pixel_column_wrap, X
	BCS .next_row
	CLC : ADC.l MapDrawingData_supertile_pixel_spacing, X
	STA.b $00
	BRA .next_room_check

.next_row
	STZ.b $00

	LDA.b $02
	CMP.l MapDrawingData_floor_pixel_row_wrap, X
	BCS .next_floor
	CLC : ADC.l MapDrawingData_supertile_pixel_spacing, X
	STA.b $02
	BRA .next_room_check

.next_floor
	STZ.b $02
	BRA .next_room_check

.found
	PLX
	JML $8AE891

.not_found
	PLX
	JML $8AE8CD
