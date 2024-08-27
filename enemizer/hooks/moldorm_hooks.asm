; adjust oam position after drawing eyes
;ED88E
org $9DD88E
{
    ; original: GiantMoldorm_Draw+5lines (sprite_giant_moldorm.asm)
    ; lda.b OAMPtr : add.w #$0008 : sta.b OAMPtr
    ; INC.b OAMPtr+2 : INC.b OAMPtr+2

	JSL Moldorm_UpdateOamPosition
    NOP #08
}

; set number of eyes
;org $9DDBB2 ;$0EDBB2
;{
    ; LDX.b #$01
	; number of eyes (-1)
    ;0EDBB2 0EDBB3
;    LDX.b #$01
;}

org $85B8BA ; geldman
JSL Sprite_MaybeForceDrawShadow
org $9EAAAC ; stalfos knight
JSL Sprite_MaybeForceDrawShadow
org $9EB209 ; blob
JSL Sprite_MaybeForceDrawShadow
