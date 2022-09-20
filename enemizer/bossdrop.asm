;================================================================================
; Fix boss item drop position to 'center' of screen
;================================================================================
change_heartcontainer_position:
{
    PHA
    	LDA.l !CENTER_BOSS_DROP_FLAG : BEQ .not_moldorm_room
		LDA.b #$78 : STA $0D10, X
					 STA $0D00, X

		LDA $23 : STA $0D30, X
		LDA $21 : STA $0D20, X

		LDA $A0 : CMP #$07 : BNE .not_moldorm_room  ; not moldorm room
		LDA $22 : STA $0D10, X
		LDA $20 : STA $0D00, X

    .not_moldorm_room
    
    PLA
    JSL Sprite_Get16BitCoords_long
    RTL 
}