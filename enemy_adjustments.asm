;--------------------------------------------------------------------------------
; NewBatInit:
; make sure bats always load LW stats
;--------------------------------------------------------------------------------
NewBatInit:
	CPY.b #$00 : BEQ .light_world
	;check if map id == 240 or 241
	LDA.b RoomIndex : CMP.b #$F0 : BEQ .light_world ;oldman cave1
	CMP.b #$F1 : BEQ .light_world ;oldman cave2
	CMP.b #$B0 : BEQ .light_world ;agahnim statue keese
	CMP.b #$D0 : BEQ .light_world ;agahnim darkmaze

	
	LDA.b #$85 : STA.w SpriteBump, X
	LDA.b #$04 : STA.w SpriteHitPoints, X
RTL
	.light_world
		LDA.b #$80 : STA.w SpriteBump, X
		LDA.b #$01 : STA.w SpriteHitPoints, X
RTL
;--------------------------------------------------------------------------------
NewFireBarDamage:
        LDA.b LinkLayer : CMP.w SpriteLayer, X : BNE .NotSameLayer
                JSL Sprite_AttemptDamageToPlayerPlusRecoilLong
                RTL
.NotSameLayer
RTL
;--------------------------------------------------------------------------------
Sprite_MaybeForceDrawShadow:
	JSL Sprite_PrepOAMCoordLong
	LDA.l DRFlags+1 : AND.b #$08 : BEQ .return
	LDA.b GameMode : CMP.b #$07 : BNE .return
		JSL Sprite_DrawShadowLong
		; LDA.w SpriteTypeTable,X : CMP.b #$91 : BNE .return ; stalfos knight
		; 	; move shadow down by 8 pixels
		; 	+ LDA.w SpriteOAMProperties,X : AND.b #$1F : ASL #2 : TAY : INY ; get OAM offset
		; 	LDA.b (OAMPtr),Y : CLC : ADC.b #$08 : STA.b (OAMPtr),Y
.return
RTL
