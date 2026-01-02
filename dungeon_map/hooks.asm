; move aga boss icon to correct room
org $8AEE75
db $08

; change dungeon map subsheet gfx in TR
org $80DDC9
db $57

; Dungeon Map Palettes 2-5 left half
org $9BE544
dw $0000, $71E7, $7FFF, $3B5F, $0000, $0000, $7EB5, $1CE7

org $9BE564
dw $0000, $34E0, $7FFF, $34E0, $34E0, $0000, $7EB5, $1CE7

org $9BE584
dw $0000, $4100, $7FFF, $2656, $4100, $0000, $7EB5, $1CE7

org $9BE5A4
dw $0000, $5565, $7FFF, $2BE9, $0000, $0000, $7EB5, $1CE7

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
org $8AE64F
	PLX
	JSL DrawDungeonMapRoom
	JMP.w $8AE7F2

org $8AE152
	JSL LoadLastHUDPalette

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
