pushpc
org $828C73
JSL EnterRoom
NOP

org $86C0AB
JSL CollectHeartPieceAndUpdate

org $86D1A8
JSL SetDeathFlagAndUpdate

pullpc

SetDeathFlagAndUpdate:
	JSL UpdateLootHUD
	JSL Sprite_ManuallySetDeathFlagUW
	RTL

CollectHeartPieceAndUpdate:
	JSL $85F018
	JSL UpdateLootHUD
	RTL

ClearLootHUD:
	LDA.b GameMode
	CMP.b #$07
	BNE UpdateLootHUD
;
	PHP
	REP #$20
	LDA.w #!BlankTile : STA.w EnemyDropIndicator
	PLP
	RTL

EnterRoom:
	; what we wrote over
	STZ.w $0200
	STZ.b $B0

; fall into UpdateLootHUD

UpdateLootHUD:
	PHP
	REP #$30
	PHX : PHY
	SEP #$30

	LDA.l HudItems.enabled : BEQ .setting_off
	LDA.b IndoorsFlag : BEQ .done

	REP #$30
	LDA.b $00 : PHA
	LDA.b $02 : PHA
	LDA.b $04 : PHA
	LDA.b $06 : PHA
	LDA.b $08 : PHA
	LDA.b $0E : PHA

	; if if door rando, check for section of supertile
	LDA.l DRMode
	BNE +

	; if not in door rando, check for section of supertile if we're not in a dungeon
	LDA.w DungeonID
	AND.w #$00FF
	CMP.w #$00FF
	BEQ +

	; just load the room id, we don't care about sections
	LDA.b RoomIndex
	BRA .check

+	; figure out section before checking
	JSL DetectLinksSection
	INC A
	XBA
	ASL A : ASL A : ASL A : ASL A
	ORA.b RoomIndex
.check
	JSL CheckHudLoot

	ASL A : TAX
	LDA.l HUDLootTypeIcons, X
	STA.w EnemyDropIndicator

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
