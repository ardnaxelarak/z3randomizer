;================================================================================
; Dark World Spawn Location Fix & Master Sword Grove Fix
;--------------------------------------------------------------------------------
DarkWorldSaveFix:
	LDA.b #$70 : PHA : PLB ; thing we wrote over - data bank change
	JSL.l MasterSwordFollowerClear
	JML.l StatSaveCounter
;--------------------------------------------------------------------------------
DoWorldFix:
	LDA InvertedMode : BEQ +
		JMP DoWorldFix_Inverted
	+
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
		LDA FollowerIndicator : CMP #$04 : BNE + ; if old man following, skip mirror/aga check
			LDA.l OldManRetrievalWorld
			BRA .noMirror
		+ LDA MirrorEquipment : AND #$02 : BEQ .noMirror ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA ProgressIndicator : CMP.b #$03 : BCS .done ; check if agahnim 1 is alive
	.setLightWorld
	LDA #$00
	.noMirror
	STA CurrentWorld ; set flag to light world
	LDA.l SmithDeleteOnSave : BEQ .transform
		LDA FollowerIndicator
		CMP #$07 : BEQ .clear ; clear frog
		CMP #$08 : BEQ .clear ; clear dwarf - consider flute implications
		BRA .done
		.clear
		LDA.b #$00 : STA FollowerIndicator : BRA .done ; clear follower
	.transform
	LDA FollowerIndicator : CMP #$07 : BNE .done : INC : STA FollowerIndicator ; convert frog to dwarf
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked:
	LDA InvertedMode : BEQ +
		JMP SetDeathWorldChecked_Inverted
	+
	LDA $1B : BEQ .outdoors
		LDA $040C : CMP #$FF : BNE .dungeon
		LDA $A0 : ORA $A1 : BNE ++
			LDA GanonPyramidRespawn : BNE .pyramid ; if flag is set, force respawn at pyramid on death to ganon
	    ++
	.outdoors
JMP DoWorldFix

	.dungeon
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_skip_mirror_check

	.pyramid
	LDA #$40 : STA CurrentWorld ; set flag to dark world
	LDA FollowerIndicator : CMP #$08 : BNE .done : DEC : STA FollowerIndicator : + ; convert dwarf to frog
	.done
RTL
;================================================================================
DoWorldFix_Inverted:
	LDA.l Bugfix_MirrorlessSQToLW : BEQ .skip_mirror_check
		LDA FollowerIndicator : CMP #$04 : BNE + ; if old man following, skip mirror/aga check
			LDA.l OldManRetrievalWorld
			BRA .setWorld
	    + LDA.l MirrorEquipment : AND #$02 : BEQ .noMirror ; check if we have the mirror
	.skip_mirror_check ; alt entrance point
	LDA ProgressIndicator : CMP.b #$03 : BCS .done ; check if agahnim 1 is alive
	.noMirror
	.setDarkWorld
	LDA #$40
	.setWorld
	STA CurrentWorld ; set flag to dark world
	LDA.l SmithDeleteOnSave : BEQ .transform
		LDA FollowerIndicator
		CMP #$07 : BEQ .clear ; clear frog
		CMP #$08 : BEQ .clear ; clear dwarf - consider flute implications
		BRA .done
		.clear
		LDA.b #$00 : STA FollowerIndicator : BRA .done ; clear follower
	.transform
	LDA FollowerIndicator : CMP #$07 : BNE .done : INC : STA FollowerIndicator ; convert frog to dwarf
	.done
RTL
;--------------------------------------------------------------------------------
SetDeathWorldChecked_Inverted:
	LDA $1B : BEQ .outdoors
		LDA $040C : CMP #$FF : BNE .dungeon
		LDA $A0 : ORA $A1 : BNE ++
			LDA GanonPyramidRespawn : BNE .castle ; if flag is set, force respawn at pyramid on death to ganon
		++
	.outdoors
JMP DoWorldFix_Inverted

	.dungeon
	LDA Bugfix_PreAgaDWDungeonDeathToFakeDW : BNE .done ; if the bugfix is enabled, we do nothing on death in dungeon
JMP DoWorldFix_Inverted_skip_mirror_check

	.castle
	LDA #$00 : STA CurrentWorld ; set flag to dark world
	LDA FollowerIndicator : CMP #$07 : BNE + : LDA.b #$08 : STA FollowerIndicator : + ; convert frog to dwarf
	.done
RTL
;================================================================================


;--------------------------------------------------------------------------------
FakeWorldFix:
	LDA FixFakeWorld : BEQ +
		PHX
			LDX $8A : LDA.l OWTileWorldAssoc, X : STA CurrentWorld
		PLX
	+
RTL
;--------------------------------------------------------------------------------
MasterSwordFollowerClear:
	LDA FollowerIndicator
	CMP #$0E : BNE .exit ; clear master sword follower
	LDA.b #$00 : STA FollowerIndicator ; clear follower
.exit
	RTL
;--------------------------------------------------------------------------------
FixAgahnimFollowers:
	LDA.b #$00 : STA FollowerIndicator ; clear follower
	JML PrepDungeonExit ; thing we wrote over

;--------------------------------------------------------------------------------
macro SetMinimum(base,filler,compare)
	LDA.l <compare> : !SUB.l <base> : !BLT ?done
		STA.l <filler>
	?done:
endmacro
RefreshRainAmmo:
	LDA ProgressIndicator : CMP.b #$01 : BEQ .rain ; check if we're in rain state
	RTL
	.rain
		LDA StartingEntrance
		+ CMP.b #$03 : BNE + ; Uncle
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Uncle)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Uncle)
			LDA.l ArrowMode : BEQ ++
			LDA.l BowEquipment : BEQ +++
			++ %SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Uncle)
			+++ BRA .done
		+ CMP.b #$02 : BNE + ; Cell
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Cell)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Cell)
			LDA.l ArrowMode : BEQ ++
			LDA.l BowEquipment : BEQ .done
			++ %SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Cell)
			BRA .done
		+ CMP.b #$04 : BNE + ; Mantle
			%SetMinimum(CurrentMagic,MagicFiller,RainDeathRefillMagic_Mantle)
			%SetMinimum(BombsEquipment,BombsFiller,RainDeathRefillBombs_Mantle)
			LDA.l ArrowMode : BEQ ++
			LDA.l BowEquipment : BEQ .done
			++ %SetMinimum(CurrentArrows,ArrowsFiller,RainDeathRefillArrows_Mantle)
		+
	.done
RTL
;--------------------------------------------------------------------------------
SetEscapeAssist:
	LDA ProgressIndicator : CMP.b #$01 : BNE .no_train ; check if we're in rain state
	.rain
		LDA.l EscapeAssist
		BIT.b #$04 : BEQ + : STA InfiniteMagicModifier : +
		BIT.b #$02 : BEQ + : STA InfiniteBombsModifier : +
		BIT.b #$01 : BEQ + : STA InfiniteArrowsModifier : +
		BRA ++
	.no_train ; choo choo
		LDA.l EscapeAssist
		BIT.b #$40 : BEQ + : STA InfiniteMagicModifier : +
		BIT.b #$20 : BEQ + : STA InfiniteBombsModifier : +
		BIT.b #$10 : BEQ + : STA InfiniteArrowsModifier : +
	++

	LDA.l SpecialWeapons : AND.b #$7F : CMP #$01 : BNE +
	LDA.l SpecialWeaponLevel : BEQ +
	LDA #$01 : STA InfiniteBombsModifier
	+
RTL
;--------------------------------------------------------------------------------
SetSilverBowMode:
	LDA SilverArrowsUseRestriction : BEQ + ; fix bow type for restricted arrow mode
		LDA BowEquipment : CMP.b #$3 : BCC +
		SBC.b #$02 : STA BowEquipment
	+
RTL
;================================================================================
