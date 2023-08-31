; hooks
org $81E6B0
	JSL RevealPotItem
	RTS

org $829C25
	JSL SetTheSceneFix

org $89C2BB
	JSL ClearSpriteData

; underworld -> overworld transition
org $8282D1
	JSL ClearSpriteData2

org $89C327
	JSL LoadSpriteData

org $86F976
	JSL RevealSpriteDrop : NOP

org $86E3C4
	JSL RevealSpriteDrop2 : NOP

org $86926e ; <- 3126e - sprite_prep.asm : 2664 (LDA $0B9B : STA $0CBA, X)
	JSL SpriteKeyPrep : NOP #2

org $86d049 ; <- 35049 sprite_absorbable : 31-32 (JSL Sprite_DrawRippleIfInWater : JSR Sprite_DrawAbsorbable)
	JSL SpriteKeyDrawGFX : BRA + : NOP : +

org $86d03d
	JSL ShouldSpawnItem : NOP #2

org $86D19F
	JSL MarkSRAMForItem : NOP #2

org $86d180
	JSL BigKeyGet : BCS $07 : NOP #5

org $86d18d ; <- 3518D - sprite_absorbable.asm : 274 (LDA $7EF36F : INC A : STA $7EF36F)
	JSL KeyGet

org $86f9f3 ; bank06.asm : 6732 (JSL Sprite_LoadProperties)
	JSL LoadProperties_PreserveCertainProps

;org $808BAA ; NMI hook
;	JSL TransferPotGFX

org $86828A
	JSL CheckSprite_Spawn

org $87B169
	JSL PreventPotSpawn : NOP

org $87B17D
	JSL PreventPotSpawn2

org $868275
	JSL SubstitionFlow

org $80A9DC
dw $1928, $1938, $5928, $5938 ; change weird ugly black diagonal pot to blue-ish pot

org $818650
dw $B395 ; change tile type to normal pot

org $81B3D5
JSL CheckIfPotIsSpecial


; refs to other functions
org $8681F4
Sprite_SpawnSecret_pool_ID:
org $868283
Sprite_SpawnSecret_NotRandomBush:
org $86828A
Sprite_SpawnSecret_SpriteSpawnDynamically:
org $86d23a
Sprite_DrawAbsorbable:
org $9eff81
Sprite_DrawRippleIfInWater:
org $8db818
Sprite_LoadProperties:
org $86D038
KeyRoomFlagMasks:
org $80FDEE
InitializeMirrorHDMA:
org $80E3C4
LoadCommonSprites_long:

org $09D62E
UWSpritesPointers: ; 0x250 bytes for 0x128 rooms' 16-bit pointers

org $09D87E
UWPotsPointers: ; 0x250 bytes for 0x128 rooms' 16-bit pointers

org $09DACE
UWPotsData: ; variable number of bytes (max 0x11D1) for all pots data

org $A88000
UWSpritesData: ; variable number of bytes (max 0x2800) for all sprites and sprite drop data
; First $2800 bytes of this bank (28) is reserved for the sprite tables

; $2800 bytes reserved for sprites

org $A8A800
;tables:
PotMultiWorldTable:
; Reserved $250 296 * 2

org $A8AA50
StandingItemsOn: ; 142A50
db 0
MultiClientFlagsROM: ; 142A51-2 -> stored in SRAM at 7ef33d (for now)
dw 0
SwampDrain1HasItem: ; 142A53
db 1
SwampDrain2HasItem: ; 142A54
db 1
StandingItemCounterMask: ; 142A55
db 0 ; if 0x01 is set then pot should be counted, if 0x02 then sprite drops, 0x03 (both bits for both)
PotCountMode: ; 28AA56-7
; 0 is don't count pots
; 1 for check PotCollectionRateTable
dw 0

org $A8AA60
PotCollectionRateTable:
; Reserved $250 296 * 2

org $A8ACB0
UWEnemyItemFlags:
; Reserved $250 296 * 2


org $A8AF00
UWSpecialFlagIndex:
; Reserved $128 (296)
; Initial table indexed by room id
; Special values: $FF indicates the room can use the UWEnemyItemFlags table
;                 Any other value tell you where to start in the special table
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF


org $A8B028
UWSpecialFlag:
; reserved exactly $100 or 256 bytes for now estimated usage is at 159 bytes right now
; Simple mask table, 3 bytes per entry: 1st byte what dungeon it applies, if $FF, then the list is done
; Lists that has even numbers of entries will end with $FF $FF to keep everything 2 byte aligned
; (if not matched, assume mask of value 0)
; 2nd and 3rd bytes are the mask

; For indicator idea:
; EOR between a mask and the equivalent SRAM should result in zero if all items are obtained

; For whether to spawn:
; $FF indicates a spawn without further checking, otherwise need to check the mask in the simple table
; this should be checked in addition to SRAM

org $A8B128
RevealPotItem:
	STA.b $04 ; save tilemap coordinates
	STZ.w SpawnedItemFlag
	STZ.w SpawnedItemMWPlayer
	LDA.w $0B9C : AND.w #$FF00 : STA.w $0B9C

	LDA.b $A0 : ASL : TAX

	LDA.l UWPotsPointers,X : STA.b $00 ; we may move this
	LDA.w #UWPotsPointers>>16 : STA.b $02

	LDY.w #$FFFD : LDX.w #$FFFF

.next_pot
	INY : INY : INY

	LDA.b [$00],Y
	CMP.w #$FFFF : BEQ .exit

	INX

	STA.w $08 ; remember the exact value
	AND.w #$3FFF
	CMP.b $04 : BNE .next_pot ; not the correct value

	STZ.w SpawnedItemIsMultiWorld
	BIT.b $08
	BVS LoadMultiWorldPotItem
	BMI LoadMajorPotItem

.normal_secret
	STA $08

	PHX : PHY
		; set bit and count if first time lifting this pot
		TXA : ASL : TAX : LDA.l BitFieldMasks, X : STA $0A
		LDA.b $A0 : ASL : TAX
		JSR ShouldCountNormalPot : BCC .obtained
		LDA.l RoomPotData, X : BIT $0A : BNE .obtained
			ORA $0A : STA RoomPotData, X
			; increment dungeon counts
			SEP #$10
			LDX.w $040C : CPX.b #$FF : BEQ +
				CPX.b #$00 : BNE ++
				 	INX #2 ; treat sewers as HC
				++ LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
				; Could increment GT Tower Pre Big Key but we aren't showing that stat right now
			+ REP #$10
			LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
			INC.w UpdateHUD
		.obtained
	PLY : PLX

	PLA ; remove the JSL return lower 16 bits
	LDA $08
	PEA.w $01E6E2-1 ; change return address to go back to the vanilla routine
.exit
	RTL

LoadMultiWorldPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

	INC.w SpawnedItemIsMultiWorld
	PHX
	ASL : TAX

	LDA.l PotMultiWorldTable+1,X : AND.w #$00FF : STA.w SpawnedItemMWPlayer

	LDA.l PotMultiWorldTable+0,X : AND.w #$00FF

	PLX

	BRA SaveMajorItemDrop
MultiItemExit:
	LDA.w #$0008 : STA.w $0B9C
RTL

LoadMajorPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

SaveMajorItemDrop:
	; A currently holds the item receipt ID
	; X currently holds the pot item index
	STA.w SpawnedItemID
	STX.w SpawnedItemIndex
	INC.w SpawnedItemFlag
	TAY
	LDA.l SpawnedItemIsMultiWorld : BNE MultiItemExit
	LDA.w #$0008
	CPY.w #$0036 : BNE +  ; Red Rupee
		LDA.w #$0016 : BRA .substitute
	+ CPY.w #$0044 : BNE + ; 10 pack arrows
		LDA.w #$0017 : BRA .substitute
	+ CPY.w #$0028 : BNE + ; 3 pack bombs
		LDA.w #$0018 : BRA .substitute
	+ CPY.w #$0031 : BNE + ; 10 pack bombs
		LDA.w #$0019 : BRA .substitute
	+ STA $0B9C ; indicates we should use the key routines or a substitute
RTL
	.substitute
	PHA
		TXA : ASL : STA.b $00
		LDA.w #$001F : SBC $00
		TAX : LDA.l BitFieldMasks, X : STA $00
		LDA.b $A0 : ASL : TAX
		LDA.l $7EF580, X
		AND.b $00
		BNE .exit
		LDA.l $7EF580, X : ORA $00 : STA.l $7EF580, X
	PLA : STA $0B9C
RTL
	.exit
	PLA : STZ.w $0B9C
RTL

ShouldCountNormalPot:
	INY : INY : LDA [$00], Y : AND #$00FF : CMP #$0080 : BCS .clear
	LDA.l PotCountMode : BEQ .clear
	LDA.l PotCollectionRateTable, X : BIT $0A : BEQ .clear ; don't count if clear
.set
	SEC
RTS
.clear
	CLC
RTS

IncrementCountsForSubstitute:
	PHX : REP #$30
	LDA.w SpawnedItemIndex : ASL : TAX : LDA.l BitFieldMasks, X : STA $0A
	LDA.b $A0 : ASL : TAX
	LDA.l RoomPotData, X : BIT $0A : BNE .obtained
		ORA $0A : STA RoomPotData, X
		SEP #$10
		LDX.w $040C : CPX.b #$FF : BEQ +
			CPX.b #$00 : BNE ++
				INX #2 ; treat sewers as HC
			++ LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
			; Could increment GT Tower Pre Big Key but we aren't showing that stat right now
		+
		LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
		INC.w UpdateHUD
	.obtained
	SEP #$30 : PLX
RTS

ClearSpriteData:
	STZ.b $03 ; what we overrode  # we no longer need STZ $02 see underworld_sprite_hooks
	.shared:

	PHX
		LDA #$00 : LDX #$00
		.loop
			STA SprDropsItem, X :  STA SprItemReceipt, X : STA SprItemIndex, X
			STA SprItemMWPlayer, X : STA SprItemFlags, X
			INX : CPX #$10 : BCC .loop
		JSR SetupEnemyDropIndicator
	PLX
	RTL

ClearSpriteData2:
	LDA.b #$82 : STA.b $99
	JMP ClearSpriteData_shared


; this routine determines whether enemies still have drops or not
; and sets EnemyDropIndicator appropriately
; uses X register, assumes flags are (MX) but (mX) is fine
SetupEnemyDropIndicator:
	REP #$20
	LDA.w #!BlankTile : STA.w !EnemyDropIndicator
	LDX.b $1B : BEQ .done
	; do we have a flag for enemy drops on? could check it here
	LDA.w $040C : AND.w #$00FF : CMP.w #$00FF : BEQ .skipCompassChecks
	; compass checks
	; does compass for dungeon exist?
	LSR : TAX : LDA.l ExistsTransfer, X : TAX : LDA.l CompassExists, X : BEQ .skipCompassChecks
	; doe we have the compass
	; todo: sewers?
	LDA.l CompassField : LDX.w $040C : AND.l DungeonMask, X : BEQ .done

.skipCompassChecks
	; either we're in a cave ($040C: $FF), compass doesn't exist, or we have the compass
	; check if there are enemy drops
	LDA.b $02 : PHA : REP #$10 ; store 02/03 for later
	LDX.b $A0 : LDA.l UWSpecialFlagIndex, X : AND.w #$00FF ; determine if special case or not
	CMP.w #$00FF : BEQ .loadNormalFlags
	JSR FetchBitmaskForSpecialCase
	PHA : LDA $A0 : ASL : TAX : PLA
	BRA .testAgainstMask

.loadNormalFlags
	TXA : ASL : TAX : LDA.l UWEnemyItemFlags, X

.testAgainstMask
	STA.b $02 : LDA.l SpriteDropData, X : AND.b $02 : EOR.b $02
	BEQ .cleanup
	LDA.w #!BlueSquare : STA.w !EnemyDropIndicator

.cleanup
	SEP #$10 : PLA : STA.b $02

.done
SEP #$20
RTS


; Runs during sprite load of the room
LoadSpriteData:
	INY : INY
	LDA.b [$00], Y
	CMP #$F3 : BCC .normal
		PHA
			DEC.b $03 ; standing items shouldn't consume a sprite slot
			LDX.b $03 ; these were changed to $03, for moved sprites
			CMP #$F9 : BNE .not_multiworld
				DEY : LDA.b [$00], Y : STA.l SprItemMWPlayer, X
				LDA.b #$02 : STA.l SprDropsItem, X : BRA .common
			.not_multiworld
			LDA.b #$00 : STA.l SprItemMWPlayer, X
			LDA.b #$01 : STA.l SprDropsItem, X
			DEY
			.common
			DEY : LDA.b [$00], Y : STA.l SprItemReceipt, X
		INY : INY
		PLA
		PLA : PLA ; remove the JSL return lower 16 bits
		PEA.w $09C344-1 ; change return address to exit from Underworld_LoadSingleSprite
		RTL
	.normal
	RTL

; Run when a sprite dies ... Sets Flag to #$02 and Index to sprite slot for
RevealSpriteDrop:
	LDA.l SprDropsItem, X : BNE CheckIfDropValid
	JMP DoNormalDrop

CheckIfDropValid:
	REP #$30 : PHX ; save it for later
	TXA : ASL : TAX : LDA.l BitFieldMasks, X : STA.b $00  ; stores the bitmask for the specific drop
	; check sram, if gotten, run normal
	LDA.b $A0 : ASL : TAX : LDA.l SpriteDropData, X : PLX ; restore X in case we're done
	BIT.b $00 : BNE DoNormalDrop ; zero indicates the item has not been obtained
	PHX  ; save it for later
	LDX.b $A0 : LDA.l UWSpecialFlagIndex, X : AND.w #$00FF
	CMP.w #$00FF : BEQ + ; $FF indicates the EnemyItemFlags are sufficient
		JSR FetchBitmaskForSpecialCase
		BRA .test
	+ TXA : ASL : TAX : LDA.l UWEnemyItemFlags, X
	.test PLX : BIT.b $00 : BEQ DoNormalDrop ; zero indicates the enemy doesn't drop
	SEP #$30
	;This section sets up the drop
		LDA #$02 : STA.l SpawnedItemFlag
		STX.w SpawnedItemIndex
		LDA.l SprItemReceipt, X : STA SpawnedItemID
		LDA.l SprItemMWPlayer, X : STA SpawnedItemMWPlayer
		LDY.b #$01 ; trigger the small key routines
		LDA.w SpawnedItemID : STA.b $00 : CMP #$32 : BNE +
		LDA.l StandingItemsOn : BNE +
			INY ; big key routine
		+
		PHX
	    LDA.l SpawnedItemMWPlayer : BNE .done ; abort check for absorbables it belong to someone else
	    LDX.b #$00 ; see if the item should be replaced by an absorbable
		- CPX.b #$1A : BCS .done
			LDA.l MinorForcedDrops, X
			CMP.b $00 : BNE +
				INX : LDA.l MinorForcedDrops, X : STA.b $00
				PLX : PLA : PLA : PEA.w $06F9D7-1 ; change call stack for PrepareEnemyDrop
				JSR IncrementCountForMinor
				LDA.b $00 : RTL
			+ INX #2 : BRA -
		.done PLX
		 RTL ; unstun if stunned

DoNormalDrop:
	SEP #$30
	LDY.w $0CBA, X : BEQ .no_forced_drop
		RTL
	.no_forced_drop
	PLA : PLA ; remove the JSL reswamturn lower 16 bits
	PEA.w $06F996-1 ; change return address to .no_forced_drop of (Sprite_DoTheDeath)
	RTL

RevealSpriteDrop2:
	LDY.w SprDropsItem, X : BEQ .normal
		BRA .no_forced_drop
	.normal
	LDY.w $0CBA, X : BEQ .no_forced_drop
		RTL
	.no_forced_drop
	PLA : PLA ; remove the JSL reswamturn lower 16 bits
	PEA.w $06E3CE-1 ; change return address to .no_forced_drop of (Sprite_DoTheDeath)
	RTL

; input - A the index from UWSpecialFlagIndex
; uses X for loop, $02 for comparing first byte to dungeon
; output - A the correct bitmask
FetchBitmaskForSpecialCase:
	ASL : TAX
	LDA.w $040C : BNE +   ; could check if we are in a cave here and branch to different function?
		INC #2 ; move sewers to HC
	+ STA.b $02
	- LDA.l UWSpecialFlag, X : AND.w #$00FF
	CMP.w #$00FF : BNE +  ; if the value is FF we are done, use 0 as bitmask
		LDA.w #$0000 : RTS
	+  CMP.b $02 : BNE +  ; if the value matches the dungeon, use next 2 bytes as bitmasl
		INX : LDA.l UWSpecialFlag, X : RTS
	+ INX #3 : BRA - ; else move to the next row

MinorForcedDrops:
; Item ID -> Sprite ID
db $27, $DC ; BOMB REFILL 1
db $28, $DD ; BOMB REFILL 4
db $31, $DE ; BOMB REFILL 8
db $34, $D9 ; GREEN RUPEE  ($34)
db $35, $DA ; BLUE RUPEE  ($35)
db $36, $DB ; RED RUPEE ($36)
db $42, $D8 ; HEART ($42)
db $44, $E2 ; ARROW REFILL 10 ($44)
db $45, $DF ; SMALL MAGIC DECANTER ($45)
db $B2, $E3 ; FAERIE ($B2)
db $B3, $0B ; CUCCO ($B3)
db $B4, $E0 ; LARGE MAGIC DECANTER ($B4)
db $B5, $E1 ; ARROW REFILL 5  (x??)


IncrementCountForMinor:
	PHX : REP #$30
	LDA.w SpawnedItemIndex : ASL : TAX : LDA.l BitFieldMasks, X : STA $0A
	LDA.b $A0 : ASL : TAX
	LDA.l SpriteDropData, X : BIT $0A : BNE .obtained
		ORA $0A : STA SpriteDropData, X
		SEP #$10
		JSR SetupEnemyDropIndicator
		LDX.w $040C : CPX.b #$FF : BEQ +
			CPX.b #$00 : BNE ++
				INX #2 ; treat sewers as HC
			++ LDA.l DungeonLocationsChecked, X : INC : STA.l DungeonLocationsChecked, X
			; Could increment GT Tower Pre Big Key but we aren't showing that stat right now
		+ REP #$10
		LDA TotalItemCounter : INC : STA TotalItemCounter ; Increment Item Total
		INC.w UpdateHUD
	.obtained
	SEP #$30 : PLX
RTS

BitFieldMasks:
dw $8000, $4000, $2000, $1000, $0800, $0400, $0200, $0100
dw $0080, $0040, $0020, $0010, $0008, $0004, $0002, $0001

; Runs during Sprite_E4_SmallKey and duning Sprite_E5_BigKey spawns
ShouldSpawnItem:
	LDA $048E : CMP.b #$87 : BNE + ; check for hera basement cage
	CPX #$0A : BNE +  ; the hera basement key is always sprite 0x0A
	LDA $A8 : AND.b #$03 : CMP.b #$02 : BNE + ; we're not in that quadrant
			LDA.w $0403 : AND.w KeyRoomFlagMasks,Y : RTL
	+
	; checking our sram table
	PHX : PHY
		REP #$30
		LDA.b $A0 : ASL : TAY
		LDA.w SprItemIndex, X : AND #$00FF : ASL
		PHX
			TAX : LDA.l BitFieldMasks, X : STA $00
		PLX ; restore X again
		LDA.w SprItemFlags, X : AND #$00FF : CMP #$0001 : BEQ +
			TYX : LDA.l SpriteDropData, X : BIT $00 : BEQ .notObtained
			BRA .obtained
		+ TYX : LDA.l RoomPotData, X : BIT $00 : BEQ .notObtained
			.obtained
			SEP #$30 : PLY : PLX : LDA #$01 : RTL ; already obtained
	.notObtained
	SEP #$30 : PLY : PLX
	LDA #$00
	RTL

MarkSRAMForItem:
	LDA $048E : CMP.b #$87 : BNE + ; check for hera basement cage
		CPX #$0A : BNE +  ; the hera basement key is always sprite 0x0A
			LDA $A8 : AND.b #$03 : CMP.b #$02 : BNE +
				LDA.w $0403 : ORA.w KeyRoomFlagMasks, Y : RTL
	+ PHX : PHY : REP #$30
		LDA.b $A0 : ASL : TAY
		LDA.l SpawnedItemIndex : ASL
		TAX : LDA.l BitFieldMasks, X : STA $00
		TYX
		LDA.w SpawnedItemFlag : CMP #$0001 : BEQ +
			LDA SpriteDropData, X : ORA $00 : STA SpriteDropData, X
			SEP #$10 : JSR SetupEnemyDropIndicator
			BRA .end
		+ LDA RoomPotData, X : ORA $00 : STA RoomPotData, X
	.end
	SEP #$30 : PLY : PLX
	LDA.w $0403
	RTL

SpriteKeyPrep:
	LDA.w $0B9B : STA.w $0CBA, X ; what we wrote over
	PHA
		LDA $A0 : CMP #$87 : BNE .continue
			CPX #$0A : BNE .continue  ; the hera basement key is always sprite 0x0A
				LDA $A9 : ORA $AA : AND #$03 : CMP #$02 : BNE .continue
					LDA #$00 : STA.w SpawnedItemFlag : STA SprItemFlags, X
					LDA #$24 : STA $0E80, X
					BRA +
		.continue
		LDA.w SpawnedItemIndex : STA SprItemIndex, X
		LDA.w SpawnedItemMWPlayer : STA SprItemMWPlayer, X : STA.w !MULTIWORLD_SPRITEITEM_PLAYER_ID
		LDA.w SpawnedItemFlag : STA SprItemFlags, X : BEQ +
		LDA.l SpawnedItemID : STA $0E80, X
		PHA : PHY : PHX
			JSL.l GetSpritePalette : PLX : STA $0F50, X ; setup the palette
		PLY : PLA
		CMP #$24 : BNE ++ ;
			LDA $A0 : CMP.b #$80 : BNE +
			LDA SpawnedItemFlag : BNE +
				LDA #$24  ; it's the big key drop?
		++ JSL RequestStandingItemVRAMSlot
	+ PLA
	RTL

SpriteKeyDrawGFX:
    JSL Sprite_DrawRippleIfInWater
    PHA
    LDA $0E80, X
   	CMP.b #$24 : BNE +
   		LDA $A0 : CMP #$80 : BNE ++
   		LDA SpawnedItemFlag : BNE ++
    		LDA #$24 : BRA +
    	++ PLA
		   PHK : PEA.w .jslrtsreturn-1
		   PEA.w $068014 ; an rtl address - 1 in Bank06
		   JML Sprite_DrawAbsorbable
		   .jslrtsreturn
		   RTL
	+ JSL DrawPotItem
    CMP #$03 : BNE +
        PHA : LDA $0E60, X : ORA.b #$20 : STA $0E60, X : PLA
    + JSL.l Sprite_DrawShadowLong
    PLA : RTL

KeyGet:
    LDA CurrentSmallKeys ; what we wrote over
    PHA
    	LDA.l StandingItemsOn : BNE +
    		PLA : RTL
    	+ LDY $0E80, X
    	LDA SprItemIndex, X : STA SpawnedItemIndex
    	LDA SprItemFlags, X : STA SpawnedItemFlag
    	LDA $A0 : CMP #$87 : BNE + ;check for hera cage
    	LDA SpawnedItemFlag : BNE + ; if it came from a pot, it's fine
    		JSR ShouldKeyBeCountedForDungeon : BCC ++
			JSL CountChestKeyLong
    		++ PLA : RTL
    	+ STY $00
    	LDA SprItemMWPlayer, X : STA !MULTIWORLD_ITEM_PLAYER_ID : BNE .receive
    	PHX
			LDA $040C : CMP #$FF : BNE +
				LDA $00 : CMP.b #$AF : BNE .skip
				LDA CurrentGenericKeys : INC : STA CurrentGenericKeys
				LDA $00 : BRA .countIt
			+ LSR : TAX
			LDA $00 : CMP.l KeyTable, X : BNE +
				.countIt
				LDA.l StandingItemCounterMask : AND SpawnedItemFlag : BEQ ++
					JSL.l AddInventory : JSL CountChestKeyLong
				++ PLX : PLA : RTL
			+ CMP.b #$AF : beq .countIt ; universal key
			CMP.b #$24 : beq .countIt   ; small key for this dungeon
    	.skip PLX
    	.receive
    	JSL $0791b3 ; Player_HaltDashAttackLong
    	JSL.l Link_ReceiveItem
	PLA : DEC : RTL

KeyTable:
db $A0, $A0, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD

; Input Y - the item type
ShouldKeyBeCountedForDungeon:
	PHX
		LDA $040C : CMP #$FF : BEQ .done
		LSR : TAX
		TYA : cmp KeyTable, X : BNE +
			- PLX : SEC : RTS
		+ CMP.B #$24 : BEQ -
	.done
	PLX : CLC : RTS


BigKeyGet:
	LDY $0E80, X
	CPY #$32 : BNE +
		STZ $02E9 : LDY.b #$32 ; what we wrote over
		PHX : JSL Link_ReceiveItem : PLX ; what we wrote over
		CLC : RTL
	+ SEC : RTL

LoadProperties_PreserveCertainProps:
	LDA $0E20, X : CMP #$E4 : BEQ +
	CMP #$E5 : BEQ +
		JML Sprite_LoadProperties
	+ LDA $0F50, X : PHA
    LDA $0E80, X : PHA
    JSL Sprite_LoadProperties
    PLA : STA $0E80, X
    PLA : STA $0F50, X
    RTL

SubstitionFlow:
	CPY.b #$04 : BNE +
		RTL ; let enemizer/vanilla take care of it
	+ PLA : PLA ; remove JSL stuff
	CPY.b #$16 : BCS +
		PEA.w Sprite_SpawnSecret_NotRandomBush-1 : RTL ; jump to not_random_bush spot
	; jump directly to new code
	+ PEA.w Sprite_SpawnSecret_SpriteSpawnDynamically-1
RTL

SubstitionTable:
	db $DB ; RED RUPEE - 0x16
	db $E2 ; ARROW REFILL 10 - 0x17
	db $DD ; BOMB REFILL 4 - 0x18
    db $DE ; BOMB REFILL 8  - 0x19


SubstituteSpriteId:
	CPY.b #$16 : BCS +
		RTS
	+ LDA.b #$01
	CPY.b #$18 : BCC +
		LDA.b #$05
	+ STA.b $0D
	JSR IncrementCountsForSubstitute
	PHB : PHK : PLB
		LDA.w SubstitionTable-$16, Y ; Do substitute
	PLB
RTS

CheckSprite_Spawn:
	JSR SubstituteSpriteId
	JSL Sprite_SpawnDynamically
	BMI .check
RTL
.check
	LDA $0D : CMP #$08 : BNE +
	LDA $0372 : BNE .error
		LDX #$0F

		; loop looking for a Sprite with state 0A (carried by the player)
		- LDA $0DD0, X : CMP #$0A : BEQ .foundIt
		DEX : BMI .error : BRA -

		.foundIt
		LDA #$00 : STZ $0DD0, X
		LDA #$E4 : JSL Sprite_SpawnDynamically
		BMI .error
		LDA #$40 : TSB $0308 : RTL

		.error
		LDA.b #$3C ; SFX2_3C - error beep
		STA.w $012E
	+ LDA #$FF
RTL

PreventPotSpawn:
	LDA #$40 : BIT $0308 : BEQ +
		STZ $0308 : RTL
	+ LDA.b #$80 : STA.w $0308  ; what we wrote over
RTL

PreventPotSpawn2:
	LDA $0308 : BEQ +
		LDA.b #$01 : TSB.b $50 ; what we wrote over
+ RTL

CheckIfPotIsSpecial:
	TXA ; give index to A so we can do a CMP.l
	CMP.l $018550 ; see if our current index is that of object 230
	BEQ .specialpot

    ; Normal pot, so run the vanilla code
	LDA.l $7EF3CA ; check for dark world
	.specialpot ; zero flag already set, so gtg
RTL

SetTheSceneFix:
	STZ.b $6C
	JSL InitializeMirrorHDMA
	JSL LoadCommonSprites_long
RTL

incsrc dynamic_si_vram.asm

;===================================================================================================
; Pot items
;===================================================================================================
;Vanilla:
;	Data starts at $01DDE7 formatted:
;	dw aaaa : db i

;	aaaa is a 14 bit number: ..tt tttt tttt tttt indicating the tilemap ID
;	i is the secrets ID

;Drop shuffle changes:
;	normal secrets stay vanilla

;	major items (anything not a secret) use the bits 14 and 15 to produce different behavior

;	aaaa is now a 16 bit number:
;	imtt tttt tttt tttt

;	t - is still tilemap id (aaaa & #$3FFF)
;	i - flag indicates a major item
;	m - indicates a multiworld item

;	for major items (non multiworld), i indicates the item receipt ID

;	for multi world items, i indicates the multiworld id
;	multiworld id indexes a new table of 256 entries of 2 bytes each

;	MultiWorldTable:
;		db <item receipt ID>, <player ID>



;===================================================================================================
; Sprite items
;===================================================================================================
;Vanilla:
;If this value appears in the sprite table, then the sprite that preceded it is given a key drop
;	db $FE, $00, $E4

;Drop shuffle changes:
;	db <receipt id>, $00, $F8 ; this denotes the previous sprite is given a major item (non MW)

;   db <receipt id>, <player>, $F9 ; this denotes the previous sprite is given a MW item
