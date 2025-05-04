CheckDarkWorldSpawn:
PHP
	STA.b RoomIndex : STA.w RoomIndexMirror ; what we wrote over
	JSL SetDefaultWorld
	LDA.l LinksHouseDarkWorld : CMP.b RoomIndex : BEQ ++
	LDA.l SanctuaryDarkWorld : CMP.b RoomIndex : BEQ ++
	LDA.l OldManDarkWorld : CMP.b RoomIndex : BNE +
		++ SEP #$20 : LDA.l CurrentWorld : EOR.b #$40 : STA.l CurrentWorld
		LDA.l DRFlags+1 : AND.b #$02 : BEQ + ; skip if the flag isn't set
		LDA.l MoonPearlEquipment : BNE + ; moon pearl?
			LDA.b #$17 : STA.b LinkState : INC.w BunnyFlag
+ PLP : RTL

SetDefaultWorld:
PHP : SEP #$20
LDA.l FollowerTravelAllowed : CMP.b #$02 : BEQ .default
LDA.l FollowerIndicator : CMP.b #$04 : BNE .default
	LDA.l OldManRetrievalWorld : BRA +
.default
LDA.l InvertedMode : BEQ +
	LDA.b #$40
+ STA.l CurrentWorld
PLP : RTL
