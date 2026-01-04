; $B9F000
SupertileRoomShapes:
incsrc data/supertile_shapes.asm
warnpc $B9F800
padbyte $FF
pad $B9F800

org $B9F800
DungeonMapData:
	db $02, $04, $00, $00 ; Sewers
	db $1A, $00, $00, $00 ; Hyrule Castle
	db $00, $06, $00, $00 ; Eastern Palace
	db $04, $14, $00, $00 ; Desert Palace
	db $14, $0C, $01, $00 ; Castle Tower
	db $0C, $10, $00, $00 ; Swamp Palace
	db $08, $0A, $00, $00 ; Palace of Darkness
	db $12, $18, $00, $00 ; Misery Mire
	db $0A, $16, $FF, $00 ; Skull Woods
	db $16, $0E, $00, $00 ; Ice Palace
	db $06, $08, $01, $00 ; Tower of Hera
	db $10, $12, $00, $00 ; Thieves Town
	db $0E, $1A, $00, $00 ; Turtle Rock
	db $18, $02, $01, $00 ; Ganon's Tower
	db $1A, $02, $00, $00 ; Extra
	db $1A, $02, $00, $00 ; Extra

struct DungeonMapData DungeonMapData
	.prev: skip 1
	.next: skip 1
	.floor: skip 1
	.unused: skip 1
endstruct

warnpc $B9F880
org $B9F880

LootTypeIcons:
dw $0B00, $0B00, $0B00, $0B00 ; 00 - nothing
dw $2F32, $6F32, $AF32, $EF32 ; 01 - unknown - dot
dw $2B0D, $6B0D, $2B3D, $6B3D ; 02 - junk - pot
dw $2B07, $6B07, $2B17, $2B18 ; 03 - small key
dw $2B0B, $6B0B, $2B3B, $6B3B ; 04 - triforce piece
dw $6B08, $2B08, $EB08, $AB08 ; 05 - safety - plus
dw $2B0E, $6B0E, $2B3E, $6B3E ; 06 - less important item - small chest
dw $AB3A, $EB3A, $2B3A, $6B3A ; 07 - compass
dw $2B07, $6B07, $2B17, $2B18 ; 08 - small key
dw $2B05, $6B05, $2B15, $2B16 ; 09 - big key
dw $2B09, $2B0A, $2B39, $6B39 ; 0A - pendant
dw $2B0F, $6B0F, $2B3F, $6B3F ; 0B - important inventory item - big chest
dw $2B09, $2B0A, $2B39, $6B39 ; 0C - also pendant
dw $6F02, $2B02, $EB02, $AF02 ; 0D - crystal
dw $2B0B, $6B0B, $2B3B, $6B3B ; 0E - triforce piece
dw $2B0C, $6B0C, $2B3C, $6B3C ; 0F - triforce

warnpc $B9F900
org $B9F900
LootTypeMapping:
incsrc data/item_mapping.asm

warnpc $B9FA00
org $B9FA00
; Room ID mappings to bit to check for presence and address of item drop
MiscLocations:
dw $00C8 : db $04 : dl HeartContainer_ArmosKnights
dw $0033 : db $04 : dl HeartContainer_Lanmolas
dw $0007 : db $04 : dl HeartContainer_Moldorm

dw $005A : db $04 : dl HeartContainer_HelmasaurKing
dw $0006 : db $04 : dl HeartContainer_Arrghus
dw $0029 : db $04 : dl HeartContainer_Mothula
dw $00AC : db $04 : dl HeartContainer_Blind
dw $00DE : db $04 : dl HeartContainer_Kholdstare
dw $0090 : db $04 : dl HeartContainer_Vitreous
dw $00A4 : db $04 : dl HeartContainer_Trinexx

dw $0073 : db $05 : dl BonkKey_Desert ; torch
dw $008C : db $05 : dl BonkKey_GTower ; torch
dw $0087 : db $05 : dl StandingKey_Hera

dw $FFFF : db $FF : dl $FFFFFF ; Placeholders
dw $FFFF : db $FF : dl $FFFFFF
dw $FFFF : db $FF : dl $FFFFFF ; Aga 1? ($0020)
dw $FFFF : db $FF : dl $FFFFFF ; Ice Armos? ($001C)
dw $FFFF : db $FF : dl $FFFFFF ; Lanmolas 2? ($0033)
dw $FFFF : db $FF : dl $FFFFFF ; Moldorm 2? ($004D)
dw $FFFF : db $FF : dl $FFFFFF ; Aga 2? ($000D)
dw $FFFF

warnpc $B9FA9A
org $B9FA9A
MapHUDPalette:
	dw $0000, $3ED8, $2E54

warnpc $B9FAA0
org $B9FAA0
PrizeLocations:
dw $00C8 : db $02 ; Armos Knights
dw $0033 : db $03 ; Lanmolas
dw $0006 : db $05 ; Arrghus
dw $005A : db $06 ; Helmasaur King
dw $0090 : db $07 ; Vitreous
dw $0029 : db $08 ; Mothula
dw $00DE : db $09 ; Kholdstare
dw $0007 : db $0A ; Moldorm
dw $00AC : db $0B ; Blind
dw $00A4 : db $0C ; Trinexx
dw $FFFF

warnpc $B9FAC0
org $B9FAC0
SupertileEntrances:
incsrc data/entrance_tiles.asm
warnpc $B9FB00
padbyte $FF
pad $B9FB00

; $B9FB00
DungeonLabels:
dw $2550, $2579 ; Sewers
dw $2550, $2578 ; Hyrule Castle
dw $2561, $256C ; Eastern Palace
dw $2560, $256C ; Desert Palace
dw $255D, $2570 ; Agahnim's Tower
dw $256F, $256C ; Swamp Palace
dw $256C, $2560 ; Palace of Darkness
dw $2569, $2569 ; Misery Mire
dw $256F, $2573 ; Skull Woods
dw $2565, $256C ; Ice Palace
dw $2570, $2564 ; Tower of Hera
dw $2570, $2570 ; Thieves' Town
dw $2570, $256E ; Turtle Rock
dw $2563, $2570 ; Ganon's Tower
dw $25A4, $25A4 ; Reserved
dw $25A4, $25A4 ; Reserved

; $B9FB40

warnpc $B9FF00

org $B9FF00
; $00 - do not show anything
; $01 - show presence of supertile as dark square
; $02 - show presence of quadrants as dark squares
; $03 - show outline of shape with walls but no interior details (palette 5)
; $04 - show dark with stairs but no hole/internal walls (palette 4)
; $05 - show mostly lit with stairs and holes/internal walls (palette 3)
; $06 - show fully lit with stairs and holes/internal walls (palette 2)
ShowRooms:
.default
	db $02
.have_map
	db $05
.have_compass
	db $03
.visited_tile
	db $04
.reserved
	skip 4
warnpc $B9FF08

org $B9FF08
; $00 - do not show anything
; $01 - show presence of unobtained items
; $02 - show category of item
ShowItems:
.default
	db $00
.have_map
	db $00
.have_compass
	db $02
.visited_tile
	db $01
.reserved
	skip 4
warnpc $B9FF10

org $B9FF10
; ---P bepc
; P - dungeon prizes
; b - bosses (and torches in GT, plus hera basement standing item)
; e - enemy drops
; p - pots
; c - chests
ItemSources:
	db $09

AlwaysShowCompass:
	db $01
