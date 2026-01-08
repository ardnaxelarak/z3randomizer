; we want the icons indicating what is left in a room to blink
; but we don't want to redraw to BG1 every few frames
; so we duplicate the left side of BG1 to a lower portion and just toggle vertical scroll

BlinkLoot:
	; do not show icons if we're scrolling
	LDA.w $0210
	BNE .hide

	LDA.b FrameCounter
	AND.b #$20
	BEQ .show
.hide
	LDA.b #$01
.show
	STZ.b $E6
	STA.w $E7
	JSL $8AE96B
	RTL

StartDoubleWrite:
	; what we wrote over
	REP #$30
	STZ.w GFXStripes

	STZ.w $021B
	RTL

CheckDoubleWrite:
	LDA.w $021C
	BNE .done

	LDA.b #$08
	STA.w $021C
	REP #$30
	JML $8AE20B

.done
	; what we wrote over
	REP #$10
	LDY.w GFXStripes
	LDA.b #$FF
	JML $8AE2E7

DrawMountain:
	LDX.w GFXStripes
	PHX
	LDY.w #$0000
.next_word
	LDA.w $8AEFEF, Y
	STA.w GFXStripes+2, X
	INX : INX
	INY : INY
	CPY.w #$002A
	BCC .next_word

	PLY
	LDA.w $021B
	BEQ .done

	; if second copy of mountain, adjust VRAM addresses
	SEP #$20
	LDA.w GFXStripes+$02, Y
	ORA.w $021C
	STA.w GFXStripes+$02, Y

	LDA.w GFXStripes+$08, Y
	ORA.w $021C
	STA.w GFXStripes+$08, Y

	LDA.w GFXStripes+$10, Y
	ORA.w $021C
	STA.w GFXStripes+$10, Y

	LDA.w GFXStripes+$20, Y
	ORA.w $021C
	STA.w GFXStripes+$20, Y

	LDA.w GFXStripes+$26, Y
	ORA.w $021C
	STA.w GFXStripes+$26, Y
	REP #$20

.done
	RTL

WriteBigEndianAddressX:
	ORA.w $021B
	XBA
	STA.w GFXStripes+2, X
	AND.w #$FFF7
	RTL

WriteBigEndianAddressY:
	ORA.w $021B
	XBA
	STA.w GFXStripes+2, Y
	AND.w #$FFF7
	RTL
