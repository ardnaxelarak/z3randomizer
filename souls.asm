;================================================================================
; Boss Souls
;================================================================================
SoulPaletteSet:
	LDA.l SpriteInvincibilityFlag, X
	BEQ .normal
	LDA.b #$FF
	STA.w $0CFE
	RTL
.normal
	CMP.b #$08
	BNE +
		LDA.l $7FFA3C, X
		STA.w $0CFE
	+
	RTL
;================================================================================
SoulPaletteApply:
	AND.w #$F1FF
	PHA
	LDA.w $0CFE
	AND.w #$00FF
	CMP.w #$00FF
	BEQ .blackout
.ice
	PLA
	ORA.w #$0400
	RTL
.blackout
	PLA
	ORA.w #$0600
	RTL
;================================================================================
HelmasaurPaletteFix:
	LDA.w $0B89, X
	AND.b #$F1
	PHA
	LDA.l SpriteInvincibilityFlag, X
	BEQ .normal
.blackout
	PLA
	ORA.b #$0A
	STA.w $0B89, X
	RTL
.normal
	PLA
	STA.w $0B89, X
	RTL
;================================================================================
HelmasaurHammerFix:
	LDA.l SpriteInvincibilityFlag, X
	BEQ .normal
	LDA.b #$00
	RTL
.normal
	LDA.w $0301
	AND.b #$0A
	RTL
;================================================================================
MoldormPaletteFix:
.b
	LDA.b #$0B
	BRA .apply
.d
	LDA.b #$0D
.apply
	PHA
	LDA.l SpriteInvincibilityFlag, X
	BEQ .normal
	PLA
	LDA.b #$07
	BRA .write
.normal
	PLA
.write
	STA.w $0F50, X
	RTL
;================================================================================
CheckInvincibleFlag:
	LDA.l SpriteInvincibilityFlag, X
	BEQ .normal
	LDA.w $0E20, X
	SEC
	RTL
.normal
	JML.l IsItReallyAMimic
;================================================================================
CheckBossSoul:
	PHA : PHX
	LDA.b #$00
	STA.l SpriteInvincibilityFlag, X
	; check if boss id
	LDX.b #.boss_ids_end-.boss_ids-1
	TYA

-	CMP.l .boss_ids, X
	BEQ .match

	DEX
	BPL -

.normal
	PLX : PLA
	STA.w $0E60, X
	AND.b #$0F
	STA.w $0F50, X
	RTL

.match
	; X is boss index

	; make palette black
	LDA.b #$00
	LDX.b #$1D
-	STA.l $7EC462, X
	STA.l $7EC662, X
	DEX
	BPL -
	LDA.b #$01
	STA.b $15 ; update palette

	PLX
	LDA.b #$01
	STA.l SpriteInvincibilityFlag, X

	PLA

	ORA.b #$40
	STA.w $06E0, X
	AND.b #$01
	ORA.b #$06
	STA.w $0F50, X
	RTL

.boss_ids:
	db $53 ; armos
	db $54 ; lanmolas
	db $09 ; moldorm
	db $92 ; helma king
	db $8C ; arrghus
	db $8D ; arrghus puff
	db $88 ; mothula
	db $CE ; blind
	db $A2 ; khold
	db $A3 ; khold shell
	db $BD ; vitreous big eye
	db $BE ; vitreous small eye
	db $CB ; trinexx
	db $CC ; trinexx
	db $CD ; trinexx
	db $7A ; agahnim
..end
