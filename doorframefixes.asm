;================================================================================
; Door Frame Fixes
;================================================================================

;--------------------------------------------------------------------------------
; StoreLastOverworldDoorID
;--------------------------------------------------------------------------------
StoreLastOverworldDoorID:
	TXA : INC
	STA.l PreviousOverworldDoor
	LDA.l $9BBB73, X : STA.w EntranceIndex
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; CacheDoorFrameData
;--------------------------------------------------------------------------------
CacheDoorFrameData:
	LDA.l PreviousOverworldDoor : BEQ .originalBehaviour
	DEC : ASL : TAX
	LDA.l EntranceDoorFrameTable, X : STA.w TileMapEntranceDoors
	LDA.l EntranceAltDoorFrameTable, X : STA.w TileMapTile32
	BRA .done
	.originalBehaviour
		LDA.w $D724, X : STA.w TileMapEntranceDoors
		STZ.w TileMapTile32
	.done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; WalkDownIntoTavern
;--------------------------------------------------------------------------------
WalkDownIntoTavern:
	LDA.l PreviousOverworldDoor
	; tavern door has index 0x42 (saved off value is incremented by one)
	CMP.b #$43
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

;--------------------------------------------------------------------------------
; CheckStairsAdjustment
;--------------------------------------------------------------------------------
CheckStairsAdjustment:
	LDA.b $A0
	CMP.w #$0124 ; vanilla check, rooms $0124 to $0127 have a lower exit position (currently ER ignores the entrance location)
	BCC .done
	LDA.w #$FFFF-1
	CMP.w $0696 ; tavern back ($0696 == #$FFFF) should always have carry cleared
.done
RTL
; if carry cleared, shift position up