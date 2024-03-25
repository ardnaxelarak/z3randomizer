;================================================================================
; Randomize Book of Mudora
;--------------------------------------------------------------------------------
LoadLibraryItemGFX:
    INC.w SkipBeeTrapDisguise
    LDA.l LibraryItem_Player : STA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    %GetPossiblyEncryptedItem(LibraryItem, SpriteItemValues)
    STA.w SprSourceItemId, X
    JML RequestStandingItemVRAMSlot
;--------------------------------------------------------------------------------
DrawLibraryItemGFX:
    PHA
    LDA.w SprItemReceipt, X
    JSL DrawPotItem
    PLA
RTL
;--------------------------------------------------------------------------------
SetLibraryItem:
    LDY.w SprItemReceipt, X
    JSL ItemSet_Library ; contains thing we wrote over
RTL
;--------------------------------------------------------------------------------

;0x0087 - Hera Room w/key
;================================================================================
; Randomize Bonk Keys
;--------------------------------------------------------------------------------
LoadBonkItemGFX:
    LDA.b #$08 : STA.w SpriteOAMProp, X ; thing we wrote over
LoadBonkItemGFX_inner:
    INC.w SkipBeeTrapDisguise
    JSR LoadBonkItem_Player : STA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_SPRITEITEM_PLAYER_ID
    JSR LoadBonkItem
    STA.w SprSourceItemId, X
    JSL RequestStandingItemVRAMSlot
RTL
;--------------------------------------------------------------------------------
DrawBonkItemGFX: 
    PHA
    LDA.w SprRedrawFlag, X : BEQ .skipInit
        JSL LoadBonkItemGFX_inner
        LDA.w SprRedrawFlag, X : CMP.b #$02 : BEQ .skipInit
        BRA .done ; don't draw on the init frame

    .skipInit
    LDA.w SprItemReceipt,X
    JSL DrawPotItem

    .done
    PLA
RTL
;--------------------------------------------------------------------------------
GiveBonkItem:
    LDA.w SprItemMWPlayer, X : STA.l !MULTIWORLD_ITEM_PLAYER_ID
    LDA.w SprItemReceipt, X
    JSR AbsorbKeyCheck : BCC .notKey
    .key
    PHY : LDY.b #$24 : JSL AddInventory : PLY ; do inventory processing for a small key
    LDA.l CurrentSmallKeys : INC A : STA.l CurrentSmallKeys
    LDA.b #$2F : JSL Sound_SetSfx3PanLong
    INC.w UpdateHUDFlag
RTL
    .notKey
    PHY : TAY : JSL Link_ReceiveItem : PLY
RTL
;--------------------------------------------------------------------------------
LoadBonkItem:
	LDA.b RoomIndex ; check room ID - only bonk keys in 2 rooms so we're just checking the lower byte
	CMP.b #$73 : BNE + ; Desert Bonk Key
    	LDA.l BonkKey_Desert
		BRA ++
	+ : CMP.b #$8C : BNE + ; GTower Bonk Key
    	LDA.l BonkKey_GTower
		BRA ++
	+
		LDA.b #$24 ; default to small key
	++
RTS
;--------------------------------------------------------------------------------
LoadBonkItem_Player:
    LDA.b RoomIndex ; check room ID - only bonk keys in 2 rooms so we're just checking the lower byte
    CMP.b #$73 : BNE + ; Desert Bonk Key
        LDA.l BonkKey_Desert_Player
        BRA ++
    + : CMP.b #$8C : BNE + ; GTower Bonk Key
        LDA.l BonkKey_GTower_Player
        BRA ++
    +
        LDA.b #$00
    ++
RTS
;--------------------------------------------------------------------------------
AbsorbKeyCheck:
    PHA
    CMP.b #$24 : BEQ .key
    CMP.b #$A0 : BCC .not_key
    CMP.b #$B0 : BCS .not_key
        AND.b #$0F : ASL
        CMP.w DungeonID : BNE .not_key
            .key
            PLA
            SEC
            RTS
    .not_key
    PLA
    CLC
RTS
