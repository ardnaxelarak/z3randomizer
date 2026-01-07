; move aga boss icon to correct room
org $8AEE75
db $08

; use AA1 = $1C for map stuff
org $80E193
skip 7
db $D6

org $8AE11D
LDA.b #$1C

org $8AE12B
LDA.b #$20

; change dungeon map subsheet gfx in TR
; org $80DDC9
; db $57

; dungeon map sheets
org $80DD97
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62
db $61, $56, $57, $62

; unused chest data
org $81E9A5
dw $00F0 ; freezor room, second chest (only one chest in supertile)

org $81EA6E
dw $00F0 ; mire spike room, second chest (only one chest in supertile)

org $81EAF8
dw $00F0 ; GT button/switch/bladetrap room (no chest in supertile)

; Dungeon Map Palettes 2-5 left half
org $9BE544
dw $0000, $71E7, $7FFF, $3B5F, $0000, $0000, $7EB5, $1CE7

org $9BE564
dw $0000, $5565, $7FFF, $331C, $0000, $0000, $7E27, $0C63

org $9BE584
dw $0000, $4100, $7FFF, $2656, $4100, $0000, $4100, $4100

org $9BE5A4
dw $0000, $34E0, $7FFF, $34E0, $34E0, $0000, $34E0, $34E0

; move BG1 to main screen in dungeon map screen
org $8AE130
LDA.b #$17 : STA.b $1C
LDA.b #$00 : STA.b $1D

; make skull icon blink opposite our loot icons
org $8AEE2B
	AND.b #$10
	NOP #2
	db $F0 ; BEQ to replace BCS

;================================================================================
; Overhaul of Dungeon Map Screen
;--------------------------------------------------------------------------------
org $8AE64D
	PLX
	JML DrawDungeonMapRoom

org $8AE606
	PLX
	JML DrawNonexistentRoom

org $8AE152
	JSL LoadLastHUDPalette

org $808BD3
	JSL LoadStripes
	BRA + : NOP #9 : +

org $8AEAE8 ; vanilla checks number of sprites drawn instead of... counting...
	LDA.b $0E
	CMP.b #$02

;================================================================================
; Swapping Dungeon in Dungeon Map Screen (L/R)
;--------------------------------------------------------------------------------
org $8AE9A7
	JSL CheckSwitchMap
	BRA + : NOP #3 : +

org $8AEF06
	DEC.b $13
	BNE +
	JML DungeonMapSwitch_Submodule
+	RTL
warnpc $8AEF29

org $8AEADA
	JML SkipMapSprites

org $8AE9C7
	JSL RestoreDungeonMapFloorIndex
	NOP

org $98BC86
	JSL CacheCurrentDungeon

org $8AEFC5
	JSL RestoreCurrentDungeon
	NOP

org $8AE1EC
	PLB
	JML DrawDungeonLabel

org $8AE83E
	JSL StartCurrentRoomSearch
	BRA + : NOP #6 : +

org $8AE86C
	JML FindCurrentRoom
	padbyte $EA
	pad $8AE891

org $8AEBF8
	LDA.w $0217
	SEC : SBC.b $0F
	BMI +
	CMP.b #$18
	BCS +
	skip 7
	+

org $8AEB9A
	db -8, 8, -8, 8
	db -8, -8, 8, 8

;================================================================================
; Show indicators of what is left in each room
;--------------------------------------------------------------------------------
org $8AEABA
	JSL RedrawLoot
	NOP

org $8AE42B
	JSL FirstDrawLoot

;================================================================================
; Blink indicators of what is left in each room
;--------------------------------------------------------------------------------
org $8AE964
	JSL BlinkLoot

org $8AE235
	JSL WriteBigEndianAddressX
org $8AE290
	JSL WriteBigEndianAddressY
org $8AE350
	JSL WriteBigEndianAddressY

org $8AE206
	JSL StartDoubleWrite
	NOP

org $8AE2E0
	JML CheckDoubleWrite
	NOP

org $8AE21C
	JSL DrawMountain
	BRA + : NOP #9 : +

;================================================================================
; Custom Door Rando Maps
;--------------------------------------------------------------------------------
org $8AE590
	JSL PrepDrawRow
	BRA + : NOP #5 : +

org $8AE5F2
	JSR LoadDungeonMapRoomPointer_0A
	STA.b $72

org $8AE600
	LDA.b [$72], Y

org $8AE634
	JSR LoadDungeonMapRoomPointer_0A
	STA.b $72

org $8AE63B
	LDA.b [$72], Y

org $8AE867
	JSR LoadDungeonMapRoomPointer_0A
	STA.b $72

org $8AE872
	LDA.b [$72], Y

org $8AE8DD
	JSR LoadDungeonMapRoomPointer_0A

org $8AE8E4
	STA.b $72

org $8AE8F9
	LDA.b [$72], Y

org $8AEBC6
	JSL GetLocationMarkerLeft
	NOP
