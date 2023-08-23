!BlankTile = $207F
!SlashTile = $2830
!HyphenTile = $2405
!PTile = $296C
!CTile = $295F
!RedSquare = $345E
!BlueSquare = $2C5E

!DungeonMask = $8098C0
!EnemyDropIndicator = $7E072A
!IndicatorAddress = $7EC790 ; used for both boss nearness and enemy drops
!CurrentDungeonIndicator = $7EC702

!KeysObtained = $7EC7A2
!KeysSlash = $7EC7A4
!KeysTotal = $7EC7A6

DrHudOverride:
	PHB
	SEP #$30
	LDA.b #$7E
	PHA
	PLB

DRHUD_DrawItemCounter:
	; hides total for mystery seeds
	LDA.l DRFlags+1 : LSR : BCC DRHUD_DrawIndicators
	REP #$30
	LDY.w #!HyphenTile : STA.w HUDGoalIndicator+$0A : STA.w HUDGoalIndicator+$0C
                       STA.w HUDGoalIndicator+$0E : STA.w HUDGoalIndicator+$10
    SEP #$30

DRHUD_DrawIndicators:
	LDA.b $1B : BNE .continue
	JMP DRHUD_Finished
.continue
	LDA.b $1A : AND.b #$10 : BEQ DRHUD_EnemyDropIndicator

DRHUD_BossIndicator:
	LDA.l DRMode : BNE .continue
.early_exit
	JMP DRHUD_Finished
.continue
	LDA.w $040C : CMP.b #$1B : BCS .early_exit

	SEP #$10 ; clears the high byte of X and prevents it from getting B register
	TAX

	REP #$30
	LDY.w #!BlankTile
	LDA.w CompassField : AND.l DungeonMask, x
	SEP #$20
	BEQ .draw_indicator
    LDA.l CompassBossIndicator, x : CMP.b $A0 : BNE .draw_indicator
    LDY.w #!RedSquare
.draw_indicator
    STY.w !IndicatorAddress
	BRA DRHUD_DrawCurrentDungeonIndicator

DRHUD_EnemyDropIndicator:
	REP #$30
	LDA.w !EnemyDropIndicator : STA.w !IndicatorAddress
	SEP #$20
	LDA.w $040C : CMP.b #$1B : BCS DRHUD_Finished
	SEP #$10 : TAX : REP #$10

DRHUD_DrawCurrentDungeonIndicator: ; mX
    LDA.l DRMode : AND.b #$02 : BEQ DRHUD_Finished
    LDY.w #!BlankTile
    LDA.w CurrentHealth : BEQ .draw_indicator

    REP #$20 : LDA.l DungeonReminderTable,X : SEP #$20
	TAY
.draw_indicator
	STY.w !CurrentDungeonIndicator

DRHUD_DrawKeyCounter:
    LDA.l DRFlags : AND.b #$04 : BEQ DRHUD_Finished
    REP #$20
    LDA.w MapField : AND.l DungeonMask, X : BEQ DRHUD_Finished
	TXA : LSR : TAX
	LDA.l GenericKeys : AND.w #$00FF : BNE .total_only
	LDA.l DungeonCollectedKeys, X : JSR ConvertToDisplay : STA.w !KeysObtained
	LDA #!SlashTile : STA.w !KeysSlash
.total_only
	LDA.l ChestKeys, x : JSR ConvertToDisplay : STA.w !KeysTotal

DRHUD_Finished:
    PLB : RTL

;===================================================================================================

;column distance for BK/Smalls
HudOffsets:
;   none  hc     east   desert aga    swamp  pod    mire   skull  ice    hera   tt     tr     gt
dw $fffe, $0000, $0006, $0008, $0002, $0010, $000e, $0018, $0012, $0016, $000a, $0014, $001a, $001e

; offset from 1644
RowOffsets:
dw $0000, $0000, $0040, $0080, $0000, $0080, $0040, $0080, $00c0, $0040, $00c0, $0000, $00c0, $0000

ColumnOffsets:
dw $0000, $0000, $0000, $0000, $000a, $000a, $000a, $0014, $000a, $0014, $0000, $0014, $0014, $001e


DrHudDungeonItemsAdditions:
{
    jsl DrawHUDDungeonItems
    lda.l HUDDungeonItems : and #$ff : bne + : rtl : +
    lda.l DRMode : cmp #$02 : beq + : rtl : +

    phx : phy : php
    rep #$30

    lda.w #$24f5 : sta $1606 : sta $1610 : sta $161a : sta $1624
    sta $1644 : sta $164a : sta $1652 : sta $1662 : sta $1684 : sta $16c4
    ldx #$0000
    - sta $1704, x : sta $170e, x : sta $1718, x
    inx #2 : cpx #$0008 : !blt -

    lda HudFlag : and.w #$0020 : beq + : JMP ++ : +
    lda HUDDungeonItems : and.w #$0007 : bne + : JMP ++ : +
    	; bk symbols
		lda.w #$2811 : sta $1606 : sta $1610 : sta $161a : sta $1624
		; sm symbols
		lda.w #$2810 : sta $160a : sta $1614 : sta $161e : sta $16e4
    	; blank out stuff
    	lda.w #$24f5 : sta $1724

        ldx #$0002
        	- lda #$0000 : !addl RowOffsets,x : !addl ColumnOffsets, x : tay
        	lda.l DungeonReminderTable, x : sta $1644, y : iny #2
        	lda.w #$24f5 : sta $1644, y
        	lda MapField : and.l $0098c0, x : beq + ; must have map
        		jsr BkStatus : sta $1644, y : bra .smallKey ; big key status
        	+ lda BigKeyField : and.l $0098c0, x : beq .smallKey
        		lda.w #$2826 : sta $1644, y
        	.smallKey
        	+ iny #2
			cpx #$001a : bne +
				tya : !add #$003c : tay
        	+ stx $00
        		txa : lsr : tax
        		lda.w #$24f5 : sta $1644, y
        		lda.l GenericKeys : and #$00FF : bne +
        		lda.l DungeonKeys, x : and #$00FF : beq +
        			jsr ConvertToDisplay2 : sta $1644, y
        		+ iny #2 : lda.w #$24f5 : sta $1644, y
        		phx : ldx $00
        			lda MapField : and.l $0098c0, x : beq + ; must have map
        				plx : sep #$30 : lda.l ChestKeys, x : sta $02
        				lda.l GenericKeys : bne +++
        					lda $02 : !sub DungeonCollectedKeys, x : sta $02
        				+++ lda $02
        				rep #$30
        				jsr ConvertToDisplay2 : sta $1644, y ; small key totals
        				bra .skipStack
        		+ plx
        		.skipStack iny #2
        		cpx #$000d : beq +
        			lda.w #$24f5 : sta $1644, y
        		+
        	ldx $00
            + inx #2 : cpx #$001b : bcs ++ : JMP -
    ++
    lda HudFlag : and.w #$0020 : bne + : JMP ++ : +
    lda HUDDungeonItems : and.w #$000c : bne + : JMP ++ : +
        ; map symbols (do I want these) ; note compass symbol is 2c20
        lda.w #$2821 : sta $1606 : sta $1610 : sta $161a : sta $1624
        ; blank out a couple thing from old hud
        lda.w #$24f5 : sta $16e4 : sta $1724
        sta $160a : sta $1614 : sta $161e ; blank out sm key indicators
        ldx #$0002
        	- lda #$0000 ; start of hud area
        	!addl RowOffsets, x : !addl ColumnOffsets, x : tay
        	lda.l DungeonReminderTable, x : sta $1644, y
        	iny #2
        	lda.w #$24f5 : sta $1644, y ; blank out map spot
        	lda MapField : and.l $0098c0, x : beq + ; must have map
        		JSR MapIndicatorShort : STA $1644, Y
			+ iny #2
            cpx #$001a : bne +
				tya : !add #$003c : tay
			+ lda CompassField : and.l $0098c0, x : beq + ; must have compass
                phx ; total chest counts
                    txa : lsr : tax
                    sep #$30
                    lda.l TotalLocations, x : !sub DungeonLocationsChecked, x : JSR HudHexToDec2DigitCopy
                    rep #$30
                    lda $06 : jsr ConvertToDisplay2 : sta $1644, y : iny #2
                    lda $07 : jsr ConvertToDisplay2 : sta $1644, y
                plx
                bra .skipBlanks
			+ lda.w #$24f5 : sta $1644, y : iny #2 : sta $1644, y
            .skipBlanks iny #2
            cpx #$001a : beq +
				lda.w #$24f5 : sta $1644, y ; blank out spot
            + inx #2 : cpx #$001b : !bge ++ : JMP -
    ++
    plp : ply : plx : rtl
}

MapIndicatorLong:
	PHX
		LDA.l OldHudToNewHudTable, X : TAX
		JSR MapIndicator
	PLX
RTL

MapIndicatorShort:
	PHX
		TXA : LSR : TAX
		JSR MapIndicator
	PLX
RTS

OldHudToNewHudTable:
	dw 1, 2, 3, 10, 4, 6, 5, 8, 11, 9, 7, 12, 13

IndicatorCharacters:
	;  check      1      2      3      4      5      6      7      G      B      R
	dw $2426, $2817, $2818, $2819, $281A, $281B, $281C, $281D, $2590, $258B, $259B

MapIndicator:
	LDA.l CrystalPendantFlags_3, X : AND #$00FF
	PHX
		ASL : TAX : LDA.l IndicatorCharacters, X
	PLX
RTS

BkStatus:
    lda BigKeyField : and.l $0098c0, x : bne +++ ; has the bk already
         lda.l BigKeyStatus, x : bne ++
            lda #$2827 : rts ; 0/O for no BK
         ++ cmp #$0002 : bne +
            lda #$2420 : rts ; symbol for BnC
    + lda #$24f5 : rts ; black otherwise
    +++ lda #$2826 : rts ; check mark

ConvertToDisplay:
    and.w #$00ff : cmp #$000a : !blt +
        !add #$2553 : rts
    + !add #$2490 : rts

ConvertToDisplay2:
    and.w #$00ff : beq ++
        cmp #$000a : !blt +
            !add #$2553 : rts ; 2580 with 258A as "A" for non transparent digits
        + !add #$2816 : rts
    ++ lda #$2827 : rts ; 0/O for 0 or placeholder digit ;2483

CountAbsorbedKeys:
    jsl IncrementSmallKeysNoPrimary : phx
    lda $040c : cmp #$ff : beq +
        lsr : tax
        lda DungeonAbsorbedKeys, x : inc : sta DungeonAbsorbedKeys, x
    + plx : rtl

;================================================================================
; 8-bit registers
; in:	A(b) - Byte to Convert
; out:	$06 - $07 (high - low)
;================================================================================
HudHexToDec2DigitCopy: ; modified
	PHY
		LDY.b #$00
		-
			CMP.b #10 : !BLT +
			INY
			SBC.b #10 : BRA -
		+
		STY $06 : LDY #$00 ; Store 10s digit and reset Y
		CMP.b #1 : !BLT +
		-
			INY
			DEC : BNE -
		+
		STY $07	; Store 1s digit
	PLY
RTS
