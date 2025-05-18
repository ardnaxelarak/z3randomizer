AdjustDefaultGraphics:
	JSL $80E310

	LDA.l ChallengeModes : AND.b #$03 : CMP.b #$02 : BEQ .gloom
	RTL

.gloom
	LDA.b #$80
	STA.w $2115
	LDA.b #$00
	STA.w $2116
	LDA.b #$75
	STA.w $2117

	LDA.b #$01
	STA.w $4300
	LDA.b #$18
	STA.w $4301

	LDA.b #SkullGfx
	STA.w $4302
	LDA.b #SkullGfx>>8
	STA.w $4303
	LDA.b #SkullGfx>>16
	STA.w $4304

	LDA.b #SkullGfx_end-SkullGfx
	STA.w $4305
	LDA.b #(SkullGfx_end-SkullGfx)>>8
	STA.w $4306

	LDA.b #$01
	STA.w $420B
	RTL

SkullGfx:
	incbin "data/skull.bin"
.end
