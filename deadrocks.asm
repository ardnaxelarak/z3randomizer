pushpc

org $86EDD1
JSL CheckTransform
BRA + : NOP : +

org $86EF9A
JSL SpriteDeath
NOP

pullpc

CheckTransform:
	CMP.b #$8F
	BNE .skip

	LDA.w $0E20, X
	PHA
	LDA.b #$8F
	STA.w $0E20, X
	JSL.l $8DB818

	PLA
	STA.w $0DE0, X
	LDA.b #$8F
	RTL

.skip
	STA.w $0E20, X
	JSL.l $8DB818
	RTL

SpriteDeath:
	LDA.w $0E20, X
	CMP.b #$8F
	BNE .done; not blob
	LDA.w $0DE0, X
	CMP.b #$27
	BNE .done; blob that was formerly not a deadrock
	LDA.l DeadrockCounter
	CMP.b #$FF
	BEQ .done ; deadrock counter maxed
	INC
	STA.l DeadrockCounter

.done
	; what we wrote over
	LDY.w $0E20, X
	CPY.b #$1B
RTL
