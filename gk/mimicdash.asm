;================================================================================
; Mimic Direction Check
;--------------------------------------------------------------------------------
; Output: 0 for darkness, 1 for lamp cone
;--------------------------------------------------------------------------------
MimicDirection:
	LDA.b $F0
	AND.b #$0F
	BNE .done
	LDA.l MimicDash
	BEQ .done
	LDA.w $0372
	BEQ .done
	LDA.w $0374
	BNE .make_zero
	LDA.b $67
.done
	RTL
.make_zero
	LDA.b #$00
	RTL

