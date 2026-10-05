pushpc
incsrc "dungeon_map_hooks.asm"

macro WriteGFXSheetPointer(sheet, location)
	pushpc
	org $80CFC0+{sheet}
	db ^{location}

	org $80D09F+{sheet}
	db >{location}

	org $80D17E+{sheet}
	db <{location}
	pullpc
endmacro

%WriteGFXSheetPointer($C9, DungeonMapIcons1)
%WriteGFXSheetPointer($CA, DungeonMapIcons2)
%WriteGFXSheetPointer($D5, DungeonMapIcons3)
%WriteGFXSheetPointer($D4, MapSheetD4)
%WriteGFXSheetPointer($D6, DungeonMapDoorConnectors)

%WriteGFXSheetPointer($61, DungeonMapIcons4)
%WriteGFXSheetPointer($62, DungeonMapIcons5)
%WriteGFXSheetPointer($63, DungeonMapIcons6)

%WriteGFXSheetPointer($14, DRSheet14)

pullpc

incsrc "doors_dungeon_map.asm"
incsrc "draw_rooms.asm"
incsrc "map_bg3.asm"
incsrc "dungeon_switch.asm"
incsrc "draw_loot.asm"
incsrc "check_loot.asm"
incsrc "loot_hud.asm"
incsrc "blink_loot.asm"
incsrc "data/doors_display.asm"
incsrc "data/spiral_stairs.asm"
incsrc "data/fall_warps.asm"
incsrc "data/split_room.asm"
incsrc "data/doors_connections.asm"
