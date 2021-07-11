;================================================================================
; Spawn Zelda (or not)
;--------------------------------------------------------------------------------
SpawnZelda:
	LDA.l $7EF3CC : CMP #$08 : BEQ + ; don't spawn if dwarf is present
	CMP #$07 : BEQ + ; don't spawn if frog is present
	CMP #$0C : BEQ + ; don't spawn if purple chest is present
		CLC
	+ RTL
;--------------------------------------------------------------------------------
EndRainState:
	LDA $7EF3C5 : CMP.b #$02 : !BGE ++ ; skip if past escape already
		LDA.l EscapeAssist : AND #$44
		CMP #$04 : BNE + : LDA #$00 : STA !INFINITE_MAGIC : +
		CMP #$40 : BNE + : STA !INFINITE_MAGIC : +
		LDA.l EscapeAssist : AND #$22
		CMP #$02 : BNE + : LDA #$00 : STA !INFINITE_BOMBS : +
		CMP #$20 : BNE + : STA !INFINITE_BOMBS : +
		LDA.l EscapeAssist : AND #$11
		CMP #$01 : BNE + : LDA #$00 : STA !INFINITE_ARROWS : +
		CMP #$10 : BNE + : STA !INFINITE_ARROWS : +

		LDA.l SpecialBombs : BEQ +
		LDA.l $7EF4A8 : BEQ +
		LDA #$01 : STA !INFINITE_BOMBS
		+
		LDA.b #$02 : STA $7EF3C5 ; end rain state
		JSL MaybeSetPostAgaWorldState
	++
RTL
;--------------------------------------------------------------------------------
