AdjustDefaultGraphics:
	JSL $80E310

	LDA.l ChallengeModes : AND.b #$03 : CMP.b #$02 : BEQ .gloom
	RTL

.gloom
	LDA.b #$80
	STA.w $2115

	REP #$20
	LDA.w #$7500
	STA.w $2116

	LDY.b #SkullGfx_end-SkullGfx
	LDX.b #$00

-	LDA.l SkullGfx, X
	STA.w $2118
	INX #2
	DEY #2
	BNE -

	SEP #$20
	RTL

SkullGfx:
	incbin "data/skull.bin"
.end
