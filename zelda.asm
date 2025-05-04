;--------------------------------------------------------------------------------
EndRainState:
        LDA.l InitProgressIndicator : BIT.b #$80 : BNE + ; check for instant post-aga
                LDA.b #$02 : STA.l ProgressIndicator
                RTL
	+
        LDA.b #$03 : STA.l ProgressIndicator
        LDA.l InitLumberjackOW : STA.l OverworldEventDataWRAM+$02
RTL
;--------------------------------------------------------------------------------
