;================================================================================
; Randomize Zora King
;--------------------------------------------------------------------------------
LoadZoraKingItemGFX:
	LDA.l ZoraItem_Player : STA !MULTIWORLD_SPRITEITEM_PLAYER_ID
    LDA.l $1DE1C3 ; location randomizer writes zora item to
	JML RequestSlottedTile
;--------------------------------------------------------------------------------
ZoraSplashGfxFix:
	PHA : PHX : PHY : SEP #$30
		; below should be set to the index used for Arrghus/Zora Splash
		; FreeOWGraphics in dynamic_si_vram.asm, whatever index is $9960
		; this makes it so the first gfx that is loading is AFTER the splash
		LDA.b #$00 : STA.w DynamicDropGFXIndex 
		JSL LoadCommonSprites_long
	REP #$30 : PLY : PLX : PLA
	RTL
;--------------------------------------------------------------------------------
JumpToSplashItemTarget:
	LDA $0D90, X
	CMP.b #$FF : BNE + : JML.l SplashItem_SpawnSplash : +
	CMP.b #$00 : JML.l SplashItem_SpawnOther
;--------------------------------------------------------------------------------