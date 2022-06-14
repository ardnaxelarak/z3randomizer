;================================================================================
; Mantle Object Changes
;--------------------------------------------------------------------------------
Mantle_CorrectPosition:
	LDA.l ProgressFlags : AND.b #$04 : BNE .spawnOpen
	LDA.l StartingEntrance : CMP.b #$04 : BNE +
		.spawnOpen
		LDA.b #$0A : STA $0D10, X ; just spawn it off to the side where we know it should be
		LDA.b #$03 : STA $0D30, X
		LDA.b #$90 : STA $0ED0, X
	+
	LDA $0D00, X : !ADD.b #$03 ; thing we did originally
RTL
;--------------------------------------------------------------------------------

MirrorScrollSpawnZelda:
	SEP #$20
	LDA.l StartingEntrance : CMP.b #$02 : BNE +
		LDA.l MirrorEquipment : CMP.b #$01 : BNE +
		    REP #$20
		    PLA ; remove JSL 16 bits
			PEA.w Underworld_LoadSpawnEntrance-1
			RTL
	+ REP #$20
	; what we replaced
	LDA.w $010E : AND.w #$00FF
RTL