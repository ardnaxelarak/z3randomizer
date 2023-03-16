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
	AND.b #$3F
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
	STA.l $7F50C5       ; turn on cucco storm
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
	STA.l $7F50C5 ; turn off cuccos
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
