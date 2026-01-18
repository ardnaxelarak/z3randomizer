;--------------------------------------------------------------------------------
SetItemRiseTimer:
	LDA.w ItemReceiptMethod : CMP.b #$01 : BNE .not_from_chest
		LDA.b #$38 : STA.w AncillaTimer, X
		RTL

	.not_from_chest
	JSL ItemIsJunk
	BEQ .default

	.junk
	LDA.l JunkItemTimer : AND.b #$3F : STA.w AncillaTimer, X
	RTL

	.default
	TYA : STA.w AncillaTimer, X ; What we wrote over
	RTL
;--------------------------------------------------------------------------------
ItemIsJunk:
	PHX
	LDA.l JunkItemTimer : BIT.b #$3F : BEQ .not_junk
	BIT.b #$80 : BNE .check
	LDA.l !MULTIWORLD_ITEM_PLAYER_ID : BNE .check
	LDA.l !MULTIWORLD_RECEIVING_ITEM : BNE .check
	BRA .not_junk

.check
	LDA.w AncillaGet, X
	TAX
	LDA.l JunkTable, X
	PLX
	CMP.b #$00
	RTL

.not_junk
	PLX
	LDA.b #$00
	RTL

;--------------------------------------------------------------------------------
; A = item id being collected
ItemGetAlternateSFX:
	PEA.w $C567 ; SNES to RTS to in bank 08
	LDA.w AncillaGet, X : CMP.b #$4A : BNE +
		; collecting pre-activated flute
		LDA.b #$13 : JML Ancilla_SFX2_Near
	+
	JSL ItemIsJunk : BEQ .normal
		LDA.b #$3B : JML Ancilla_SFX3_Near
	.normal
		LDA.b #$0F : JML Ancilla_SFX3_Near
;--------------------------------------------------------------------------------
; A = item id being collected
ItemGetOverworldAlternateSFX:
	CPY.b #$4A : BNE +
		; pre-activated flute
		JSL Sound_SetSfxPanWithPlayerCoords : ORA.b #$13 : STA.w SFX2
		RTL
	+
	JSL ItemIsJunk : BEQ .normal
	.junk
		JSL Sound_SetSfxPanWithPlayerCoords : ORA.b #$3B : STA.w SFX3
		RTL
	.normal
		JSL Sound_SetSfxPanWithPlayerCoords : ORA.b #$0F : STA.w SFX3
		RTL
;--------------------------------------------------------------------------------
