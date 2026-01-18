SelectFirstFluteSpot:
	LDA.l FluteBitfield
	CMP.b #$FF
	BNE +
	RTL
+	LDA.b #$07
	STA.w FluteSelection
.try_next
	LDA.w FluteSelection
	INC A
	AND.b #$07
	STA.w FluteSelection
	TAX

	LDA.l FluteBitfield
	AND.l FluteMenuNumbers_bits, X
	BNE .try_next
RTL

SelectFluteNext:
	LDA.l FluteBitfield
	CMP.b #$FF
	BEQ InvalidBeep

.try_next
	LDA.w FluteSelection
	INC A
	AND.b #$07
	STA.w FluteSelection
	TAX

	LDA.l FluteBitfield
	AND.l FluteMenuNumbers_bits, X
	BNE .try_next

	LDA.b #$20
	STA.w $012F
RTL

SelectFlutePrev:
	LDA.l FluteBitfield
	CMP.b #$FF
	BEQ InvalidBeep

.try_next
	LDA.w FluteSelection
	DEC A
	AND.b #$07
	STA.w FluteSelection
	TAX

	LDA.l FluteBitfield
	AND.l FluteMenuNumbers_bits, X
	BNE .try_next

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
	AND.l FluteMenuNumbers_bits, X
	BNE .disabled
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
	LDA.l FluteMenuNumbers_bits, X
	EOR.b #$FF
	AND.l FluteBitfield
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

CheckFlute:
	LDA.l FluteBitfield
	AND.w #$00FF
	BNE .pseudo
.real
	LDA.w #$0003
	BRA .done
.pseudo
	LDA.w #$0002
.done
	RTS

DrawFluteIcon:
	AND.w #$00FF
	CMP.w #$0002
	BCC +
	JSR CheckFlute
+
	STA.b $02
	RTL

CheckFluteInHUD:
	LDA.l EquipmentWRAM-1, X
	AND.w #$00FF ; what we wrote over
	CPX.w #$000D
	BNE +
	CMP.w #$0002
	BCC +
	JSR CheckFlute
+
	RTL
