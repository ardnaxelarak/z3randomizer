CheckSwitchMap:
	SEP #$20
	LDA.b $F6
	AND.b #$30
	BNE +

	; what we wrote over
	REP #$20
	LDA.w $8AF5E9, X
	AND.w #$000F
	CLC : ADC.b $00
	RTL

+	PHA
	TXA
	ASL A
	TAX
	PLA
	BIT.b #$20
	BNE +
	INX
+	LDA.l DungeonMapData.prev, X
	STA.w DungeonID

	LDA.b #$04
	STA.w $0200
	REP #$20
	LDA.w #$0000
	RTL

DungeonMapSwitch_Submodule:
;	LDA.b $9B
;	STA.l $7EC229

	JSL $80893D
	JSL $80833F
;	LDA.l $7EC229
;	STA.b $9B

	LDA.b #$09
	STA.b $14
	STA.w $0710

	LDA.b #$01
	STA.w $0200
	STA.w $020D
	STZ.w $021B
	STZ.w $021C
	STZ.b $06
	STZ.b $07

	LDA.w DungeonID
	ASL A
	TAX
	LDA.l DungeonMapData.floor, X
	STA.b $A4

	REP #$20
	JML $98BC8A

SkipMapSprites:
	STZ.b $00
	STZ.b $0E

	LDA.w $0200
	CMP.b #$04
	BNE +
		JML $8AEAFC
+	LDA.l $7EC22A
	CMP.w DungeonID
	BEQ +
		JML $8AEAF3
+	JML $8AEADE

CacheCurrentDungeon:
	STA.l $7EC206
	SEP #$20
	LDA.w DungeonID
	STA.l $7EC22A
	LDA.b $A4
	STA.l $7EC22B
	REP #$20
	RTL

RestoreCurrentDungeon:
	LDA.b #$F3
	STA.w $012C ; what we wrote over
	LDA.l $7EC22A
	STA.w DungeonID
	LDA.l $7EC22B
	STA.b $4A
	RTL

RestoreDungeonMapFloorIndex:
	STZ.w $020F
	LDA.w $021B
	STA.b $07
	STZ.b $06
	LDA.b $0A
	AND.b #$08
	RTL
