;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
FloodGateAndMasterSwordFollowerReset:
	JSL.l MasterSwordFollowerClear
FloodGateReset:
	LDA.l PersistentFloodgate : BNE +
		LDA $7EF2BB : AND.b #$DF : STA $7EF2BB ; reset water outside floodgate
		LDA $7EF2FB : AND.b #$DF : STA $7EF2FB ; reset water outside swamp palace
		LDA $7EF216 : AND.b #$7F : STA $7EF216 ; clear water inside floodgate
		LDA $7EF051 : AND.b #$FE : STA $7EF051 ; clear water front room (room 40)
	+
FloodGateResetInner:
		LDA.l Bugfix_SwampWaterLevel : BEQ .done
	    LDA $279004 : BEQ .check_room_35; Only do the check for room 37 if on door rando
	    LDA.l SwampDrain1HasItem : BEQ .flipper_check
		LDA $7F666F : AND.b #$80 : BEQ .drain_room_37 ; Check if key in room 37 has been collected.
		.flipper_check
		LDA $7EF356 : AND.b #$01 : BNE .check_room_35 ; Check for flippers. This can otherwise softlock doors if flooded without flippers and no way to reset.
	.drain_room_37
		LDA $7EF06E : AND.b #$7F : STA $7EF06E ; clear water room 37 - outer room you shouldn't be able to softlock except in major glitches
	.check_room_35
		LDA.l SwampDrain2HasItem : BEQ .done
		LDA $7F666B : AND.b #$80 : BNE .done ; Check if key in room 35 has been collected.
		; no need to check for flippers on the inner room, as you can't get to the west door no matter what, without flippers.
		LDA $7EF06A : AND.b #$7F : STA $7EF06A ; clear water room 35 - inner room with the easy key flood softlock
	.done
RTL
;================================================================================
