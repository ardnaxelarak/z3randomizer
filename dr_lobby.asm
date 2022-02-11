CheckDarkWorldSpawn:
	STA $A0 : STA $048E ; what we wrote over
	LDA.l OldManDarkWorld : CMP $A0 : BNE +
		SEP #$30
			LDA InvertedMode : BNE ++
				LDA.b #$40 : STA !DARK_WORLD : BRA +++
			++ LDA.b #$00 : STA !DARK_WORLD
		+++ REP #$30
	+ LDA.l DRFlags : AND #$0200 : BEQ + ; skip if the flag isn't set
	LDA.l $7EF357 : AND #$00FF : BNE + ; moon pearl?
	LDA.l LinksHouseDarkWorld : CMP $A0 : BEQ ++
	LDA.l SanctuaryDarkWorld : CMP $A0 : BEQ ++
	LDA.l OldManDarkWorld : CMP $A0 : BNE +
		++ SEP #$30 : LDA #$17 : STA $5D
		   INC $02E0 : LDA.b #$40 : STA !DARK_WORLD : REP #$30
+ RTL
