; A = room_id
; out A = level of loot
CheckLoot:
	PHP
	REP #$30
	PHB : PHX : PHY

	STA.b $CA

	LDA.b $06 : PHA
	LDA.b $0E : PHA

	STZ.b $02 ; best item class found

	LDA.l ShowItems_default
	AND.w #$00FF
	STA.b $0E

	LDA.b $CA
	AND.w #$00FF
	ASL A
	TAX

	LDA.l SaveDataWRAM, X
	AND.w #$000F
	BEQ +
	LDA.l ShowItems_visited_tile
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E

+	LDA.w DungeonID
	TAX

	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowItems_have_map
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E

+	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
	LDA.l ShowItems_have_compass
	AND.w #$00FF
	CMP.b $0E
	BCC +
	STA.b $0E
+

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
	JSR CheckBoss
+

	LDA.l ItemSources : BIT.w #$0010 : BEQ +
	JSR CheckPrize
+

.done
	PLA : STA.b $0E
	PLA : STA.b $06
	PLY : PLX : PLB
	PLP
	LDA.b $02
	RTL

CheckChests:
	LDA.b $CA
	AND.w #$00FF
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

CheckBoss:
	; we assume all bosses are in section 1 of split sections
	; mainly to simplify hera cage key and GT torch
	; which use the same flow
	; and bosses are always in their own section anyway
	LDA.b $CA
	AND.w #$F000
	XBA
	CMP.w #$0020
	BCC +
	RTS

+
	LDA.b $CA
	AND.w #$00FF
	STA.b $04

	LDX.w #$FFFA
.next_boss
	INX #6
	LDA.l MiscLocations, X
	BPL .check
	RTS

.check
	CMP.b $04
	BNE .next_boss

	TXY
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
	BNE .next_boss ; continue checking if we already got the item

	LDA.l MiscLocations+4, X
	STA.b $05

	LDA.l MiscLocations+3, X
	STA.b $04

	LDA.b [$04]
	AND.w #$00FF
	JSR GetLootClass

	BRA .next_boss

CheckPrize:
	LDA.b $CA
	AND.w #$00FF
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

CheckPots:
	LDA.b $CA
	AND.w #$00FF
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
	AND.w #$00FF
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
	AND.w #$00FF
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
	AND.w #$00FF
	ASL A
	TAX

	LDA.l UWSpritesPointers, X
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
	AND.w #$00FF
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
	LDA.l AlwaysShowCompass : BNE .check_value

.not_compass
	LDA.b $0E
	BEQ .done
	CMP.w #$0001
	BEQ .value_set

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
	CMP.w #$0001
	BEQ .value_set

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
	AND.w #$00FF
	BEQ .yes

	JSR Get<type>Section

	LDA.b $CB
	AND.w #$00FF
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
