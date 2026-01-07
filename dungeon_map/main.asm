pushpc
incsrc hooks.asm

macro WriteGFXSheetPointer(sheet, location)
	pushpc
	org $80CFC0+<sheet>
	db <location>>>16

	org $80D09F+<sheet>
	db <location>>>8

	org $80D17E+<sheet>
	db <location>>>0

	pullpc
endmacro

%WriteGFXSheetPointer($C9, DungeonMapIcons1)
%WriteGFXSheetPointer($CA, DungeonMapIcons2)
%WriteGFXSheetPointer($D5, DungeonMapIcons3)
%WriteGFXSheetPointer($D6, DungeonMapDoorConnectors)

; TR is such a problem child
; %WriteGFXSheetPointer($A6, DungeonMapIcons2)

%WriteGFXSheetPointer($D4, MapSheetD4)

pullpc

incsrc draw_rooms.asm
incsrc map_bg3.asm
incsrc dungeon_switch.asm
incsrc draw_loot.asm
incsrc check_loot.asm
incsrc blink_loot.asm
incsrc mappable_doors.asm
