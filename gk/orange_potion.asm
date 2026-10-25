CheckOrangePotion:
	LDA.l BottleContents, X
	CMP.b #$01
	BEQ .orange

	; return to vanilla behavior
	CMP.b #$00
	RTL

.orange
	LDA.l InfiniteMagic
	BNE .nope

	LDA.b #$02
	STA.l BottleContents, X

	STZ.w $0301

	LDA.b #$01
	STA.l InfiniteMagic

	JSL RebuildHUD_update_long
	LDA.b #$00
	RTL

.nope
	JSL Sound_SetSfxPanWithPlayerCoords
	ORA.b #$3C
	STA.w SFX2
	LDA.b #$00
	RTL
