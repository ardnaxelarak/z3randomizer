;================================================================================
; Randomize Tablets
;--------------------------------------------------------------------------------
ItemSet_EtherTablet:
	PHA : LDA.l NpcFlags+1 : ORA.b #$01 : STA.l NpcFlags+1 : PLA
RTS
;--------------------------------------------------------------------------------
ItemSet_BombosTablet:
	PHA : LDA.l NpcFlags+1 : ORA.b #$02 : STA.l NpcFlags+1 : PLA
RTS
;--------------------------------------------------------------------------------
ItemCheck_EtherTablet:
	LDA.l NpcFlags+1 : AND.b #$01
RTL
;--------------------------------------------------------------------------------
ItemCheck_BombosTablet:
	LDA.l NpcFlags+1 : AND.b #$02
RTL
;--------------------------------------------------------------------------------
SetTabletItemFlag:
        PHA
                LDA.b OverworldIndex : CMP.b #$03 : BEQ .ether ; if we're on the map where ether is, we're the ether tablet
                .bombos
                JSR ItemSet_BombosTablet : BRA .done
                .ether
                JSR ItemSet_EtherTablet
                .done
        PLA
RTS
;--------------------------------------------------------------------------------
SpawnTabletItem:
    JSL HeartPieceGetPlayer : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    JSL LoadOutdoorValue
    JSL AttemptItemSubstitution
    JSL ResolveLootIDLong
    PHA
    LDA.b #$EB : STA.l MiniGameTime
    JSL Sprite_SpawnDynamically
    PLA
    STA.w SpriteID,Y
    LDA.b #$01 : STA.w SprRedrawFlag, Y

    LDA.b LinkPosX   : STA.w SpritePosXLow, Y
    LDA.b LinkPosX+1 : STA.w SpritePosXHigh, Y
    LDA.b LinkPosY   : STA.w SpritePosYLow, Y
    LDA.b LinkPosY+1 : STA.w SpritePosYHigh, Y
    LDA.b #$00 : STA.w SpriteLayer, Y
    LDA.b #$7F : STA.w SpriteZCoord, Y ; spawn WAY up high
RTL
;--------------------------------------------------------------------------------
MaybeUnlockTabletAnimation:
	PHA : PHP
		JSL IsMedallion : BCC +
                        JSR SetTabletItemFlag
			STZ.w MedallionFlag ; disable falling-medallion mode
			STZ.w ForceSwordUp ; release link from item-up pose
			LDA.b #$00 : STA.b LinkState ; set link to ground state

			REP #$20 ; set 16-bit accumulator
				LDA.b OverworldIndex : CMP.w #$0030 : BNE ++ ; Desert
					SEP #$20 ; set 8-bit accumulator
					LDA.b #$02 : STA.b LinkDirection ; face link forward
					LDA.b #$3C : STA.b LinkIncapacitatedTimer ; lock link for 60f
				++
			SEP #$20 ; set 8-bit accumulator
		+
	PLP : PLA
RTL
;--------------------------------------------------------------------------------
IsMedallion:
	REP #$20 ; set 16-bit accumulator
	LDA.b OverworldIndex
	CMP.w #$03 : BNE + ; Death Mountain
		LDA.b LinkPosX : CMP.w #1890 : !BGE ++
			SEC
			BRA .done
		++
		BRA .false
	+ CMP.w #$30 : BNE + ; Desert
		LDA.b LinkPosX : CMP.w #512 : !BLT ++
			SEC
			BRA .done
		++
	+
	.false
	CLC
	.done
	SEP #$20 ; set 8-bit accumulator
RTL
;--------------------------------------------------------------------------------
LoadNarrowObject:
	LDA.l SpriteProperties_standing_width, X : STA.b ($92), Y ; AddReceiveItem.wide_item_flag?
RTL
;--------------------------------------------------------------------------------
CheckTabletItem:
;--------------------------------------------------------------------------------
; Zero flag set = Item not collected
; Zero flag clear = Item  collected
;--------------------------------------------------------------------------------
        JSL IsMedallion : BCS .tablet
        PHX
                LDA.b 5,S : TAX : LDA.w SpriteSpawnStep, X : BEQ .vanilla-1
        PLX
		.bonk_item
        LDA.b #$00
RTL
                PLX
                .vanilla
                LDA.l OverworldEventDataWRAM, X : AND.b #$40 ; What we wrote over
                RTL
        .tablet
        TDC
RTL
;--------------------------------------------------------------------------------
SaveTabletItem:
    LDA.b 4,S : TAY : LDA.w SpriteSpawnStep,Y : BEQ .normal_behavior
	.bonk_item
    ORA.l OverworldEventDataWRAM, X : STA.l OverworldEventDataWRAM, X
RTL

    .normal_behavior
    LDA.l OverworldEventDataWRAM, X : ORA.b #$40 : STA.l OverworldEventDataWRAM, X
RTL
