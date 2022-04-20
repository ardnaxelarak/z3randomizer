; adding support for up to 13 markers
!MC_FLAG = "$7F5420"

; tables
org $0ABDF6
WorldMapIcon_posx_vanilla:
dw $0F31 ; prize1
dw $08D0 ; prize2
dw $0108
dw $0F40

dw $0082
dw $0F11
dw $01D0
dw $0100

dw $0CA0
dw $0759
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $0ABE16
WorldMapIcon_posy_vanilla:
dw $0620 ; prize1
dw $0080 ; prize2
dw $0D70
dw $0620

dw $00B0
dw $0103
dw $0780
dw $0CA0

dw $0DA0
dw $0ED0
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $0ABE36
WorldMapIcon_posx_located:
dw $FF00 ; prize1
dw $FF00 ; prize2
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $0ABE56
WorldMapIcon_posy_located:
dw $FF00 ; prize1
dw $FF00 ; prize2
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FF00
dw $FF00
dw $FF00

dw $FF00
dw $FFFF ; reserved - not used
dw $FFFF
dw $FFFF

org $0ABE76
WorldMapIcon_tile:
db $38, $62 ; green pendant
db $32, $60 ; red pendant
db $34, $60 ; blue pendant
db $34, $64 ; crystal

db $34, $64 ; crystal
db $34, $64 ; crystal
db $34, $64 ; crystal
db $34, $64 ; crystal

db $34, $64 ; crystal
db $34, $64 ; crystal
db $32, $66 ; skull looking thing
db $00, $00 ; red x

db $00, $00 ; red x
db $00, $00 ; unused red x's
db $00, $00
db $00, $00

org $0ABE96
CompassExists:
; dw $37FC ; todo: convert to two bytes with masks? so much extra code...
; eastern hera desert pod skull trock thieves mire ice swamp gt at escape
db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; 0 = light world, 1 = dark world
org $0ABEA6
WorldCompassMask:
db $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00

; eastern desert hera pod skull trock thieves mire ice swamp gt at escape x1 x2 x3

; refs
org $0AC59B
WorldMapIcon_AdjustCoordinate:
org $0AC3B1
WorldMap_CalculateOAMCoordinates:
org $0AC52E
WorldMap_HandleSpriteBlink:
org $0ABF70
WorldMap_RedXChars:

org $0AC02B
DrawPrizesOverride:
LDX.b #$FF
.loopStart
	INX : PHX
	JSR OverworldMap_CheckForPrize
	BCC + : JMP .skip_draw : +

	TXA : ASL A : TAX
	LDA.l !MC_FLAG
	AND #$01 : BNE +
		LDA.l WorldMapIcon_posx_vanilla+1, X : STA.l $7EC10B
		LDA.l WorldMapIcon_posx_vanilla, X : STA.l $7EC10A
        LDA.l WorldMapIcon_posy_vanilla+1, X : STA.l $7EC109
        LDA.l WorldMapIcon_posy_vanilla, X : STA.l $7EC108
        BRA .adjustment
	+ LDA.l WorldMapIcon_posx_located+1, X : STA.l $7EC10B
	LDA.l WorldMapIcon_posx_located, X : STA.l $7EC10A
	LDA.l WorldMapIcon_posy_located+1, X : STA.l $7EC109
	LDA.l WorldMapIcon_posy_located, X : STA.l $7EC108
    .adjustment
   	LDA.l WorldMapIcon_tile+1, X : BEQ .dont_adjust
   	CMP.b #$64 : BEQ .is_crystal
   	LDA.b $1A : AND.b #$10 : BNE .skip_draw
   	.is_crystal
   	JSR WorldMapIcon_AdjustCoordinate
   	.dont_adjust
   	JSR WorldMap_CalculateOAMCoordinates
    BCC .skip_draw
    PLX : PHX : TXA : ASL A : TAX
    LDA.l WorldMapIcon_tile+1, X : BEQ .is_red_x
    LDA.l !MC_FLAG : CMP.b #$01 : BEQ .is_red_x
    LDA.l WorldMapIcon_tile+1, X : STA.b $0D
    LDA.l WorldMapIcon_tile, X : STA.b $0C
    LDA.b #$02 : BRA .continue
    .is_red_x
    LDA.b $1A : LSR #3 : AND.b #$03 : TAX
    LDA.l WorldMap_RedXChars,X : STA.b $0D
    LDA.b #$32 : STA.b $0C : LDA.b #$00
    .continue
    STA.b $0B
    PLX : PHX
    JSR WorldMap_HandleSpriteBlink
    .skip_draw
	; end of loop
	PLX : CPX #12 : BCS + : JMP .loopStart : +

    PLA : STA.l $7EC10B
	PLA : STA.l $7EC10A
	PLA : STA.l $7EC109
	PLA : STA.l $7EC108
	RTS


; X - the index of the prize marker
OverworldMap_CheckForPrize:
PHX
	LDA #$00 : STA.l !MC_FLAG
	JSR OverworldMap_CheckForCompass
	BCC +
		LDA.l !MC_FLAG : ORA #$01 : STA.l !MC_FLAG
		LDA CurrentWorld : AND #$40 : BNE ++ ; is the compass position on LW or DW?
        	LDA.l WorldCompassMask, X : BEQ + : JMP .fail
        ++ LDA.l WorldCompassMask, X : BNE + : JMP .fail
	+ JSR OverworldMap_CheckForMap
	BCC +
		LDA.l !MC_FLAG : ORA #$02 : STA.l !MC_FLAG
	+
	LDA.l !MC_FLAG : BEQ .fail
	CMP #$02 : BNE .checkIfObtained
		LDA CurrentWorld : AND #$40 : BNE +
			CPX #3 : BCS .fail : BRA .checkIfObtained
		+ CPX #10 : BCS .fail
		CPX #3 : BCC .fail

	.checkIfObtained
	LDA.l MC_DungeonIdsForPrize, X
	BPL +++ : CLC : BRA .done : +++ ; non-prize flags

	TAX : LDA.l CrystalPendantFlags_2, X : BEQ .checkPendant
	AND.b #$40 : BNE .checkCrystal
	LDA.l CrystalPendantFlags_2, X : AND.b #$01 : BNE .checkAga1
	LDA.l CrystalPendantFlags_2, X : AND.b #$02 : BNE .checkAga2

	; see if hyrule castle has been completely cleared
	LDA.l CompassTotalsWRAM, X : SEC : SBC DungeonLocationsChecked, X : BEQ .fail
	CLC : BRA .done

	.checkPendant
	LDA PendantsField : AND.l CrystalPendantFlags, X : BNE .fail
	CLC : BRA .done

	.checkCrystal
	LDA CrystalsField : AND.l CrystalPendantFlags, X : BNE .fail
	CLC : BRA .done

	.checkAga1
	LDA ProgressIndicator : CMP #$03 : BEQ .fail
	CLC : BRA .done

	.checkAga2
	LDA OverworldEventDataWRAM+$5B : AND #$20 : BNE .fail
	CLC : BRA .done

	.fail
	SEC
.done
PLX
RTS

; X - which compass in question
; CLC - should not move indicator
; SEC - yep indicator can move
OverworldMap_CheckForCompass:
	LDA.l CompassMode : AND #$80 : BEQ .unset ; should I check for compass logic
	LDA.l CompassMode : AND #$40 : BEQ .set ; compasses aren't shuffled
	LDA.l CompassExists, X : BEQ .set ; compass doesn't exits
	PHX
		LDA.l MC_SRAM_Offsets, X : TAX ; put compass offset into X
		LDA CompassField, X : ORA MapOverlay, X
	PLX
	AND.l MC_Masks, X : BNE .set ; is the compass obtained
.unset
CLC
RTS
.set
SEC
RTS

; map - which map in question
; CLC - should not show exact prize
; SEC - yep should show exact prize
OverworldMap_CheckForMap:
	LDA.l MapMode : BEQ .set ; obtaining map doesn't change anything
	LDA CurrentWorld : AND #$40 : BNE + ; not really sure on this check
		LDA MapField : ORA MapOverlay : AND.b #$01 : BNE .set : BRA .continue
	+ LDA MapField : ORA MapOverlay : AND.b #$02 : BNE .set
.continue
	PHX
		LDA.l MC_SRAM_Offsets, X : TAX ; put map offset into X
		LDA MapField, X : ORA MapOverlay, X
	PLX
	AND.l MC_Masks, X : BNE .set ; is the map obtained?
.unset
CLC
RTS
.set
SEC
RTS

; eastern desert hera pod skull trock thieves mire ice swamp gt at escape
MC_DungeonIdsForPrize:
db $02, $0A, $03, $06, $08, $0C, $0B, $07, $09, $05, $00, $04, $01
MC_SRAM_Offsets:
db $01, $00, $01, $01, $00, $00, $00, $01, $00, $01, $00, $01, $01
MC_Masks:
;   EP   TH   DP   PD   SK   TR   TT   MM
db $20, $20, $10, $02, $80, $08, $10, $01, $40, $04, $04, $08, $40

