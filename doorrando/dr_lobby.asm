CheckDarkWorldSpawn:
PHP
	STA $A0 : STA $048E ; what we wrote over
	JSL SetDefaultWorld
	LDA.l LinksHouseDarkWorld : CMP.b $A0 : BEQ ++
	LDA.l SanctuaryDarkWorld : CMP.b $A0 : BEQ ++
	LDA.l OldManDarkWorld : CMP.b $A0 : BNE +
		++ SEP #$20 : LDA CurrentWorld : EOR.b #$40 : STA CurrentWorld
		LDA.l DRFlags+1 : AND #$02 : BEQ + ; skip if the flag isn't set
		LDA.l MoonPearlEquipment : BNE + ; moon pearl?
			LDA #$17 : STA $5D : INC $02E0
+ PLP : RTL

SetDefaultWorld:
PHP : SEP #$20
LDA.l InvertedMode : BEQ +
	LDA.b #$40
+ STA CurrentWorld
PLP : RTL
