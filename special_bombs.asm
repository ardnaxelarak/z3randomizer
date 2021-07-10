;--------------------------------------------------------------------------------
!ANCILLA_DAMAGE = "$06EC84"
!BOMB_LEVEL = "$7EF4A8"
; start with X = sprite index, A = ancilla type index
;--------------------------------------------------------------------------------
DamageClassCalc:
	PHA
	LDA GanonVulnerabilityItem : BEQ +
	LDA $0E20, X : CMP #$D7 : BNE +
	PLA
	JSL Ganon_CheckAncillaVulnerability
	RTL
+
	PLA
	CMP #$01 : BEQ .cane
	CMP #$2C : BEQ .cane
	CMP #$31 : BEQ .cane
	BRA .not_cane
.cane
	PHA
	LDA SpecialBombs : BEQ .normal_cane
	LDA $0E20, X : CMP.b #$1E : BEQ .normal_cane ; crystal switch
	PLA
.impervious
	LDA #$FF
	RTL
.normal_cane
	PLA
.not_cane
	CMP #$07 : BNE .no_change
	LDA SpecialBombs : BEQ .normal_bombs
	LDA $0E20, X : CMP.b #$D6 : BEQ .unstunned_ganon
	CMP.b #$D7 : BEQ .stunned_ganon
	CMP.b #$88 : BEQ .mothula
	CMP.b #$92 : BEQ .helmasaur_king
.bomb_level
	LDA !BOMB_LEVEL : INC A
	BRA .done
.mothula
	LDA !BOMB_LEVEL : INC A
	CMP #$04 : !BGE .fix_mothula
	BRA .done
.fix_mothula
	LDA #$03
	BRA .done
.helmasaur_king
	LDA $0DB0, X : CMP #$03 : !BGE .bomb_level
	LDA #$08
	BRA .done
.unstunned_ganon
	LDA $04C5 : CMP.b #$02 : BNE .impervious
	LDA $0EE0, X : BNE .impervious
	LDA #$34 : STA $0EE0, X ; give the poor pig some iframes
	BRA .bomb_level
.stunned_ganon
	LDA $0EE0, X : BNE .impervious
	LDA #$34 : STA $0EE0, X ; give the poor pig some iframes
	LDA #$20 : STA $0F10, X ; knock ganon back or something? idk
	LDA #$09
	BRA .done
.normal_bombs
	LDA #$07
.no_change
	PHX : TAX
	LDA.l !ANCILLA_DAMAGE, X
	PLX
	CMP.b #$06 : BNE .done ; not arrows
	LDA $7EF340 : CMP.b #$03 : !BGE .actual_silver_arrows
.normal_arrows
	LDA #$06
.done
	RTL
.actual_silver_arrows
	LDA $0E20, X : CMP.b #$D7 : BNE +
	LDA SpecialBombs : BNE .normal_arrows
	LDA #$20 : STA $0F10, X
	+
	LDA #$09
	RTL
; end with X = sprite index, A = damage class
;--------------------------------------------------------------------------------
!SPRITE_SETUP_HIT_BOX_LONG = "$0683EA"
!UTILITY_CHECK_IF_HIT_BOXES_OVERLAP_LONG = "$0683E6"
; start with X = ancilla index, Y = sprite index
;--------------------------------------------------------------------------------
Utility_CheckAncillaOverlapWithSprite:
	LDA $0E20, Y : CMP #$09 : BEQ .giant_moldorm
	CMP #$CB : BEQ .trinexx
.not_giant_moldorm ; ordinary collision checking
	PHY : PHX
	TYX
	JSL !SPRITE_SETUP_HIT_BOX_LONG
	PLX : PLY
	JSL !UTILITY_CHECK_IF_HIT_BOXES_OVERLAP_LONG
	RTL
.ignore_collision
	CLC
	RTL
.giant_moldorm
	LDA $0C4A, X : CMP #$07 : BNE .ignore_collision ; don't collide with non-bombs
	LDA.l SpecialBombs : BEQ .ignore_collision
	LDA $0E10, Y : BNE .ignore_collision ; Moldy can have little a I-Frames, as a treat

	JSR SetUpMoldormHitbox
	JSL !UTILITY_CHECK_IF_HIT_BOXES_OVERLAP_LONG
	RTL
.trinexx
	LDA $0C4A, X : CMP #$07 : BNE .ignore_collision ; don't collide with non-bombs
	LDA.l SpecialBombs : BEQ .ignore_collision

	JSR SetUpTrinexxHitbox
	JSL !UTILITY_CHECK_IF_HIT_BOXES_OVERLAP_LONG
	RTL
; returns carry clear if there was no overlap
;--------------------------------------------------------------------------------
SetUpTrinexxHitbox:
	; rearrange trinexx's hitbox to be her middle instead of her head
	LDA $0CAA, Y : PHA
	LDA $0E60, Y : PHA
	LDA $0D10, Y : PHA
	LDA $0D30, Y : PHA
	LDA $0D00, Y : PHA
	LDA $0D20, Y : PHA

	LDA #$80 : STA $0CAA, Y

	PHX
	LDA $0E80, Y : !SUB.l $1DAF28 : AND.b #$7F : TAX

	LDA $7FFC00, X : STA $0D10, Y
	LDA $7FFC80, X : STA $0D30, Y
	LDA $7FFD00, X : STA $0D00, Y
	LDA $7FFD80, X : STA $0D20, Y

	TYX
	STZ $0E60, X

	JSL !SPRITE_SETUP_HIT_BOX_LONG
	PLX

	PLA : STA $0D20, Y
	PLA : STA $0D00, Y
	PLA : STA $0D30, Y
	PLA : STA $0D10, Y
	PLA : STA $0E60, Y
	PLA : STA $0CAA, Y
	RTS
;--------------------------------------------------------------------------------
SetUpMoldormHitbox:
	; rearrange moldorm's hitbox to be his tail instead of his head
	LDA $0D90, Y : PHA
	LDA $0F60, Y : PHA
	LDA $0D10, Y : PHA
	LDA $0D30, Y : PHA
	LDA $0D00, Y : PHA
	LDA $0D20, Y : PHA

	PHY : PHX
	LDA $0E80, Y : !SUB.b #$30 : AND.b #$7F : TAX

	LDA $7FFC00, X : STA $0D10, Y
	LDA $7FFC80, X : STA $0D30, Y
	LDA $7FFD00, X : STA $0D00, Y
	LDA $7FFD80, X : STA $0D20, Y
	LDA #$01 : STA $09D0, Y

	TYX
	STZ $0F60, X

	JSL !SPRITE_SETUP_HIT_BOX_LONG

	PLX : PLY

	PLA : STA $0D20, Y
	PLA : STA $0D00, Y
	PLA : STA $0D30, Y
	PLA : STA $0D10, Y
	PLA : STA $0F60, Y
	PLA : STA $0D90, Y
	RTS
;--------------------------------------------------------------------------------
; start with X = ancilla index, Y = sprite index
Utility_CheckHelmasaurKingCollision:
	LDA $0C4A, X : CMP #$07 : BNE .normal ; normal behavior with non-bombs
	LDA.l SpecialBombs : BEQ .normal
	CLC
	RTL
.normal
	LDA $0DB0, Y : CMP.b #$03
	RTL
; returns carry set if there is collision immunity
;--------------------------------------------------------------------------------
Utility_CheckHammerHelmasaurKingMask:
	LDA.l SpecialBombs : BNE .no_effect
	LDA $0301 : AND #$0A
	RTL
.no_effect
	LDA #$00
	RTL
;--------------------------------------------------------------------------------
Utility_CheckImpervious:
	LDA $0E20, X : CMP.b #$CB : BEQ .trinexx
.normal
	LDA $0E60, X : AND.b #$40 : BNE .impervious
	LDA $0CF2 : CMP #$FF : BEQ .impervious ; special "always-impervious" class
	LDA $0E20, X : CMP.b #$CC : BEQ .sidenexx : CMP.b #$CD : BEQ .sidenexx
	LDA $0301 : AND.b #$0A : BEQ .not_impervious ; normal behavior if not hammer
	JSL Ganon_CheckHammerVulnerability : BCS .not_impervious
	LDA.l SpecialBombs : BEQ .not_impervious
	LDA $0E20, X : CMP.b #$1E : BEQ .not_impervious ; crystal switch
	CMP.b #$40 : BEQ .not_impervious ; aga barrier
	BRA .impervious
.trinexx
	LDA SpecialBombs : BEQ .normal
	LDA $0301 : AND.b #$0A : BNE .impervious ; impervious to hammer
	BRA .not_impervious
.sidenexx
	LDA $0CAA, X : AND.b #$04 : BEQ .vulnerable
	LDA SpecialBombs : BEQ .not_impervious
	LDA $0CF2 : CMP #$06 : !BLT .impervious ; swords are ineffective
	BRA .not_impervious
.vulnerable
	LDA SpecialBombs : BEQ .not_impervious
	LDA $0CF2 : CMP #$06 : !BGE .impervious ; non-swords are ineffective
	BRA .not_impervious
.not_impervious
	LDA #$00 : RTL
.impervious
	LDA #$01 : RTL
; returns nonzero A if impervious
;--------------------------------------------------------------------------------
!SPRITE_INITIALIZED_SEGMENTED = "$1DD6D1"
; start with X = sprite index
;--------------------------------------------------------------------------------
AllowBombingMoldorm:
	LDA SpecialBombs : BNE .no_disable_projectiles
	INC $0BA0, X
.no_disable_projectiles
	JSL !SPRITE_INITIALIZED_SEGMENTED
	RTL
;--------------------------------------------------------------------------------
AllowBombingBarrier:
	; what we wrote over
	LDA $0D00, X : !SUB.b #$0C : STA $0D00, X
	LDA $0E20, X : CMP #$40 : BNE .disable_projectiles
	LDA SpecialBombs : BNE .no_disable_projectiles
.disable_projectiles
	INC $0BA0, X
.no_disable_projectiles
	RTL
;--------------------------------------------------------------------------------
DrawSwordInMenu:
	LDA SpecialBombs : AND.w #$00FF : BNE .bombSword
	LDA $7EF359 : AND.w #$00FF : CMP.w #$00FF : BEQ .noSword
.hasSword
	STA $02
	LDA.w #$F859 : STA $04
	RTL
.noSword
	LDA.w #$0000 : STA $02
	LDA.w #$F859 : STA $04
	RTL
.bombSword
	LDA $7EF4A8 : AND.w #$00FF : STA $02
	LDA.w #$FC51 : STA $04
	RTL
;--------------------------------------------------------------------------------
