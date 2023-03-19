IFrameData:
	db $00, $14, $28
CalcIFrames:
	LDA.l ArmorEquipment
	PHX : TAX
	LDA.l MaximumHealth : LSR #3
	CLC : ADC.l IFrameData, X
	EOR.b #$FF
	CLC : ADC.b #$3E
	PLX
	STA.w $031F
	RTL

SetBombTimer:
	JSL GetRandomInt
	STA.w $039F, X
	RTL

SetDashTimer:
	JSL GetRandomInt
	AND.b #$1F
	STA.w $0374
	JSL GetRandomInt
	AND.b #$0F
	CLC : ADC.w $0374
	STA.w $0374
	RTL

ProcessFlute:
	LDA.b $1B
	BNE .play_and_leave ; indoors
	LDA.b $10
	CMP.b #$0B
	BEQ .play_and_leave ; special overworld
	JSL GetRandomInt
	BIT #$08
	BNE .cucco
.normal
	LDA.b $8A
	AND.b #$40
	BNE .play_and_leave ; dark world
	JSR PlayDuck
	SEC : RTL           ; light world; play duck sound and resume normal behavior
.cucco
	JSR PlayCluck       ; outdoors; play cucco sound
	LDA.b #$01
	STA.l CuccoStormer  ; turn on cucco storm
	CLC : RTL           ; do not summon duck
.play_and_leave
	JSR PlayDuck
	CLC : RTL

PlayDuck:
	LDA.b #$13
	STA.w $0CF8
	JSL Sound_SetSfxPanWithPlayerCoords
	ORA.w $0CF8
	STA.w $012E
	RTS

PlayCluck:
	LDA.b #$30
	STA.w $0CF8
	JSL Sound_SetSfxPanWithPlayerCoords
	ORA.w $0CF8
	STA.w $012E
	RTS

FluteMap:
	LDA.b #$00
	STA.l CuccoStormer ; turn off cuccos
	LDA.b #$0E
	STA.b $10
	RTL

UseShovel:
	LDA.b $1B
	BEQ .normal
.indoors
	REP #$20
	LDA.w #$0200
	STA.w $03F5
	SEP #$20
	CLC
	RTL
.normal
	LDA.l $07A310
	STA.b $3D
	STZ.w $030D
	STZ.w $0300
	SEC
	RTL

BunnyThrowPot:
	LDA.b #$02
	JSL $068156
	LDA.b $3B
	AND.b #$7F
	STA.b $3B
	RTL

SwordSwingDelay:
	LDA.l SwordEquipment : CMP.b #$02 : !BLT .normal
	                       CMP.b #$FF : BEQ .normal
	CPX.b #$04 : BEQ .section_4
	CPX.b #$05 : BEQ .section_5
	CPX.b #$06 : BNE .normal
.section_6
	LDA.l SwordEquipment : CMP.b #$04 : !BGE .normal
	BRA .add_one
.section_5
	LDA.l SwordEquipment : CMP.b #$02 : !BGE .normal
	BRA .add_one
.section_4
	LDA.l SwordEquipment : CMP.b #$03 : !BGE .normal
.add_one
	LDA.l $079CAF, X
	STA.b $3D
	INC
	RTL
.normal
	LDA.l $079CAF, X
	STA.b $3D
	RTL

MaybeRecoil:
	LDA.w $0E20, Y
	CMP.b #$09 ; skip recoil on the giant 'dorm
	BEQ .done
	LDA.l $088E75, X
	STA.w $0F40, Y
	LDA.l $088E79, X
	STA.w $0F30, Y
.done
	RTL

MaybeRecoil2:
	LDA.w $0E20, X
	CMP.b #$09
	BEQ .moldorm
	LDA.b $00
	EOR.b #$FF
	INC
	STA.w $0F30, X
	LDA.b $01
	EOR.b #$FF
	INC
	STA.w $0F40, X
	RTL
.moldorm ; skip recoil on the giant 'dorm and unstun
	STZ.w $0B58, X
	STZ.w $0D90, X
	RTL

CheckMoldormRepel:
	CMP.b #$09
	BNE .not_moldorm
	LDA.w $0D90, X
	BEQ .repel
	LDA.w $0B58, X
	BEQ .repel
.no_repel
	LDA.b #$01
	SEC : RTL
.repel
	LDA.b #$00
	SEC : RTL
.not_moldorm
	CLC : RTL

SetLanmolaVelocity:
	LDA.b $00
	ASL
	STA.w $0D40, X
	LDA.b $01
	ASL
	STA.w $0D50, X
	RTL

CheckMushroom:
	PHP
	SEP #$20
	LDA.l InventoryTracking
	AND.b #$20
	BEQ +
	PLP : SEC : RTL
+	PLP : CLC : RTL

AgaDecision:
	LDA.b RoomIndex
	CMP.b #$20
	BNE .aga2
	JSL RNG_Agahnim1
	AND.b #$04
	STA.w $0E30, X
	CMP.b #$04
	RTL
.aga2
	STZ.w $0E30, X
	CMP.b #$04
	RTL
