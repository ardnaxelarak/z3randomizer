;================================================================================
; Lamp Mantle & Light Cone Fix
;--------------------------------------------------------------------------------
; Output: 0 for darkness, 1 for lamp cone
;--------------------------------------------------------------------------------
LampCheckOverride:
	LDA $7F50C4 : CMP.b #$01 : BNE + : RTL : +
				  CMP.b #$FF : BNE + : INC : RTL : +

	LDA LampEquipment : BNE .done ; skip if we already have lantern

	LDA CurrentWorld : BNE +
		.lightWorld
		LDA $040C : CMP.b #$04 : !BGE ++ ; check if we're in HC
			LDA LampConeSewers : BRA .done
		++
			LDA LampConeLightWorld : BRA .done
	+
		.darkWorld
		LDA LampConeDarkWorld
	.done
	;BNE + : STZ $1D : + ; remember to turn cone off after a torch
RTL

GtBossHeartCheckOverride:
    lda $a0 : cmp #$1c : beq ++
    cmp #$6c : beq ++
    cmp #$4d : bne +
    ++ lda.l DRFlags : and #$01 : bne ++ ;skip if flag on
        lda $403 : ora #$80 : sta $403
    ++ clc
rtl
    + sec
rtl

OnFileLoadOverride:
    jsl OnFileLoad ; what I wrote over
    + lda.l DRFlags : and #$02 : beq + ; Mirror Scroll
        lda MirrorEquipment : bne +
            lda #$01 : sta MirrorEquipment
+ rtl

MirrorCheckOverride:
    lda.l DRFlags : and #$02 : beq ++
        lda MirrorEquipment : cmp #$01 : beq +
    ;++ lda $8A : and #$40 ; what I wrote over
    ++ phx : ldx $8A : lda.l OWTileWorldAssoc,x : plx : and.b #$ff
    rtl
    + lda.l DRScroll : rtl

EGFixOnMirror:
	lda.l DRFlags : and #$10 : beq +
		stz $047a
	+ jsl Mirror_SaveRoomData
	rtl

BlockEraseFix:
    lda MirrorEquipment : and #$02 : beq +
        stz $05fc : stz $05fd
    + rtl

FixShopCode:
    cpx #$300 : !bge +
        sta RoomDataWRAM[$00].l, x
    + rtl

VitreousKeyReset:
    lda.l DRMode : beq +
        stz $0cba, x
    + JML $0db818 ;restore old code

GuruguruFix:
    lda $a0 : cmp #$df : !bge +
        and #$0f : cmp #$0e : !blt +
            iny #2
    + rtl

BlindAtticFix:
    lda.l DRMode : beq +
        lda #$01 : rtl
    + lda FollowerIndicator : cmp.b #$06
    rtl

SuctionOverworldFix:
    stz $50 : stz $5e
    lda.l DRMode : beq +
        stz $49
    + rtl

!CutoffTable = "$27E000"

CutoffEntranceRug:
    PHA : PHX
    LDA.l DRMode : BEQ .norm
        LDA $04 : cmp #$000A : BEQ + ; only affect A & C objects
        cmp #$000C : BNE .norm
          + LDX #$0000 : LDA !CutoffTable, x
          	- CMP.W $A0 : BEQ .check
           	INX #2 : LDA !CutoffTable, x : CMP.w #$FFFF : BNE -
    .norm PLX : PLA : LDA $9B52, y : STA $7E2000, x ; what we wrote over
RTL
     .check
		  LDA $0c : CMP #$0004 : !BGE .skip
		  LDA $0e : CMP #$0008 : !BGE .skip
		  CMP.l #$0004 : !BLT .skip
      BRA .norm
.skip PLX : PLA : RTL

StoreTempBunnyState:
	LDA $5D : CMP #$1C : BNE +
		STA $5F
	+ LDA #$15 : STA $5D ; what we wrote over
RTL

RetrieveBunnyState:
	STY $5D : STZ $02D8 ; what we wrote over
	LDA $5F : BEQ +
		STA $5D
+ RTL

RainPrevention:
	LDA $00 : XBA : AND #$00FF : STA.b $0A ; what we wrote over
	PHA
		LDA ProgressIndicator : AND #$00FF : CMP #$0002 : !BGE .done ; only in rain states (0 or 1)
		LDA.l ProgressFlags : AND #$0004 : BNE .done ; zelda's been rescued
			LDA.l BlockSanctuaryDoorInRain : BEQ .done ;flagged
			LDA $A0 : CMP #$0012 : BNE + ;we're in the sanctuary
				LDA.l FollowerIndicator : AND #$00FF : CMP #$0001 : BEQ .done ; zelda is following
					LDA $00 : AND #$00FF : CMP #$00A1 : BNE .done ; position is a1
						PLA : LDA #$0008 : RTL
			+ LDA.l BlockCastleDoorsInRain : AND #$00FF : BEQ .done ;flagged
			LDX #$FFFE
			- INX #2 : LDA.l RemoveRainDoorsRoom, X : CMP #$FFFF : BEQ .done
			CMP $A0 : BNE -
				SEP #$20 : LDA.l RainDoorMatch, X : CMP $00 : BNE .continue
					INC.w $0460 : INC.w $0460 : REP #$20 : PLA : SEC : RTL
				.continue
				REP #$20 : BRA -
	.done PLA : CLC : RTL

; A should be how much dmg to do to Aga when leaving this function
StandardAgaDmg:
	LDX.b #$00 ; part of what we wrote over
	LDA.l ProgressFlags : AND #$04 : BEQ + ; zelda's not been rescued
		LDA.b #$10 ; hurt him!
	+ RTL ; A is zero if the AND results in zero and then Agahnim's invincible!

; note: this skips both maiden dialog triggers if the hole is open
BlindsAtticHint:
	REP #$20
	CMP.w #$0122 : BNE +
	LDA RoomDataWRAM[$65].low : AND.w #$0100 : BEQ +
		SEP #$20 : RTL ; skip the dialog box if the hole is already open
	+ SEP #$20 : JML Main_ShowTextMessage

BlindZeldaDespawnFix:
	CMP.b #06 : BEQ +
	LDA.w $0D00,X : BEQ + ; don't despawn follower if maiden isn't "present"
		PLA : PLA : PEA.w SpritePrep_BlindMaiden_despawn_follower-1 : RTL
	+ PLA : PLA : PEA.w SpritePrep_BlindMaiden_kill_the_girl-1 : RTL


BigKeyDoorCheck:
	CPY.w #$001E : BNE + ; skip if it isn't a BK door
	LDA.l DRFlags : AND #$0400 : BNE + ; skip if the flag is set - bk doors can be double-sided
		 PLA : PEA.w RoomDraw_OneSidedShutters_South_onesided_shutter_or_big_key_door-1
+ LDA.w #$0000 : RTL

