;--------------------------------------------------------------------------------
EndRainState:
	LDA.l InitProgressIndicator : BIT.b #$80 : BEQ + ; check for instant post-aga
		LDA.l InitLumberjackOW : STA.l OverworldEventDataWRAM+$02
		LDA.b #$03
		BRA ++
	+
	LDA.b #$02
	++
	STA.l ProgressIndicator

	JSL SetEscapeAssist
RTL
;--------------------------------------------------------------------------------
