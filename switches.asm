pushpc

org $87A46E
JSL CheckBookTriggerSwitch
BCS +
skip 15
+

org $8296A8
JSL FinishPegChange

org $86B93F
BRA + : NOP #8 : +
LDA.b #$19
STA.b $11
LDA.b #$33
JSL $8DBB7C

pullpc

FinishPegChange:
	LDA.b #$20
	TRB.w $037A

	STZ.b $B0
	STZ.b $11
RTL

CheckBookTriggerSwitch:
	LDA.b $10
	CMP.b #$07
	BNE +

	LDA.l $7EC172
	EOR.b #$01
	STA.l $7EC172

	LDA.b #$16
	STA.b $11

	LDA.b #$20
	TSB.w $037A

	LDA.b #$25
	JSL $8DBB8A

	SEC
	BRA .done

+	CLC
.done
	; what we wrote over
	LDA.b $3A
	AND.b #$BF
	STA.b $3A
RTL
