;================================================================================
; Randomize Heart Pieces
;--------------------------------------------------------------------------------
HeartPieceGet:
	PHX : PHY
	LDY $0E80, X ; load item value into Y register
	BNE +
		; if for any reason the item value is 0 reload it, just in case
		JSL.l LoadHeartPieceRoomValue : TAY
	+
	JSL.l MaybeMarkDigSpotCollected

	.skipLoad

	JSL.l HeartPieceGetPlayer : STA !MULTIWORLD_ITEM_PLAYER_ID

	STZ $02E9 ; 0 = Receiving item from an NPC or message

	CPY.b #$26 : BNE .notHeart ; don't add a 1/4 heart if it's not a heart piece
	LDA !MULTIWORLD_ITEM_PLAYER_ID : BNE .notHeart
	LDA HeartPieceQuarter : INC A : AND.b #$03 : STA HeartPieceQuarter : BNE .unfinished_heart ; add up heart quarters
	BRA .giveItem

	.notHeart

	.giveItem
	JSL.l $0791B3 ; Player_HaltDashAttackLong
	JSL.l Link_ReceiveItem
	CLC ; return false
	JMP .done ; finished

	.unfinished_heart
	SEC ; return true
	.done
	
    JSL MaybeUnlockTabletAnimation
	
	PLY : PLX
RTL
;--------------------------------------------------------------------------------
HeartContainerGet:
	PHX : PHY
	JSL.l AddInventory_incrementBossSwordLong
	LDY $0E80, X ; load item value into Y register
	BNE +
		; if for any reason the item value is 0 reload it, just in case
		JSL.l LoadHeartContainerRoomValue : TAY
	+

	BRA HeartPieceGet_skipLoad
;--------------------------------------------------------------------------------
DrawHeartPieceGFX:
	PHP
	JSL.l Sprite_IsOnscreen : BCC .offscreen
	
	PHA : PHY
	LDA.w !SPRITE_REDRAW, X : BEQ .skipInit ; skip init if already ready
		JSL.l HeartPieceSpritePrep
		BRA .done ; don't draw on the init frame
	
	.skipInit
	LDA $0E80, X ; Retrieve stored item type
	
	.skipLoad
	JSL DrawSlottedTile : BCS .done
		; draw shadow
		CMP #$03 : BNE +
			INC.b $00 : INC.b $00 : INC.b $00 : INC.b $00 ; move narrow sprite shadow over 4 pixels
			PHA : LDA $0E60, X : ORA.b #$20 : STA $0E60, X : PLA
		+
		JSL.l Sprite_DrawShadowLong
	
	.done
	PLY : PLA
	.offscreen
	PLP
RTL
;--------------------------------------------------------------------------------
DrawHeartContainerGFX:
	PHP
	JSL.l Sprite_IsOnscreen : BCC DrawHeartPieceGFX_offscreen
	
	PHA : PHY
	LDA.w !SPRITE_REDRAW, X : BEQ .skipInit ; skip init if already ready
		JSL.l HeartContainerSpritePrep
		BRA DrawHeartPieceGFX_done ; don't draw on the init frame
	
	.skipInit
	BRA DrawHeartPieceGFX_skipInit
;--------------------------------------------------------------------------------
HeartContainerSound:
	LDA !MULTIWORLD_ITEM_PLAYER_ID : BNE +
	CPY.b #$20 : BEQ + ; Skip for Crystal
	CPY.b #$37 : BEQ + ; Skip for Pendants
	CPY.b #$38 : BEQ +
	CPY.b #$39 : BEQ +
    JSL.l CheckIfBossRoom : BCC + ; Skip if not in a boss room
	        LDA.b #$2E
			SEC
		RTL
	+
	CLC
RTL
;--------------------------------------------------------------------------------
NormalItemSkipSound:
	LDA !MULTIWORLD_ITEM_PLAYER_ID : BEQ +
		SEC
		RTL
	+

	LDA $0C5E, X ; thing we wrote over

	CPY.b #$20 : BEQ + ; Skip for Crystal
	CPY.b #$37 : BEQ + ; Skip for Pendants
	CPY.b #$38 : BEQ +
	CPY.b #$39 : BEQ +
	
	PHA
    JSL.l CheckIfBossRoom
	PLA
RTL
	+
	CLC
RTL
;--------------------------------------------------------------------------------
HeartUpgradeSpawnDecision: ; this should return #$00 to make the hp spawn
	LDA !FORCE_HEART_SPAWN : BEQ .bonk_prize_check
	
	DEC : STA !FORCE_HEART_SPAWN
	LDA #$00
RTL
	.bonk_prize_check
	PHX
		LDA 2,S : TAX : LDA.w $0ED0, X : BEQ .normal_behavior-1
	PLX
	LDA.b #$00
RTL
	PLX
	.normal_behavior
	LDA OverworldEventDataWRAM, X
RTL
;--------------------------------------------------------------------------------
SaveHeartCollectedStatus:
	LDA !SKIP_HEART_SAVE : BEQ .save_flag
	
	DEC : STA !SKIP_HEART_SAVE
RTL
	
	.save_flag
	LDA 4,S : TAY : LDA $0ED0,Y : BEQ .normal_behavior
		PHA : LDA OverworldEventDataWRAM, X : ORA 1,S : STA OverworldEventDataWRAM, X
		PLA : RTL

	.normal_behavior
	LDA OverworldEventDataWRAM, X : ORA.b #$40 : STA OverworldEventDataWRAM, X
RTL
;--------------------------------------------------------------------------------
HeartPieceSpritePrep:
	PHA
	
	LDA ServerRequestMode : BEQ + :  : +
	
	LDA.b #$01 : STA.w !SPRITE_REDRAW, X
	JSL.l HeartPieceGetPlayer : STA !MULTIWORLD_SPRITEITEM_PLAYER_ID
	JSL.l LoadHeartPieceRoomValue ; load item type
	STA $0E80, X ; Store item type
	JSL.l RequestSlottedTile
	
	.skip
	PLA
RTL
;--------------------------------------------------------------------------------
HeartContainerSpritePrep:
	PHA
	
	JSL.l HeartPieceGetPlayer : STA !MULTIWORLD_SPRITEITEM_PLAYER_ID
	JSL.l LoadHeartContainerRoomValue ; load item type
	STA $0E80, X ; Store item type
	JSL.l RequestSlottedTile
	
	PLA
RTL
;--------------------------------------------------------------------------------
LoadHeartPieceRoomValue:
	LDA $1B : BEQ .outdoors ; check if we're indoors or outdoors
	.indoors
	JSL.l LoadIndoorValue
	JMP .done
	.outdoors
	JSL.l LoadOutdoorValue
	.done
RTL
;--------------------------------------------------------------------------------
HPItemReset:
	PHA
	LDA !MULTIWORLD_ITEM_PLAYER_ID : BNE .skip
		PLA
		JSL $09AD58 ; GiveRupeeGift - thing we wrote over
		BRA .done
	.skip
	PLA
	.done
RTL
;--------------------------------------------------------------------------------
MaybeMarkDigSpotCollected:
	PHA : PHP
		LDA $1B : BNE +
		REP #$20 ; set 16-bit accumulator
		LDA $8A
		CMP.w #$2A : BNE +
			LDA HasGroveItem : ORA.w #$0001 : STA HasGroveItem
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
HeartPieceSpawnDelayFix:
	JSL Sprite_DrawRippleIfInWater
	; Fix the delay when spawning a HeartPiece sprite
	JSL.l Sprite_CheckIfPlayerPreoccupied : BCS + ; what we moved from $05F037
	JSL.l Sprite_CheckDamageToPlayerSameLayerLong : RTL ; what we wrote over
	+ CLC : RTL
;--------------------------------------------------------------------------------
macro GetPossiblyEncryptedItem(ItemLabel,TableLabel)
	LDA IsEncrypted : BNE ?encrypted
		LDA.l <ItemLabel>
		BRA ?done
	?encrypted:
	PHX : PHP
		REP #$30 ; set 16-bit accumulator & index registers
		LDA $00 : PHA : LDA $02 : PHA

		LDA.w #<TableLabel> : STA $00
		LDA.w #<TableLabel>>>16 : STA $02
		LDA.w #<ItemLabel>-<TableLabel>
		JSL RetrieveValueFromEncryptedTable

		PLX : STX $02 : PLX : STX $00
	PLP : PLX
	?done:
endmacro

LoadIndoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #225 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Forest_Thieves, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #226 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lumberjack_Tree, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #234 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Spectacle_Cave, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #283 : BNE +
		LDA $22 : XBA : AND.w #$0001 ; figure out where link is
		BNE ++
			%GetPossiblyEncryptedItem(HeartPiece_Circle_Bushes, HeartPieceIndoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Graveyard_Warp, HeartPieceIndoorValues)
			JMP .done
	+ CMP.w #288 : BNE +
		LDA.l OWBonkPrizeTable[42].loot
		JMP .done
	+ CMP.w #294 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Mire_Warp, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #295 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Smith_Pegs, HeartPieceIndoorValues)
		JMP .done
	+ CMP.w #135 : BNE +
		LDA StandingKey_Hera
		JMP .done
	+
	LDA.w #$0017 ; default to a normal hp
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;225 - HeartPiece_Forest_Thieves
;226 - HeartPiece_Lumberjack_Tree
;234 - HeartPiece_Spectacle_Cave
;283 - HeartPiece_Circle_Bushes
;283 - HeartPiece_Graveyard_Warp
;294 - HeartPiece_Mire_Warp
;295 - HeartPiece_Smith_Pegs
;--------------------------------------------------------------------------------
LoadOutdoorValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $8A
	CMP.w #$00 : BNE +
		LDA.l OWBonkPrizeTable[$00].loot
		JMP .done
	+ CMP.w #$03 : BNE +
		LDA $22 : CMP.w #1890 : !BLT ++
			%GetPossiblyEncryptedItem(HeartPiece_Spectacle, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(EtherItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$05 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$01].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Mountain_Warp, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$0A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$02].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$03].loot
			JMP .done
	+ CMP.w #$10 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$04].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$05].loot
			JMP .done
	+ CMP.w #$11 : BNE +
		LDA.l OWBonkPrizeTable[$06].loot
		JMP .done
	+ CMP.w #$12 : BNE +
		LDA.l OWBonkPrizeTable[$07].loot
		JMP .done
	+ CMP.w #$13 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$08].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$09].loot
			JMP .done
	+ CMP.w #$15 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0A].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0B].loot
			JMP .done
	+ CMP.w #$18 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0C].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0D].loot
			JMP .done
	+ CMP.w #$1A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0E].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$0F].loot
			JMP .done
	+ CMP.w #$1B : BNE +
		LDA.l OWBonkPrizeTable[$11].loot
		JMP .done
	+ CMP.w #$1D : BNE +
		LDA.l OWBonkPrizeTable[$12].loot
		JMP .done
	+ CMP.w #$1E : BNE +
		LDA.l OWBonkPrizeTable[$13].loot
		JMP .done
	+ CMP.w #$28 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Maze, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$2A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$14].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$15].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HauntedGroveItem, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$2B : BNE +
		LDA.l OWBonkPrizeTable[$16].loot
		JMP .done
	+ CMP.w #$2E : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$17].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$18].loot
			JMP .done
	+ CMP.w #$30 : BNE +
		LDA $22 : CMP.w #512 : !BGE ++
			%GetPossiblyEncryptedItem(HeartPiece_Desert, HeartPieceOutdoorValues)
			JMP .done
		++
			%GetPossiblyEncryptedItem(BombosItem, SpriteItemValues)
			JMP .done
	+ CMP.w #$32 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$19].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$1A].loot
			JMP .done
	+ CMP.w #$35 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Lake, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$3B : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Swamp, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$42 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1B].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$4A : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Cliffside, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$51 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1C].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$1D].loot
			JMP .done
	+ CMP.w #$54 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1E].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$1F].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$20].loot
			JMP .done
	+ CMP.w #$55 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$21].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$22].loot
			JMP .done
	+ CMP.w #$56 : BNE +
		LDA.l OWBonkPrizeTable[$23].loot
		JMP .done
	+ CMP.w #$5B : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$24].loot
			JMP .done
		++
			%GetPossiblyEncryptedItem(HeartPiece_Pyramid, HeartPieceOutdoorValues)
			JMP .done
	+ CMP.w #$5E : BNE +
		LDA.l OWBonkPrizeTable[$25].loot
		JMP .done
	+ CMP.w #$68 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Digging, HeartPieceOutdoorValues)
		JMP .done
	+ CMP.w #$6E : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$26].loot
			JMP .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$27].loot
			JMP .done
		++
			LDA.l OWBonkPrizeTable[$28].loot
			JMP .done
	+ CMP.w #$74 : BNE +
		LDA.l OWBonkPrizeTable[$29].loot
		JMP .done
	+ CMP.w #$81 : BNE +
		%GetPossiblyEncryptedItem(HeartPiece_Zora, HeartPieceOutdoorValues)
		JMP .done
	+
	LDA.w #$0017 ; default to a normal hp
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
;$03 - HeartPiece_Spectacle
;$05 - HeartPiece_Mountain_Warp
;$28 - HeartPiece_Maze
;$30 - HeartPiece_Desert
;$35 - HeartPiece_Lake
;$3B - HeartPiece_Swamp
;$42 - HeartPiece_Cliffside - not really but the gfx load weird otherwise
;$4A - HeartPiece_Cliffside
;$5B - HeartPiece_Pyramid
;$68 - HeartPiece_Digging
;$81 - HeartPiece_Zora
;--------------------------------------------------------------------------------
LoadHeartContainerRoomValue:
LoadBossValue:
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #200 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_ArmosKnights, HeartContainerBossValues)
		JMP .done
	+ CMP.w #51 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Lanmolas, HeartContainerBossValues)
		JMP .done
	+ CMP.w #7 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Moldorm, HeartContainerBossValues)
		JMP .done
	+ CMP.w #90 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_HelmasaurKing, HeartContainerBossValues)
		JMP .done
	+ CMP.w #6 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Arrghus, HeartContainerBossValues)
		JMP .done
	+ CMP.w #41 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Mothula, HeartContainerBossValues)
		JMP .done
	+ CMP.w #172 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Blind, HeartContainerBossValues)
		JMP .done
	+ CMP.w #222 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Kholdstare, HeartContainerBossValues)
		JMP .done
	+ CMP.w #144 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Vitreous, HeartContainerBossValues)
		JMP .done
	+ CMP.w #164 : BNE +
		%GetPossiblyEncryptedItem(HeartContainer_Trinexx, HeartContainerBossValues)
		JMP .done
	+
	LDA.w #$003E ; default to a normal boss heart
	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
RTL
;--------------------------------------------------------------------------------
CheckIfBossRoom:
;--------------------------------------------------------------------------------
; Carry set if we're in a boss room, unset otherwise.
;--------------------------------------------------------------------------------
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #200 : BEQ .done
	CMP.w #51 : BEQ .done
	CMP.w #7 : BEQ .done
	CMP.w #90 : BEQ .done
	CMP.w #6 : BEQ .done
	CMP.w #41 : BEQ .done
	CMP.w #172 : BEQ .done
	CMP.w #222 : BEQ .done
	CMP.w #144 : BEQ .done
	CMP.w #164 : BEQ .done
	CLC
	.done
+	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
;#200 - Eastern Palace - Armos Knights
;#51 - Desert Palace - Lanmolas
;#7 - Tower of Hera - Moldorm
;#32 - Agahnim's Tower - Agahnim I
;#90 - Palace of Darkness - Helmasaur King
;#6 - Swamp Palace - Arrghus
;#41 - Skull Woods - Mothula
;#172 - Thieves' Town - Blind
;#222 - Ice Palace - Kholdstare
;#144 - Misery Mire - Vitreous
;#164 - Turtle Rock - Trinexx
;#13 - Ganon's Tower - Agahnim II
;#0 - Pyramid of Power - Ganon
;--------------------------------------------------------------------------------
;JSL $06DD40 ; DashKey_Draw
;JSL $06DBF8 ; Sprite_PrepAndDrawSingleLargeLong
;JSL $06DC00 ; Sprite_PrepAndDrawSingleSmallLong ; draw first cell correctly
;JSL $00D51B ; GetAnimatedSpriteTile
;JSL $00D52D ; GetAnimatedSpriteTile.variable
;================================================================================
HeartPieceGetPlayer:
{
	PHY
	LDA $1B : BNE +
		BRL .outdoors
	+

	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $A0 ; these are all decimal because i got them that way
	CMP.w #135 : BNE +
		LDA StandingKey_Hera_Player
		BRL .done
	+ CMP.w #200 : BNE +
		LDA HeartContainer_ArmosKnights_Player
		BRL .done
	+ CMP.w #51 : BNE +
		LDA HeartContainer_Lanmolas_Player
		BRL .done
	+ CMP.w #7 : BNE +
		LDA HeartContainer_Moldorm_Player
		BRL .done
	+ CMP.w #90 : BNE +
		LDA HeartContainer_HelmasaurKing_Player
		BRL .done
	+ CMP.w #6 : BNE +
		LDA HeartContainer_Arrghus_Player
		BRL .done
	+ CMP.w #41 : BNE +
		LDA HeartContainer_Mothula_Player
		BRL .done
	+ CMP.w #172 : BNE +
		LDA HeartContainer_Blind_Player
		BRL .done
	+ CMP.w #222 : BNE +
		LDA HeartContainer_Kholdstare_Player
		BRL .done
	+ CMP.w #144 : BNE +
		LDA HeartContainer_Vitreous_Player
		BRL .done
	+ CMP.w #164 : BNE +
		LDA HeartContainer_Trinexx_Player
		BRL .done
	+ CMP.w #225 : BNE +
		LDA HeartPiece_Forest_Thieves_Player
		BRL .done
	+ CMP.w #226 : BNE +
		LDA HeartPiece_Lumberjack_Tree_Player
		BRL .done
	+ CMP.w #234 : BNE +
		LDA HeartPiece_Spectacle_Cave_Player
		BRL .done
	+ CMP.w #283 : BNE +
		LDA $22 : XBA : AND.w #$0001 ; figure out where link is
		BNE ++
			LDA HeartPiece_Circle_Bushes_Player
			BRL .done
		++
			LDA HeartPiece_Graveyard_Warp_Player
			BRL .done
	+ CMP.w #288 : BNE +
		LDA.l OWBonkPrizeTable[$2A].mw_player
		BRL .done
	+ CMP.w #294 : BNE +
		LDA HeartPiece_Mire_Warp_Player
		BRL .done
	+ CMP.w #295 : BNE +
		LDA HeartPiece_Smith_Pegs_Player
		BRL .done
	LDA.w #$0000
	BRL .done

	.outdoors
	PHP
	REP #$20 ; set 16-bit accumulator
	LDA $8A
	CMP.w #$00 : BNE +
		LDA.l OWBonkPrizeTable[$00].mw_player
		BRL .done
	+ CMP.w #$03 : BNE +
		LDA $22 : CMP.w #1890 : !BLT ++
			LDA HeartPiece_Spectacle_Player
			BRL .done
		++
			LDA EtherItem_Player
			BRL .done
	+ CMP.w #$05 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$01].mw_player
			BRL .done
		++
			LDA HeartPiece_Mountain_Warp_Player
			BRL .done
	+ CMP.w #$0A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$02].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$03].mw_player
			BRL .done
	+ CMP.w #$10 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$04].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$05].mw_player
			BRL .done
	+ CMP.w #$11 : BNE +
		LDA.l OWBonkPrizeTable[$06].mw_player
		BRL .done
	+ CMP.w #$12 : BNE +
		LDA.l OWBonkPrizeTable[$07].mw_player
		BRL .done
	+ CMP.w #$13 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$08].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$09].mw_player
			BRL .done
	+ CMP.w #$15 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0A].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0B].mw_player
			BRL .done
	+ CMP.w #$18 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0C].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0D].mw_player
			BRL .done
	+ CMP.w #$1A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$0E].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$0F].mw_player
			BRL .done
	+ CMP.w #$1B : BNE +
		LDA.l OWBonkPrizeTable[$11].mw_player
		BRL .done
	+ CMP.w #$1D : BNE +
		LDA.l OWBonkPrizeTable[$12].mw_player
		BRL .done
	+ CMP.w #$1E : BNE +
		LDA.l OWBonkPrizeTable[$13].mw_player
		BRL .done
	+ CMP.w #$28 : BNE +
		LDA HeartPiece_Maze_Player
		BRL .done
	+ CMP.w #$2A : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$14].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$15].mw_player
			BRL .done
		++
			LDA HauntedGroveItem_Player
			BRL .done
	+ CMP.w #$2B : BNE +
		LDA.l OWBonkPrizeTable[$16].mw_player
		BRL .done
	+ CMP.w #$2E : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$17].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$18].mw_player
			BRL .done
	+ CMP.w #$30 : BNE +
		LDA $22 : CMP.w #512 : !BGE ++
			LDA HeartPiece_Desert_Player
			BRL .done
		++
			LDA BombosItem_Player
			BRL .done
	+ CMP.w #$32 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$19].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$1A].mw_player
			BRL .done
	+ CMP.w #$35 : BNE +
		LDA HeartPiece_Lake_Player
		BRL .done
	+ CMP.w #$3B : BNE +
		LDA HeartPiece_Swamp_Player
		BRL .done
	+ CMP.w #$42 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1B].mw_player
			BRL .done
		++
			LDA HeartPiece_Cliffside_Player
			BRL .done
	+ CMP.w #$4A : BNE +
		LDA HeartPiece_Cliffside_Player
		BRL .done
	+ CMP.w #$51 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1C].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$1D].mw_player
			BRL .done
	+ CMP.w #$54 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$1E].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$1F].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$20].mw_player
			BRL .done
	+ CMP.w #$55 : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$21].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$22].mw_player
			BRL .done
	+ CMP.w #$56 : BNE +
		LDA.l OWBonkPrizeTable[$23].mw_player
		BRL .done
	+ CMP.w #$5B : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$24].mw_player
			BRL .done
		++
			LDA HeartPiece_Pyramid_Player
			BRL .done
	+ CMP.w #$5E : BNE +
		LDA.l OWBonkPrizeTable[$25].mw_player
		BRL .done
	+ CMP.w #$68 : BNE +
		LDA HeartPiece_Digging_Player
		BRL .done
	+ CMP.w #$6E : BNE +
		LDA.w $0ED0,X : AND.w #$00FF : CMP.w #$0010 : BNE ++
			LDA.l OWBonkPrizeTable[$26].mw_player
			BRL .done
		++ CMP.w #$0008 : BNE ++
			LDA.l OWBonkPrizeTable[$27].mw_player
			BRL .done
		++
			LDA.l OWBonkPrizeTable[$28].mw_player
			BRL .done
	+ CMP.w #$74 : BNE +
		LDA.l OWBonkPrizeTable[$29].mw_player
		BRL .done
	+ CMP.w #$81 : BNE +
		LDA HeartPiece_Zora_Player
		BRL .done
	+
	LDA.w #$0000

	.done
	AND.w #$00FF ; the loads are words but the values are 1-byte so we need to clear the top half of the accumulator - no guarantee it was 8-bit before
	PLP
	PLY
RTL
}
;--------------------------------------------------------------------------------
HeartPieceSetRedraw:
	PHY
		LDY.b #$0F
		.next
		LDA.w $0DD0,Y : BEQ ++
			LDA.w $0E20,Y : CMP.b #$EB : BEQ + ; heart piece
			CMP.b #$E4 : BEQ + ; enemy key drop
			CMP.b #$3B : BEQ + ; bonk item (book/key)
			CMP.b #$E5 : BEQ + ; enemy big key drop
			CMP.b #$E7 : BEQ + ; mushroom item
			CMP.b #$E9 : BEQ + ; powder item
			BRA ++
				+ LDA.b #$01 : STA.w !SPRITE_REDRAW,Y
		++ DEY : BPL .next
	PLY
RTL
HeartPieceGetRedraw:
	PHY
		LDY.b #$0F
		.next
		LDA.w $0DD0,Y : BEQ ++
			LDA.w $0E20,Y : CMP.b #$EB : BEQ + ; heart piece
			CMP.b #$E4 : BEQ + ; enemy key drop
			CMP.b #$3B : BEQ + ; bonk item (book/key)
			CMP.b #$E5 : BEQ + ; enemy big key drop
			CMP.b #$E7 : BEQ + ; mushroom item
			CMP.b #$E9 : BEQ + ; powder item
			BRA ++
				+ LDA.w !SPRITE_REDRAW,Y : BEQ ++
					PLY : SEC : RTL
		++ DEY : BPL .next
	PLY
CLC : RTL
