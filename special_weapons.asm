;--------------------------------------------------------------------------------
!ANCILLA_DAMAGE = "$06EC84"
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
	LDA SpecialWeapons : CMP #$06 : BEQ .cane_immune ; only crystal switches in bee mode
	PLA
	CMP #$01 : BEQ .red_cane
	CMP #$2C : BEQ .red_cane
	CMP #$31 : BEQ .blue_cane
	CMP #$0C : BEQ .beam
	BRA .not_cane_or_beam
.red_cane
	PHA
	LDA SpecialWeapons : CMP #$01 : BEQ .cane_immune
	                     CMP #$03 : BEQ .cane_immune
	                     CMP #$04 : BEQ .special_cane
	                     CMP #$05 : BEQ .special_cane
	BRA .normal
.blue_cane
	PHA
	LDA SpecialWeapons : CMP #$01 : BEQ .cane_immune
	                     CMP #$03 : BEQ .special_cane
	                     CMP #$04 : BEQ .cane_immune
	                     CMP #$05 : BEQ .special_cane
	BRA .normal
.cane_immune
	LDA $0E20, X : CMP.b #$1E : BEQ .normal ; crystal switch
	PLA
	BRA .impervious
.special_cane
	PLA
	LDA $0E20, X : CMP.b #$D6 : BEQ .unstunned_ganon
	CMP.b #$88 : BEQ .mothula
	BRA .special_level
.impervious
	LDA #$FF
	RTL
.beam
	PHA
	LDA SpecialWeapons : CMP #$02 : BNE .normal
	PLA
	LDA #$05
	RTL
.normal
	PLA
.not_cane_or_beam
	CMP #$07 : BNE .no_change
	LDA SpecialWeapons : CMP #$01 : BNE .normal_bombs
	LDA !WEAPON_LEVEL : BEQ .normal_bombs
	LDA $0E20, X : CMP.b #$D6 : BEQ .unstunned_ganon
	CMP.b #$D7 : BEQ .stunned_ganon
	CMP.b #$88 : BEQ .mothula
	CMP.b #$91 : BEQ .stalfos_knight
	CMP.b #$92 : BEQ .helmasaur_king
.special_level
	LDA !WEAPON_LEVEL
	BRA .done
.mothula
	LDA !WEAPON_LEVEL
	CMP #$04 : !BGE .fix_mothula
	BRA .done
.fix_mothula
	LDA #$03
	BRA .done
.stalfos_knight
	LDA !StalfosBombDamage : BEQ .special_level
	LDA #$08
	BRA .done
.helmasaur_king
	LDA $0DB0, X : CMP #$03 : !BGE .special_level
	LDA #$08
	BRA .done
.unstunned_ganon
	LDA $04C5 : CMP.b #$02 : BNE .impervious
	LDA $0EE0, X : BNE .impervious
	LDA #$34 : STA $0EE0, X ; give the poor pig some iframes
	BRA .special_level
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
	LDA SpecialWeapons : CMP #$01 : BEQ .normal_arrows
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
.giant_moldorm
	LDA $0E10, Y : BNE .ignore_collision ; Moldy can have little a I-Frames, as a treat
	LDA.l SpecialWeapons : CMP #$01 : BNE ++
	LDA $0C4A, X : CMP #$07 : BEQ .check_collision_moldorm
	BRA .ignore_collision ; don't collide with non-bombs
++ : LDA.l SpecialWeapons : CMP #$03 : BNE ++
	LDA $0C4A, X : CMP #$31 : BEQ .check_collision_moldorm
	BRA .ignore_collision ; don't collide with non-byrna
++ : LDA.l SpecialWeapons : CMP #$04 : BNE ++
	LDA $0C4A, X : CMP #$01 : BEQ .check_collision_moldorm
	               CMP #$2C : BEQ .check_collision_moldorm
	BRA .ignore_collision ; don't collide with non-somaria
++ : LDA.l SpecialWeapons : CMP #$05 : BNE .ignore_collision
	LDA $0C4A, X : CMP #$01 : BEQ .check_collision_moldorm
	               CMP #$2C : BEQ .check_collision_moldorm
	               CMP #$31 : BEQ .check_collision_moldorm
	BRA .ignore_collision ; don't collide with non-canes

.check_collision_moldorm
	JSR SetUpMoldormHitbox
	JSL !UTILITY_CHECK_IF_HIT_BOXES_OVERLAP_LONG
	RTL

.ignore_collision
	CLC
	RTL

.trinexx
	LDA.l SpecialWeapons : CMP #$01 : BNE ++
	LDA $0C4A, X : CMP #$07 : BEQ .check_collision_trinexx
	BRA .ignore_collision ; don't collide with non-bombs
++ : LDA.l SpecialWeapons : CMP #$03 : BNE ++
	LDA $0C4A, X : CMP #$31 : BEQ .check_collision_trinexx
	JMP .ignore_collision ; don't collide with non-byrna
++ : LDA.l SpecialWeapons : CMP #$04 : BNE ++
	LDA $0C4A, X : CMP #$01 : BEQ .check_collision_trinexx
	               CMP #$2C : BEQ .check_collision_trinexx
	JMP .ignore_collision ; don't collide with non-somaria
++ : LDA.l SpecialWeapons : CMP #$05 : BNE .ignore_collision
	LDA $0C4A, X : CMP #$01 : BEQ .check_collision_trinexx
	               CMP #$2C : BEQ .check_collision_trinexx
	               CMP #$31 : BEQ .check_collision_trinexx
	JMP .ignore_collision ; don't collide with non-canes

.check_collision_trinexx
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
	LDA.l SpecialWeapons : CMP #$01 : BNE ++
	LDA $0C4A, X : CMP #$07 : BEQ .collide
	BRA .normal ; normal behavior with non-bombs
++ : LDA.l SpecialWeapons : CMP #$03 : BNE ++
	LDA $0C4A, X : CMP #$31 : BEQ .collide
	BRA .normal ; normal behavior with non-byrna
++ : LDA.l SpecialWeapons : CMP #$04 : BNE ++
	LDA $0C4A, X : CMP #$01 : BEQ .collide
	               CMP #$2C : BEQ .collide
	BRA .normal ; normal behavior with non-somaria
++ : LDA.l SpecialWeapons : CMP #$05 : BNE .normal
	LDA $0C4A, X : CMP #$01 : BEQ .collide
	               CMP #$2C : BEQ .collide
	               CMP #$31 : BEQ .collide
	BRA .normal ; normal behavior with non-canes
.collide
	CLC
	RTL
.normal
	LDA $0DB0, Y : CMP.b #$03
	RTL
; returns carry set if there is collision immunity
;--------------------------------------------------------------------------------
Utility_CheckHammerHelmasaurKingMask:
	LDA.l SpecialWeapons : CMP #$01 : BEQ .no_effect
	LDA $0301 : AND #$0A
	RTL
.no_effect
	LDA #$00
	RTL
;--------------------------------------------------------------------------------
Utility_CheckImpervious:
	LDA $0E20, X : CMP.b #$CB : BNE .normal
.trinexx
	LDA SpecialWeapons : CMP #$01 : BEQ +
	                     CMP #$03 : BEQ +
	                     CMP #$04 : BEQ +
	                     CMP #$05 : BEQ +
	                     CMP #$06 : BEQ .check_sidenexx
	BRA .normal
+
	LDA $0301 : AND.b #$0A : BNE .impervious ; impervious to hammer
.check_sidenexx
	LDA.w $0DD1 : ORA.w $0DD2 : BNE .impervious ; at least one sidenexx alive
	LDA.w $0D80, X : CMP.b #$02 : BCS .impervious ; at least one sidenexx alive
	BRA .not_impervious
.normal
	LDA $0E60, X : AND.b #$40 : BNE .impervious
	LDA $0CF2 : CMP #$FF : BEQ .impervious ; special "always-impervious" class
	LDA $0E20, X : CMP.b #$CC : BEQ .sidenexx : CMP.b #$CD : BEQ .sidenexx
	LDA $0301 : AND.b #$0A : BEQ .not_impervious ; normal behavior if not hammer
	JSL Ganon_CheckHammerVulnerability : BCS .not_impervious
	LDA SpecialWeapons : CMP #$01 : BEQ +
	                     CMP #$03 : BEQ +
	                     CMP #$04 : BEQ +
	                     CMP #$05 : BEQ +
	BRA .not_impervious
+
	LDA $0E20, X : CMP.b #$1E : BEQ .not_impervious ; crystal switch
	CMP.b #$40 : BEQ .not_impervious ; aga barrier
	BRA .impervious
.not_impervious
	LDA #$00 : RTL
.impervious
	LDA #$01 : RTL
.sidenexx
	LDA $0CAA, X : AND.b #$04 : BEQ .vulnerable
	LDA SpecialWeapons : CMP #$01 : BEQ +
	                     CMP #$03 : BEQ +
	                     CMP #$04 : BEQ +
	                     CMP #$05 : BEQ +
	BRA .not_impervious
+
	LDA $0CF2 : CMP #$06 : !BLT .impervious ; swords are ineffective
	BRA .not_impervious
.vulnerable
	LDA SpecialWeapons : CMP #$01 : BEQ +
	                     CMP #$03 : BEQ +
	                     CMP #$04 : BEQ +
	                     CMP #$05 : BEQ +
	BRA .not_impervious
+
	LDA $0CF2 : CMP #$06 : !BGE .impervious ; non-swords are ineffective
	BRA .not_impervious
; returns nonzero A if impervious
;--------------------------------------------------------------------------------
!SPRITE_INITIALIZED_SEGMENTED = "$1DD6D1"
; start with X = sprite index
;--------------------------------------------------------------------------------
AllowBombingMoldorm:
	LDA SpecialWeapons : CMP #$01 : BEQ .no_disable_projectiles
	                     CMP #$03 : BEQ .no_disable_projectiles
	                     CMP #$04 : BEQ .no_disable_projectiles
	                     CMP #$05 : BEQ .no_disable_projectiles
	                     CMP #$06 : BEQ .no_disable_projectiles
	INC $0BA0, X
.no_disable_projectiles
	JSL !SPRITE_INITIALIZED_SEGMENTED
	RTL
;--------------------------------------------------------------------------------
AllowBombingBarrier:
	; what we wrote over
	LDA $0D00, X : !SUB.b #$0C : STA $0D00, X
	LDA $0E20, X : CMP #$40 : BNE .disable_projectiles
	LDA SpecialWeapons : CMP #$01 : BEQ .no_disable_projectiles
	                     CMP #$03 : BEQ .no_disable_projectiles
	                     CMP #$04 : BEQ .no_disable_projectiles
	                     CMP #$05 : BEQ .no_disable_projectiles
	                     CMP #$06 : BEQ .no_disable_projectiles
.disable_projectiles
	INC $0BA0, X
.no_disable_projectiles
	RTL
;--------------------------------------------------------------------------------
DrawBombInMenu:
	JSL LoadBombCount16 : AND.w #$00FF : BEQ .noBombs
	LDA SpecialWeapons : AND.w #$00FF : CMP.w #$0001 : BNE .vanillaBombs
	LDA.l !WEAPON_LEVEL : AND.w #$00FF : BEQ .noBombs : STA $02
	LDA.w #$FC81 : STA $04
	BRA .done
.vanillaBombs
	LDA.w #$0001 : STA $02
	LDA.w #$F699 : STA $04
	BRA .done
.noBombs
	LDA.w #$0000 : STA $02
	LDA.w #$F699 : STA $04
.done
	RTL
;--------------------------------------------------------------------------------
DrawSwordInMenu:
	LDA SpecialWeapons : AND.w #$00FF : CMP.w #$0001 : BEQ .specialSword
	                                    CMP.w #$0003 : BEQ .specialSword
	                                    CMP.w #$0004 : BEQ .specialSword
	                                    CMP.w #$0005 : BEQ .specialSword
	LDA $7EF359 : AND.w #$00FF : CMP.w #$00FF : BEQ .noSword
.hasSword
	STA $02
	LDA.w #$F859 : STA $04
	RTL
.noSword
	LDA.w #$0000 : STA $02
	LDA.w #$F859 : STA $04
	RTL
.specialSword
	LDA !WEAPON_LEVEL : AND.w #$00FF : STA $02
	LDA.w #$FC51 : STA $04
	RTL
;--------------------------------------------------------------------------------
DrawBombInYBox:
	CPX.w #$0004 : BNE .done
	LDA SpecialWeapons : AND.w #$00FF : CMP.w #$0001 : BNE .vanilla
	LDA !WEAPON_LEVEL : AND.w #$00FF : CLC : ADC.w #$00BD : BRA .done
.vanilla
	LDA.w #$0001
.done
	RTL
;--------------------------------------------------------------------------------
BombIcon:
	dw $207F, $207F, $3C88, $3C89, $2C88, $2C89, $2488, $2489, $2888, $2889,$2888, $2889
DrawBombOnHud:
	PHB
	LDA.w #$0149
	LDX.w #$86B0
	LDY.w #$C700
	MVN $7E, $21
	PLB

	LDA.l SpecialWeapons : AND.w #$00FF : CMP.w #$0001 : BNE .regularBombs
	LDA.l !WEAPON_LEVEL : AND.w #$00FF : ASL #2 : TAX
	LDA.l BombIcon, X : STA.l $7EC71A
	LDA.l BombIcon+2, X : STA.l $7EC71C
.regularBombs
	RTL
;--------------------------------------------------------------------------------
BombSpriteColor:
	db $04, $08, $04, $02, $0A, $0A
SetBombSpriteColor:
	LDA.l SpecialWeapons : CMP.b #$01 : BNE .normal
	PHX
	LDA.l !WEAPON_LEVEL
	TAX
	LDA.l BombSpriteColor, X
	STA $0B
	PLX
	RTL
.normal
	LDA #$04 : STA $0B
	RTL
;--------------------------------------------------------------------------------
StoreSwordDamage:
	LDA.l SpecialWeapons : CMP #$02 : BEQ +
	LDA.l $06ED39, X : RTL
	+
	LDA #$05
	RTL
;--------------------------------------------------------------------------------
BeeDamageClass:
	db $FF
	db $06, $00, $07, $08, $0A
	db $0B, $0C, $0D, $0E, $0F
	db $FF, $03, $FF, $FF, $FF
	db $FF, $01, $01, $FF, $FF
CheckDetonateBomb:
	LDA.l SpecialWeapons : CMP.b #$01 : BNE .not_bomb_mode
.detonate_bombs
	LDX.b #09
.check_ancilla
	LDA.w $0C4A, X
	CMP.b #$07
	BNE .next_ancilla
	LDA.b #03
	STA.w $039F, X
.next_ancilla
	DEX
	BPL .check_ancilla
	BRA .done
.not_bomb_mode
	LDA.l SpecialWeapons : CMP.b #$06 : BNE .done
	LDX.w $0202
	LDA.l BeeDamageClass, X : CMP.b #$FF : BEQ .nope
	JSL $1EDCC9
	BMI .nope
	LDX.w $0202
	LDA.l BeeDamageClass, X
	CMP.b #$06 : BNE .set_bee_class
	LDA.l $7EF340 : CMP.b #$03 : !BGE .silver_arrows
	LDA.b #$06
	BRA .set_bee_class
.silver_arrows
	LDA.b #$09
.set_bee_class
	STA.w $0ED0, Y
	BRA .done
.nope
	LDA.b #$3C
	STA.w $0CF8
	JSL $0DBB67
	ORA.w $0CF8
	STA.w $012E
.done
	; what we wrote over
	LDA.b #$80
	TSB.b $3A
	RTL
;--------------------------------------------------------------------------------
SetBeeType:
	LDA.l SpecialWeapons : CMP.b #$06 : BEQ .bee_mode
	LDX.w $0202
.check_bee_type
	LDA.l $7EF33F, X
	TAX
	LDA.l $7EF35B, X
	CMP.b #$08
	BNE .regular_bee
	LDA.b #$01
	STA.w $0EB0, Y
.regular_bee
	LDA.b #$01
	STA.w $0ED0, Y
	RTL
.bee_mode
	LDX.w $0202
	CPX.b #$10 : BEQ .check_bee_type
	BRA .regular_bee
;--------------------------------------------------------------------------------
ArrghusBoing:
	LDA.l SpecialWeapons : CMP.b #$06 : BNE .done
	LDA.w $0F60, X : AND.b #$BF : STA.w $0F60, X
.done
	; what we wrote over
	LDA.b #$03
	STA.w $0D80, X
