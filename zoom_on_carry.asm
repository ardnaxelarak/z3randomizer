pushpc

org $87E294
JSL.l CheckSpeed

pullpc

CheckSpeed:
	LDA.w $0308 : BIT.b #$80 : BNE .zoom
	LDA.b $5E : STA.b $00 ; what we wrote over
RTL
.zoom
	LDA.b #$10 : STA.b $00 : RTL
