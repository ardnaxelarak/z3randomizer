MSUCode = $00277E

;@ pushpc


; Change track 15 (unused) to point to 13 (Death Mountain) so dark woods can be track 15
; Bank 1
org $1A9F15 ; PC 0x0D1F15 ; SPC $D01C
	dw $2B00	; Set track 15 pointer to track 13's data

; pullpc ; ???????

;---------------------------------------------------------------------------------------------------

arch spc700

;@ pushpc
;@ pushbase
org $19FE41 ; SPC 0A73
	JMP MSUCode

; Hijack unreachable SFX data for globally available code
org $1A9B2E
site MSUCode

SpecialCommand_Mute:
	CMP A,#$F0      ; The thing we overwrote
	BNE +
		JMP $0A81   ; SilenceSong
	+
	CMP A,#$FA      ; New mute command $FA
	BNE +
		MOV.b $F4,A
		MOV.b A,#$00
		MOV.w $0A4A,A ; $0A49: MOV A,#$70 -> MOV A,#$00
		MOV.w $0AF3,A ; $0AF2: MOV $059,#$C0 -> MOV $059,#$00
		MOV.w $0C32,A ; $0C32: MOVW $058,YA -> NOP #2
		MOV.w $0C33,A
		MOV.b A,#$C4  ; $0D19: MOVW $058,YA -> MOV A,$058
		MOV.w $0D19,A
		MOV.b A,#$58
		MOV.w $0D1A,A
		BRA +++
	+
	CMP.b A,#$FB      ; New unmute command $FB
	BEQ +
		JMP $0A9D   ; NewSongInput
	+
	MOV.b $F4,A
	MOV.b A,#$70
	MOV.w $0A4A,A     ; $0A49: MOV A,#$70
	MOV.b A,#$C0
	MOV.w $0AF3,A     ; $0AF2: MOV $059,#$C0
	MOV.b A,#$DA
	MOV.w $0C32,A     ; $0C32: MOVW $058,YA
	MOV.w $0D19,A     ; $0D19: MOVW $058,YA
	MOV.b A,#$58
	MOV.w $0C33,A
	MOV.w $0D1A,A
	+++
	CALL $0A81      ; SilenceSong
-	MOV.b A,$F4
		BNE -
		CMP.b A,$F4
		BNE -
	MOV $F4,$00
	RET

warnpc $1A9B91

;@ pullbase
;@ pullpc

site *
arch 65816
