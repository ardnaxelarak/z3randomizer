DamageClassCalc:
	PHA
	LDA.l GanonVulnerabilityItem : BEQ +
	LDA.w SpriteTypeTable, X : CMP.b #$D7 : BNE +
	PLA
	JSL Ganon_CheckAncillaVulnerability
	RTL
+
	LDA.l SpecialWeapons : AND.b #$7F : CMP.b #$06 : BEQ .cane_immune
	PLA
	CMP.b #$01 : BEQ .red_cane
	CMP.b #$2C : BEQ .red_cane
	CMP.b #$31 : BEQ .blue_cane
	CMP.b #$0C : BEQ .beam
	BRA .not_cane_or_beam

.red_cane
	PHA
	LDA.l SpecialWeapons : AND.b #$7F : CMP.b #$04 : BEQ .special_cane
	                                    CMP.b #$05 : BEQ .special_cane
	LDA.l SpecialWeapons : BIT.b #$80 : BNE .cane_immune
	BRA .normal

.blue_cane
	PHA
	LDA.l SpecialWeapons : AND.b #$7F : CMP.b #$03 : BEQ .special_cane
	                                    CMP.b #$05 : BEQ .special_cane
	LDA.l SpecialWeapons : BIT.b #$80 : BNE .cane_immune
	BRA .normal

.cane_immune
	LDA.w SpriteTypeTable, X : CMP.b #$1E : BEQ .normal ; crystal switch
	PLA
	BRA .impervious

.special_cane
	PLA
	LDA.w SpriteTypeTable, X : CMP.b #$D6 : BEQ .unstunned_ganon
	                           CMP.b #$88 : BEQ .mothula
	BRA .special_level

.impervious
	LDA.b #$FF
	RTL

.beam
	PHA
	LDA.l SpecialWeapons : AND.b #$7F : CMP.b #$02 : BNE .normal
	PLA
	LDA.b #$05
	RTL

.normal
	PLA

.not_cane_or_beam
	CMP.b #$07 : BNE .no_change
	LDA.l SpecialWeapons : AND.b #$7F : CMP.b #$01 : BNE .normal_bombs
	LDA.l SpecialWeaponLevel : BEQ .normal_bombs
	LDA.w SpriteTypeTable, X : CMP.b #$D6 : BEQ .unstunned_ganon
	                           CMP.b #$88 : BEQ .mothula
	                           CMP.b #$91 : BEQ .stalfos_knight
	                           CMP.b #$92 : BEQ .helmasaur_king

.special_level
	LDA.l SpecialWeaponLevel
	BRA .done

.mothula
	LDA.l SpecialWeaponLevel
	CMP.b #$04 : BCS .fix_mothula
	BRA .done

.fix_mothula
	LDA.b #$03
	BRA .done

.stalfos_knight
	LDA.l StalfosBombDamage : BEQ .special_level
	LDA.b #$08
	BRA .done

.helmasaur_king
	LDA.w $0DB0, X : CMP.b #$03 : BCS .special_level
	LDA.b #$08
	BRA .done

.unstunned_ganon
	LDA.w $04C5 : CMP.b #$02 : BNE .impervious
	LDA.w $0EE0, X : BNE .impervious
	LDA.b #$34 : STA.w $0EE0, X ; give the poor pig some i-frames
	BRA .special_level

.normal_bombs
	LDA.b #$07

.no_change
	PHX : TAX
	LDA.l $86EC84, X
	PLX
	CMP.b #$06 : BNE .done
	LDA.l BowEquipment : CMP.b #$03 : BCS .actual_silver_arrows

.normal_arrows
	LDA.b #$06

.done
	RTL

.actual_silver_arrows
	LDA.w SpriteTypeTable, X : CMP.b #$D7 : BNE +
	LDA.b #$20 : STA.w SpriteTimerE, X
+	LDA.b #$09
	RTL
;--------------------------------------------------------------------------------
Utility_CheckImpervious:
	LDA.w SpriteControl, X : AND.b #$40 : BNE .impervious
	LDA.w $0CF2 : CMP.b #$FF : BEQ .impervious
	LDA.w UseY1 : AND.b #$0A : BEQ .not_impervious ; normal behavior if not hammering
	JSL Ganon_CheckHammerVulnerability : BCS .not_impervious

.not_impervious
	LDA.b #$00 : RTL
.impervious
	LDA.b #$01 : RTL
;--------------------------------------------------------------------------------
