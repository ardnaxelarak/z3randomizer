; A = room_id
; out A = level of loot
CheckMapLoot:
	PHP
	REP #$30
	PHX

	STA.b $CA

	LDA.b $0E : PHA

	LDA.l MapItems_default
	AND.w #$00FF
	STA.b $0E

	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX

	LDA.l SaveDataWRAM, X
	AND.w #$000F
	BEQ +
	LDA.l MapItems_visited_tile
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E

+	LDA.w DungeonID
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .skip_dungeon_checks

	TAX

	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
	LDA.l MapItems_have_map
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E

+	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
	LDA.l MapItems_have_compass
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E
+

.skip_dungeon_checks
	JMP GetLootLevelAndCleanUp

; A = room_id
; out A = level of loot
CheckHudLoot:
	PHP
	REP #$30
	PHX

	STA.b $CA

	LDA.b $0E : PHA

+	LDA.w DungeonID
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .cave

	TAX

	LDA.l HudItems_default_dungeon
	AND.w #$00FF
	STA.b $0E

	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
	LDA.l HudItems_have_map
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E

+	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
	LDA.l HudItems_have_compass
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E
+

	BRA GetLootLevelAndCleanUp

.cave
	LDA.l HudItems_cave
	AND.w #$00FF
	STA.b $0E
	; intentional fall-through

GetLootLevelAndCleanUp:
	STZ.b $02

	LDA.b $0E
	AND.w #$00FF
	BEQ +
		JSL GetLootLevel
+

	PLA : STA.b $0E
	PLX
	PLP

	LDA.b $02
RTL

; $CA = room_id
; $0E = level of details to return
;       (1 - presence, 2 - compass or presence, 3 - value)
; out $02 = level of loot
GetLootLevel:
	PHP
	REP #$30
	PHB : PHX : PHY
	LDA.b $06 : PHA

	STZ.b $02 ; best item class found

	LDA.l ItemSources : BIT.w #$0001 : BEQ +
	JSR CheckChests
+

	LDA.l ItemSources : BIT.w #$0002 : BEQ +
	JSR CheckPots
+

	LDA.l ItemSources : BIT.w #$0004 : BEQ +
	JSR CheckEnemies
+

	LDA.l ItemSources : BIT.w #$0008 : BEQ +
	JSR CheckMisc
	JSR CheckMisc2
+

	LDA.l ItemSources : BIT.w #$0010 : BEQ +
	JSR CheckPrize
+

JSR CheckNpcs

.done
	PLA : STA.b $06
	PLY : PLX : PLB
	PLP
	RTL

CheckChests:
	LDA.b $CA
	AND.w #$01FF
	STA.b $00
	ASL A
	TAX

	LDA.w #($81<<8)
	PHA
	PLB : PLB

	LDA.w #$0008
	STA.b $04
	STZ.b $06

	LDY.w #$FFFD
.increment_mask
	LDA.b $04
	ASL A
	STA.b $04
.next_chest
	INY #3
	CPY.w #$01F8
	BCS .done

	LDA.w RoomData_ChestItems, Y
	AND.w #$7FFF
	CMP.b $00
	BNE .next_chest

	LDA.b $06
	JSR CheckChestSection
	INC.b $06
	BCC .increment_mask

	LDA.l SaveDataWRAM, X
	AND.b $04
	BNE .increment_mask ; already got item

	LDA.w RoomData_ChestItems+2, Y
	AND.w #$00FF
	JSR GetLootClass
	BRA .increment_mask

.done
	RTS

CheckMisc:
	; this includes bosses, bonk torches, and standing items (in caves + hera cage key)
	; all dungeon items in this section are in section 1 of split sections
	; for cave items we'll always know what section we're in
	; but for dungeon items, we won't have a section specified in door rando
	; so if we don't have a section, assume it's 1, and it'll match all the dungeon items anyway
	LDA.b $CA
	BIT.w #$F000
	BNE +
	ORA.w #$1000
+
	AND.w #$F1FF
	STA.b $04

	LDX.w #$FFFA
.next_misc
	INX #6
	LDA.l MiscLocations, X
	BPL .check
	RTS

.check
	CMP.b $04
	BNE .next_misc

	TXY
	AND.w #$01FF
	CMP.b RoomIndex
	BEQ .current_room

	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	BRA .continue

.current_room
	LDA.w RoomItemsTaken ; if checking our current room, $0403 has fresher flags
	ASL #4

.continue
	STA.b $04

	TYX
	LDA.l MiscLocations+2, X ; get bit of room data to check
	AND.w #$00FF
	ASL A
	TAX
	LDA.l DungeonMask, X

	TYX
	BIT.b $04
	BNE .next_misc ; continue checking if we already got the item

	LDA.l MiscLocations+4, X
	STA.b $05

	LDA.l MiscLocations+3, X
	STA.b $04

	LDA.b [$04]
	AND.w #$00FF
	JSR GetLootClass

	BRA .next_misc

CheckMisc2:
	; this currently only includes the library and Uncle
	; so let's just hard-code them for now
	LDA.b $CA
	CMP.w #$2107 : BNE +
	LDA.l NpcFlags : AND.w #$0080 : BNE +
	LDA.l LibraryItem : AND.w #$00FF : JSR GetLootClass
+

	LDA.b $CA
	CMP.w #$1055 : BNE +
	LDA.l ProgressFlags : AND.w #$0001 : BNE +
	LDA.l UncleItem : AND.w #$00FF : JSR GetLootClass
+

	RTS

CheckPrize:
	LDA.b $CA
	AND.w #$01FF
	STA.b $04

	LDX.w #$FFFD
.next_prize
	INX #3
	LDA.l PrizeLocations, X
	BPL .check
	RTS

.check
	CMP.b $04
	BNE .next_prize

	TXY

	ASL A
	TAX
	LDA.l SaveDataWRAM, X
	TYX
	BIT.w #$0800
	BNE .next_prize

	LDA.l PrizeLocations+2, X ; get which prize to look at
	AND.w #$00FF
	TAX
	LDA.l DungeonPrizeReceiptID, X
	TYX

	AND.w #$00FF
	JSR GetLootClass

	BRA .next_prize

CheckNpcs:
	LDA.b $CA

	LDX.w #$FFFA
.next_npc
	INX #6
	LDA.l NpcItems, X
	BMI .nope

	CMP.b $CA
	BNE .next_npc

	LDA.l NpcItems+3, X ; get location of data to check
	STA.b $05

	LDA.l NpcItems+2, X
	STA.b $04

	LDA.b [$04]
	AND.w #$00FF
	AND.l NpcItems+5, X
	BNE .next_npc

.yep
	LDA.w NpcItemIndicator
	ORA.w #$0001
	STA.w NpcItemIndicator
	RTS

.nope
	LDA.w NpcItemIndicator
	AND.w #$FF00
	STA.w NpcItemIndicator
	RTS

CheckPots:
	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX

	LDA.l UWPotsPointers, X
	STA.b $04
	LDA.w #bank(UWPotsData)
	STA.b $06

	LDY.w #$0000
	LDX.w #$FFFF
.next_pot
	LDA.b [$04], Y
	CMP.w #$FFFF : BEQ .done
	INX : INY : INY
	BIT.w #$4000 : BNE .multi_item ; marked as multi item
	BIT.w #$8000 : BNE .major_item ; marked as major item
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$0008 : BEQ .small_key
	LDA.l PotCountMode
	BEQ +
		JSR CheckJunkPot
	+
	INY
	BRA .next_pot

.small_key
	LDA.w #$8000 : STA.b $08
	LDA.w #$0024
	PHA
	PHX
	INY
	BRA .mask_set

.multi_item
	LDA.b [$04], Y
	PHX
	AND.w #$00FF
	ASL A
	TAX
	LDA.l PotMultiWorldTable, X
	PLX
	BRA .item_id_set

.major_item
	LDA.b [$04], Y
.item_id_set
	PHA
	PHX
	INY
	TXA : ASL A
	TAX
	LDA.l DungeonMask, X : STA.b $08
	TXA : LSR A : TAX

.mask_set
	TXA
	JSR CheckPotSection
	BCS +
		PLX
		PLA
		BRA .next_pot
+

	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX
if !FEATURE_FIX_BASEROM
	LDA.l SpriteDropData, X
else
	LDA.l RoomPotData, X
endif
	PLX
	AND.b $08
	BEQ .not_obtained
	PLA
	BRA .next_pot

.not_obtained
	PLA
	AND.w #$00FF
	JSR GetLootClass
	BRA .next_pot

.done
	RTS

CheckJunkPot:
	LDA.b [$04], Y
	PHA
	PHX
	TXA : ASL A : TAX
	LDA.l DungeonMask, X : STA.b $08
	TXA : LSR A
	JSR CheckPotSection
	BCS +
		PLX
		PLA
		RTS
	+

	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX
	LDA.l PotCollectionRateTable, X
	AND.b $08
	BEQ .not_important

if !FEATURE_FIX_BASEROM
	LDA.l SpriteDropData, X
else
	LDA.l RoomPotData, X
endif
	AND.b $08
	BNE .not_important

	PLX
	PLA
	AND.w #$00FF
	JSR GetPotJunkClass
	RTS

.not_important
	PLX
	PLA
	RTS

CheckEnemies:
	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX


	; get sprite pointer table
	LDA.l $89C298 : STA.b $04
	LDA.w #$0089 : STA.b $06
	TXY
	; get sprite pointer for room
	LDA.b [$04], Y
	INC A ; skip the layered/unlayered indicator
	STA.b $04
	LDA.w #bank(UWSpritesData)
	STA.b $06

	LDY.w #$0000
	LDX.w #$FFFF
.next_enemy
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$00FF
	BNE +
		JMP .done
	+
	LDA.b [$04], Y
	AND.w #$E000
	CMP.w #$E000
	BEQ .overlord
	INY : INY
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$00F8 : BEQ .major ; major item
	CMP.w #$00F9 : BEQ .major ; major item in other world
	CMP.w #$00E4 : BEQ .vanilla_key
	INY
	INX
	BRA .next_enemy

.overlord
	INY : INY : INY
	BRA .next_enemy

.vanilla_key
	DEY : DEY
	LDA.w #$8000 : STA.b $08
	LDA.b [$04], Y
	INY #3
	AND.w #$00FF
	CMP.w #$00FD ; big key
	BEQ .big_key
	CMP.w #$00FE ; small key
	BEQ .small_key
	; false alarm -- probably hera basement key
	INX ; since it's an actual sprite it advances the counter
	BRA .next_enemy
.small_key
	LDA.w #$0024
	PHA : PHX
	BRA .mask_set
.big_key
	LDA.w #$0032
	PHA : PHX
	BRA .mask_set

.major
	DEY : DEY
	LDA.b [$04], Y
	AND.w #$00FF

.proceed
	INY : INY : INY

	PHA
	PHX
	TXA : ASL A
	TAX
	LDA.l DungeonMask, X : STA.b $08
	TXA : LSR A : TAX

.mask_set
	TXA
	JSR CheckEnemySection
	BCS +
		PLX
		PLA
		JMP .next_enemy
+

	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX

	LDA.l SpriteDropData, X
	PLX
	AND.b $08
	BEQ .not_obtained
	PLA
	JMP .next_enemy

.not_obtained
	PLA
	AND.w #$00FF
	JSR GetLootClass
	JMP .next_enemy

.done
	RTS

; A = item id
; updates "best loot" value if better
GetLootClass:
	PHX
	TAX
	CMP.w #$0025 : BEQ .compass
	AND.w #$00F0
	CMP.w #$0080 : BNE .not_compass

.compass
	LDA.b $0E
	AND.w #$00FF
	CMP.w #$0002
	BEQ .check_value

.not_compass
	LDA.b $0E
	BEQ .done
	CMP.w #$0003
	BCS .check_value

	LDA.w #$0001
	BRA .value_set

.check_value
	LDA.l LootTypeMapping, X
	AND.w #$00FF

.value_set
	CMP.b $02
	BCC .done
	STA.b $02

.done
	PLX
	RTS

; A = item id
; updates "best loot" value if better
GetPotJunkClass:
	PHX
	TAX

	LDA.b $0E
	BEQ .done
	CMP.w #$0003
	BCS .check_value

	LDA.w #$0001
	BRA .value_set

.check_value
	; hardcode as junk for now
	LDA.w #$0002

.value_set
	CMP.b $02
	BCC .done
	STA.b $02

.done
	PLX
	RTS

macro DefineGetFooSection(type, offset)
Get<type>Section:
	PHX
	LDA.b $CA
	AND.w #$01FF
	ASL A
	TAX
	LDA.l SplitRooms, X
	TAX

	LDA.l SplitRooms, X
	AND.w #$00FF
	STA.b $CE
	BEQ .found

	INX
.check_next_section
	PHX
	LDA.l SplitRooms+<offset>, X
	TAX
-
	LDA.l SplitRooms, X
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .not_this_section
	CMP.b $CC
	BEQ .plx_found

	INX
	BRA -

.not_this_section
	PLX
	TXA : CLC : ADC.w #$000D : TAX
	DEC.b $CE
	BNE .check_next_section
	BRA .found

.plx_found
	PLX

.found
	PLX
	LDA.b $CE
	RTS
endmacro

macro DefineCheckFooSection(type)
Check<type>Section:
	STA.b $CC

	LDA.b $CB
	AND.w #$00F0
	BEQ .yes

	JSR Get<type>Section

	LDA.b $CB
	AND.w #$00F0
	LSR A : LSR A : LSR A : LSR A
	DEC A
	CMP.b $CE
	BEQ .yes

.no
	CLC
	RTS

.yes
	SEC
	RTS
endmacro

%DefineGetFooSection(Door, 3)
%DefineGetFooSection(Stair, 5)
%DefineGetFooSection(Chest, 7)
%DefineGetFooSection(Pot, 9)
%DefineGetFooSection(Enemy, 11)

%DefineCheckFooSection(Door)
%DefineCheckFooSection(Stair)
%DefineCheckFooSection(Chest)
%DefineCheckFooSection(Pot)
%DefineCheckFooSection(Enemy)

GetIncomingStairSection:
	PHX
	AND.w #$0300
	XBA
	ASL A
	TAX
	LDA.l $8098D8, X
	STA.b $CC

	LDA.b $CA
	AND.w #$00FF
	ASL A
	TAX
	LDA.l SplitRooms, X
	TAX

	LDA.l SplitRooms, X
	AND.w #$00FF
	STA.b $CE
	BEQ .found

	INX
.check_next_section
	LDA.l SplitRooms+0, X
	AND.w #$00FF
	AND.b $CC
	BNE .found
	TXA : CLC : ADC.w #$000D : TAX
	DEC.b $CE
	BNE .check_next_section
	BRA .found

.found
	PLX
	LDA.b $CE
	RTS
