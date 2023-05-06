;================================================================================
; Randomize Catfish
;--------------------------------------------------------------------------------
LoadCatfishItemGFX:
	LDA.l CatfishItem_Player : STA !MULTIWORLD_SPRITEITEM_PLAYER_ID
	LDA.l $1DE185 ; location randomizer writes catfish item to
	JML RequestSlottedTile
;--------------------------------------------------------------------------------
DrawThrownItem:
	LDA $8A : CMP.b #$81 : BNE .catfish
	
	.zora
	LDA.l $1DE1C3 ; location randomizer writes zora item to
	BRA .draw
	
	.catfish
	LDA.l $1DE185 ; location randomizer writes catfish item to
	
	.draw
	JML DrawSlottedTile
;--------------------------------------------------------------------------------
MarkThrownItem:
	PHA

	LDA $8A : CMP.b #$81 : BNE .catfish

	.zora
	JSL.l ItemSet_ZoraKing
	LDA ZoraItem_Player : STA !MULTIWORLD_ITEM_PLAYER_ID
	BRA .done

	.catfish
	JSL.l ItemSet_Catfish
	LDA CatfishItem_Player : STA !MULTIWORLD_ITEM_PLAYER_ID

	.done
	PLA
	JSL Link_ReceiveItem ; thing we wrote over
RTL
;--------------------------------------------------------------------------------