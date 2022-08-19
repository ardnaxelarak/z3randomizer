;================================================================================
; Floodgate Softlock Fix
;--------------------------------------------------------------------------------
FloodGateAndMasterSwordFollowerReset:
	JSL.l MasterSwordFollowerClear
FloodGateReset:
	LDA.l PersistentFloodgate : BNE +
		LDA OverworldEventDataWRAM+$3B : AND.b #$DF : STA OverworldEventDataWRAM+$3B ; reset water outside floodgate
		LDA OverworldEventDataWRAM+$7B : AND.b #$DF : STA OverworldEventDataWRAM+$7B ; reset water outside swamp palace
		LDA RoomDataWRAM[$010B].low : AND.b #$7F : STA RoomDataWRAM[$010B].low ; clear water inside floodgate
		LDA RoomDataWRAM[$28].high : AND.b #$FE : STA RoomDataWRAM[$28].high ; clear water front room (room 40)
	+
FloodGateResetInner:
	    LDA.l Bugfix_SwampWaterLevel : BEQ .done
	    LDA DRMode : BEQ .check_room_35; Only do the check for room 37 if on door rando
	    LDA.l SwampDrain1HasItem : BEQ .flipper_check
		LDA $7F666F : AND.b #$80 : BEQ .drain_room_37 ; Check if key in room 37 has been collected.
		.flipper_check
		LDA FlippersEquipment : AND.b #$01 : BNE .check_room_35 ; Check for flippers. This can otherwise softlock doors if flooded without flippers and no way to reset.
	.drain_room_37
		LDA RoomDataWRAM[$37].low : AND.b #$7F : STA RoomDataWRAM[$37].low ; clear water room 37 - outer room you shouldn't be able to softlock except in major glitches
	.check_room_35
		LDA.l SwampDrain2HasItem : BEQ .done
		LDA $7F666B : AND.b #$80 : BNE .done ; Check if key in room 35 has been collected.
		; no need to check for flippers on the inner room, as you can't get to the west door no matter what, without flippers.
		LDA RoomDataWRAM[$35].low : AND.b #$7F : STA RoomDataWRAM[$35].low ; clear water room 35 - inner room with the easy key flood softlock
	.done
RTL
;================================================================================
