pushpc

org $0691B6
JSL SpritePrep_EyegoreNew

org $068839  ; 0xEF
dw #$91B6  ; New sprite_prep
dw #$91B6 ; New sprite_prep

;org $069468 ; These need to go else where
;dw #$BFF7  ; SpriteModule_Active_Bank1E_bounce
;dw #$BFF7  ; SpriteModule_Active_Bank1E_bounce

;org $1E8B21
;JSL FixVectorForMimics

;org $1E8BBB ; New vectors for mimics
;dw #$C795
;dw #$C795

org $0DB818
SpritePrep_LoadProperties:

org $1EC70D
SpritePrep_Eyegore_become_mimic:

;org $06EC08 ; Sprite_AttemptZapDamage
;JSL resetSprite_Mimic : NOP

org $06ED9E ; Sprite_ApplyCalculatedDamage, skip high sprite id early exit
JSL IsItReallyAMimic : NOP

org $06EDA6 ; Sprite_ApplyCalculatedDamage .not_absorbable
JSL notItemSprite_Mimic

pullpc


;FixVectorForMimics:
;	CMP.w $#00EF : BCC .end
;		SBC.w #$0032  ; this puts the vector at the unused bytes at UNREACHABLE_1E8BBB
;	.end
;	AND.w #$00FF ; what we wrote over
;	ASL A
;RTL

; replace SpritePrep_Eyegore if flag is on
SpritePrep_EyegoreNew:
{
    LDA !ENABLE_MIMIC_OVERRIDE : BNE .new
        ; old
        JSL SpritePrep_Eyegore
        RTL

    .new
    LDA $0E20, X : CMP.b #$EF : BCS .mimic ;If sprite id >= EF (unused somaria platform)
        ; seems unnecessary it's just an rtl?
;        JSL $1EC71A ; 0xF471A set eyegore to be only eyegore (.not_goriya?)
    RTL
    .mimic
    	SBC.b #$6C : STA $0E20, X : JSL SpritePrep_LoadProperties ; pretending to be $83 or $84
    	JSL SpritePrep_Eyegore_become_mimic
;        LDA.w $0E20, X : ADC #$6C : STA $0E20, X ; set the sprite back to special mimic
        ; todo? unsure about this code - seems unnecessary
;        LDA $0CAA, X : AND #$FB : ORA #$80 : STA $0CAA, X ; STZ $0CAA, X
RTL
}

;resetSprite_Mimic:
;    LDA !ENABLE_MIMIC_OVERRIDE : BEQ .notMimic ; skip to what it would have done normally
;
;    LDA $0E20, X
;    CMP.b #$EF : BCC .notMimic
;    LDA $0E20, X : SBC.b #$6C : STA $0E20, X ; overwrite the sprite id with eyegore id
;
;.notMimic
;     restore code
;    LDA $0E20, X : CMP.b #$7A
;RTL

IsItReallyAMimic:
	LDA !ENABLE_MIMIC_OVERRIDE : BEQ .continue
	LDA.w $0E20,X : CMP.b #$EF : BEQ .is_mimic
	CMP.b #$F0 : BNE .continue

	.is_mimic
	CLC : RTL

	.continue  ; code we hijacked
	LDA.w $0E20,X
    CMP.b #$D8
RTL

; this is just for killable thieves now
notItemSprite_Mimic:
;     if we set killable thief we want to update the sprite id so it can be killed
    LDA $0E20, X
    CMP.l !KILLABLE_THIEVES_ID : BNE .continue ; thief #$C4 (default is B8/dialog tester)

    ; if we don't have mimic code turned on we want to skip, but we also need to reload the sprite id because we just smoked it with this LDA
;    LDA !ENABLE_MIMIC_OVERRIDE : BEQ .reloadSpriteIdAndSkipMimic ; skip to what it would have done normally

;    LDA $0E20, X ; I hate assembly
;    CMP.b #$EF : BCC .continue
;    SBC.b #$6C : BRA .continue

.changeSpriteId
    LDA #$83 ; load green eyegore sprite id so we can kill the thing

.continue
    ; restore code
    REP #$20 : ASL #2
RTL