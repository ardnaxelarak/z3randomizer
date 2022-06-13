;================================================================================
; Door Frame Fixes
;================================================================================

;--------------------------------------------------------------------------------
; StoreLastOverworldDoorID
;--------------------------------------------------------------------------------
StoreLastOverworldDoorID:
	TXA : INC
	STA $7F5099
	LDA $1BBB73, X : STA $010E
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CacheDoorFrameData
;--------------------------------------------------------------------------------
CacheDoorFrameData:
	LDA $7F5099 : BEQ .originalBehaviour
	DEC : ASL : TAX
	LDA EntranceDoorFrameTable, X : STA $0696
	LDA EntranceAltDoorFrameTable, X : STA $0698
	BRA .done
	.originalBehaviour
		LDA $D724, X : STA $0696
		STZ $0698
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; WalkDownIntoTavern
;--------------------------------------------------------------------------------
WalkDownIntoTavern:
	LDA $7F5099
	; tavern door has index 0x42 (saved off value is incremented by one)
	CMP #$43
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; TurnAroundOnUnderworld
;--------------------------------------------------------------------------------
TurnAroundOnUnderworld:
	LDA $26 : BEQ .done
		; turn around if ($010E == #$43) != ($7F5099 == #$43)
		LDX #$00
		LDA #$43 : CMP $010E : BEQ +
			INX
		+
		CMP $7F5099 : BEQ +
			DEX
		+
		CPX #$00 : BEQ .done
			LDA $26 : EOR #$0C : STA $26
.done
JML $0FFD65 ; what we overwrote

;--------------------------------------------------------------------------------
; TurnUpOnOverworld
;--------------------------------------------------------------------------------
TurnUpOnOverworld:
	LDA.l EntranceTavernBack : CMP #$43 : BEQ .done
		LDA #$08 : STA $26 ; only fix this glitch if exit not vanilla
.done
JML $07E68F ; what we overwrote

;--------------------------------------------------------------------------------
; WalkUpOnOverworld
;--------------------------------------------------------------------------------
WalkUpOnOverworld:
	LDA $20 : CMP #$091B : BNE .normal ; hardcoded Y coordinate
		STZ $2F
		RTL
	.normal
	LDA #$0002 : STA $2F ; what we overwrote
RTL