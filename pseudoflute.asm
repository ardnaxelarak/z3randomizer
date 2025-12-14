SelectFirstFluteSpot:
	LDA.l FluteBitfield
	BNE .try_next
	RTL
.try_next
	LDA.w $1AF0
	INC A
	AND.b #$07
	STA.w $1AF0
	TAX

	LDA.l FluteBitfield
	AND.l $8AB7A3, X
	BEQ .try_next
RTL

SelectFluteNext:
	LDA.l FluteBitfield
	BEQ InvalidBeep

.try_next
	LDA.w $1AF0
	INC A
	AND.b #$07
	STA.w $1AF0
	TAX

	LDA.l FluteBitfield
	AND.l $8AB7A3, X
	BEQ .try_next

	LDA.b #$20
	STA.w $012F
RTL

SelectFlutePrev:
	LDA.l FluteBitfield
	BEQ InvalidBeep

.try_next
	LDA.w $1AF0
	DEC A
	AND.b #$07
	STA.w $1AF0
	TAX

	LDA.l FluteBitfield
	AND.l $8AB7A3, X
	BEQ .try_next

	LDA.b #$20
	STA.w $012F
RTL

InvalidBeep:
	LDA.b #$3C
	STA.w $012E
RTL

SetFluteSpotPalette:
	XBA
	LDA.l FluteBitfield
	AND.l $8AB7A3, X
	BEQ .disabled
.enabled
	XBA
	STA.b $0C
	BRA .done
.disabled
	LDA.b #$30
	STA.b $0C
.done
	LDA.b #$00
	STA.b $0B
RTL

MaybeMarkFluteSpotVisited:
	; don't ever allow the portal in desert/mire to be marked visited
	CMP.b #$30 : BEQ .done
	CMP.b #$70 : BEQ .done

	LDX.b #$0E
.next
	CMP.l $02E849, X
	BEQ .mark
	DEX : DEX
	BPL .next
	BRA .done

.mark
	TXA
	LSR A
	TAX
	LDA.l FluteBitfield
	ORA.l $8AB7A3, X
	STA.l FluteBitfield

.done
RTL

CheckEnterOverworld:
	LDA.l $7EC213
	STA.b $8A ; what we wrote over
	SEP #$20
	JSL MaybeMarkFluteSpotVisited
	REP #$20
RTL

CheckTransitionOverworld:
	STA.b $8A
	STA.w $040A ; what we wrote over
	JML MaybeMarkFluteSpotVisited
