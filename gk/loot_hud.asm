UpdateLootHUD:
	PHP
	REP #$30
	PHX : PHY
	SEP #$30

	LDA.l ShowLootInHUD : BEQ .setting_off
	LDA.b IndoorsFlag : BEQ .done

	REP #$30
	LDA.b $00 : PHA
	LDA.b $02 : PHA
	LDA.b $04 : PHA
	LDA.b $06 : PHA
	LDA.b $08 : PHA
	LDA.b $0E : PHA

	JSL DetectLinksSection
	INC A
	XBA
	ASL A : ASL A : ASL A : ASL A
	ORA.b RoomIndex
	JSL CheckLoot

	ASL A : TAX
	LDA.l HUDLootTypeIcons, X
	STA.w EnemyDropIndicator

	REP #$30
	PLA : STA.b $0E
	PLA : STA.b $08
	PLA : STA.b $06
	PLA : STA.b $04
	PLA : STA.b $02
	PLA : STA.b $00
	BRA .done

.setting_off
	JSL SetupEnemyDropIndicator

.done
	REP #$30
	PLY : PLX
	PLP
	RTL
