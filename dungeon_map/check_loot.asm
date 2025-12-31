; A = room_id
; out A = level of loot
CheckLoot:
	PHP
	REP #$30
	PHB : PHX : PHY

	STA.b $00
	ASL A
	TAX

	LDA.b $06 : PHA

	STZ.b $02 ; best item class found

	JSR CheckChests
	JSR CheckBoss
	JSR CheckPots
	JSR CheckEnemies

	PLA : STA.b $06
	PLY : PLX : PLB
	PLP
	LDA.b $02
	RTL

CheckChests:
	LDA.w #($81<<8)
	PHA
	PLB : PLB

	LDA.w #$0008
	STA.b $04

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
	LDX.w #$FFFA
.next_boss
	INX #6
	LDA.l MiscLocations, X
	BPL .check
	RTS

.check
	CMP.b $00
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

CheckPots:
	LDA.b $00
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
	BIT.w #$8000 : BNE .we_care ; marked as major item
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$0008 : BEQ .small_key
	INY
	BRA .next_pot

.small_key
	LDA.w #$0024
.we_care
	INY
	PHA
	PHX
	TXA : ASL A
	EOR.w #$FFFF
	CLC : ADC.w #$001F ; bit mask table is in opposite order of what we want
	TAX
	LDA.l DungeonMask, X : STA.b $08

	LDA.b $00 : ASL A : TAX
	LDA.l RoomPotData, X
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

CheckEnemies:
	LDA.b $00
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
	CMP.w #$00FF : BEQ .done
	INY : INY
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$00F8 : BEQ .major ; major item
	CMP.w #$00F9 : BEQ .major ; major item in other world
	CMP.w #$00E4 : BEQ .vanilla_key
	INY
	BRA .next_enemy

.vanilla_key
	DEY : DEY
	LDA.b [$04], Y
	AND.w #$00FF
	CMP.w #$00FD ; big key
	BEQ .big_key
	CMP.w #$00FE ; small key
	BEQ .small_key
	INY #3 ; false alarm -- probably hera basement key
	BRA .next_enemy
.small_key
	LDA.w #$0024
	BRA .proceed
.big_key
	LDA.w #$0032
	BRA .proceed

.major
	DEY : DEY
	LDA.b [$04], Y
	AND.w #$00FF

.proceed
	INX
	INY : INY : INY

	PHA
	PHX
	TXA : ASL A
	TAX
	LDA.l DungeonMask, X : STA.b $08

	LDA.b $00 : ASL A : TAX
	LDA.l SpriteDropData, X
	PLX
	AND.b $08
	BEQ .not_obtained
	PLA
	BRA .next_enemy

.not_obtained
	PLA
	AND.w #$00FF
	JSR GetLootClass
	BRA .next_enemy

.done
	RTS

; A = item id
; updates "best loot" value if better
GetLootClass:
	PHX
	TAX
	LDA.l LootTypeMapping, X
	AND.w #$00FF
	CMP.b $02
	BCC +
	STA.b $02
+	PLX
	RTS
