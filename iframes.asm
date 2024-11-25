pushpc

org $8780B9
JSL CalcIFrames
NOP

pullpc

CalcIFrames:
	LDA.l IFrames
	STA.w $031F
	RTL

DrawIFrames:
	LDA.l IFrames
	AND.w #$00FF
	JSL HexToDec

	LDY.w #$16EE
	LDA.w #$253B
	STA.w $0000, Y
	LDA.w #$253C
	STA.w $0002, Y

	LDA.l HexToDecDigit3
	AND.w #$00FF
	BEQ +
	CLC : ADC.w #$2416
	STA.w $003E, Y
+
	LDA.l HexToDecDigit4
	AND.w #$00FF
	BNE +
	LDA.w #$0011
+	CLC : ADC.w #$2416
	STA.w $0040, Y

	LDA.l HexToDecDigit5
	AND.w #$00FF
	BNE +
	LDA.w #$0011
+	CLC : ADC.w #$2416
	STA.w $0042, Y

	RTL
