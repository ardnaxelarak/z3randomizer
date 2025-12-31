; $B9F000
SupertileRoomShapes:
incsrc data/supertile_shapes.asm
warnpc $B9F400

org $B9F400
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

; $B9F480
LootTypeIcons:
dw $1300, $1300, $1300, $1300 ; 00 - nothing
dw $334D, $734D, $335D, $735D ; 01 - unknown - basic chest
dw $330D, $730D, $333D, $733D ; 02 - junk - pot
dw $3307, $3308, $3317, $3318 ; 03 - small key
dw $330A, $730A, $333A, $733A ; 04 - triforce piece
dw $330C, $730C, $333C, $733C ; 05 - safety - heart
dw $330E, $730E, $333E, $733E ; 06 - compass
dw $3307, $3308, $3317, $3318 ; 07 - small key
dw $3305, $7305, $3315, $3316 ; 08 - big key
dw $3309, $7309, $3339, $7339 ; 09 - pendant
dw $330F, $730F, $333F, $733F ; 0A - inventory item - big chest
dw $3309, $7309, $3339, $7339 ; 0B - also pendant
dw $3303, $7303, $B303, $F303 ; 0C - crystal
dw $330A, $730A, $333A, $733A ; 0D - triforce piece
dw $330B, $730B, $333B, $733B ; 0E - triforce
dw $1300, $1300, $1300, $1300 ; 0F - empty (reserved)

; $B9F500
LootTypeMapping:
incsrc data/item_mapping.asm

; $B9F600
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
dw $FFFF : db $FF : dl $FFFFFF
dw $FFFF

; $B9F682
MapHUDPalette:
	dw $0000, $3ED8, $2E54

; $B9F688
