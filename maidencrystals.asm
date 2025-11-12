;================================================================================
; Maiden Crystal Fixes
;================================================================================

pushpc

org $9ECE25
STZ.w $1F00 : NOP : NOP ; fix to allow VRAM corruption during Blind fight

pullpc

;--------------------------------------------------------------------------------
; MaidenCrystalScript
;--------------------------------------------------------------------------------
MaidenCrystalScript:
        LDA.b #$00 : STA.l BusyItem
        STZ.w ItemReceiptID
        STZ.w ItemReceiptPose
        STZ.b LinkAnimationStep
        LDA.b #$02 : STA.w LinkDirection
        LDA.l CrystalsField : AND.b #$7F : CMP.b #$7F : BNE + ; check if we have all crystals
                LDA.b #$08 : STA.l MapIcons ; Update the map icon to just be Ganon's Tower
	+
JML CrystalMaiden_KickOutOfDungeon ; <- F4F35 - sprite_crystal_maiden.asm : 426
;--------------------------------------------------------------------------------
