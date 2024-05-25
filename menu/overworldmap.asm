pushpc

org $8ABABE : JSL WorldMap_LoadChrHalfSlot

org $8ABDF6
WorldMapIcon_DungeonPointers: ; dungeon idx order
dw WorldMapIcon_pos_hc
dw $0000
dw WorldMapIcon_pos_ep
dw WorldMapIcon_pos_dp
dw WorldMapIcon_pos_at
dw WorldMapIcon_pos_sp
dw WorldMapIcon_pos_pod
dw WorldMapIcon_pos_mm

dw WorldMapIcon_pos_sw
dw WorldMapIcon_pos_ip
dw WorldMapIcon_pos_toh
dw WorldMapIcon_pos_tt
dw WorldMapIcon_pos_tr
dw WorldMapIcon_pos_gt

WorldMapIcon_ExtraPointers: ; dungeon idx order
dw WorldMapIcon_extrapos_hc
dw $0000

dw $0000
dw WorldMapIcon_extrapos_dp
dw $0000
dw $0000
dw $0000
dw $0000
dw WorldMapIcon_extrapos_sw
dw $0000

dw $0000
dw $0000
dw WorldMapIcon_extrapos_tr
dw $0000

warnpc $8ABE2E
org $8ABE2E
; located posx/posy, dislocated posx/posy, prize pox/posy
; located = proper location of icon (default: if you have map)
; dislocated = location of icon if proper location is hidden from player
; highest bit on first posx indicates which world it should show in
; $FFxx on X coord means skip drawing
WorldMapIcon_pos:
.hc
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00
.ep
dw $0F31, $0620, $FF00, $FF00, $0F31, $0620
.dp
dw $0108, $0D70, $FF00, $FF00, $0108, $0D70
.at
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00
.sp
dw $8759, $0ED0, $FF00, $FF00, $8759, $0ED0
.pod
dw $8F40, $0620, $FF00, $FF00, $8F40, $0620
.mm
dw $8100, $0CA0, $FF00, $FF00, $8100, $0CA0
.sw
dw $8082, $00B0, $FF00, $FF00, $8082, $00B0
.ip
dw $8CA0, $0DA0, $FF00, $FF00, $8CA0, $0DA0
.toh
dw $08D0, $0080, $FF00, $FF00, $08D0, $0080
.tt
dw $81D0, $0780, $FF00, $FF00, $81D0, $0780
.tr
dw $8F11, $0103, $FF00, $FF00, $8F11, $0103
.gt
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00

warnpc $8ABECA
org $8ABECA
; additional icons posx/posy (terminator = $FFxx)
; additional icons only show if located
; highest bit on posx indicates which world it should show in
WorldMapIcon_extrapos:
.hc
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FFFF
.dp
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FFFF
.sw
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FFFF
.tr
dw $FF00, $FF00, $FF00, $FF00, $FF00, $FF00, $FFFF

; FREE: 0x20 bytes, for any future usage of extra icons ^^^

warnpc $8ABF36
org $8ABF36
; vhpp ccco  tttttttt
; v/h - vert/horiz flip
; p - draw priority
; c - color palette idx
; o - OAM page change
; t - VRAM tile idx
WorldMapIcon_prize_tile:
db $00, $00 ;                ; Hyrule Castle
db $00, $00 ;                ; Sewers
db $38, $62 ; green pendant  ; Eastern Palace
db $34, $60 ; blue pendant   ; Desert Palace
db $00, $00 ;                ; Agahnim's Tower
db $34, $64 ; crystal        ; Swamp Palace
db $34, $64 ; crystal        ; Dark Palace
db $32, $64 ; red crystal    ; Misery Mire
db $34, $64 ; crystal        ; Skull Woods
db $32, $64 ; red crystal    ; Ice Palace
db $32, $60 ; red pendant    ; Tower of Hera
db $34, $64 ; crystal        ; Thieves' Town
db $34, $64 ; crystal        ; Turtle Rock
db $00, $00 ;                ; Ganon's Tower

warnpc $8ABF52
org $8ABF52
WorldMapIcon_dungeon_tile:
db $1A, $7E ; white H ; Hyrule Castle
db $00, $00 ;         ; Sewers
db $14, $7F ; blue 1  ; Eastern Palace
db $14, $79 ; blue 2  ; Desert Palace
db $1A, $7D ; white A ; Agahnim's Tower
db $12, $79 ; red 2   ; Swamp Palace
db $12, $7F ; red 1   ; Dark Palace
db $12, $6F ; red 6   ; Misery Mire
db $12, $6C ; red 3   ; Skull Woods
db $12, $6E ; red 5   ; Ice Palace
db $14, $6C ; blue 3  ; Tower of Hera
db $12, $6D ; red 4   ; Thieves' Town
db $12, $7C ; red 7   ; Turtle Rock
db $12, $66 ; skull   ; Ganon's Tower
; db $22, $68 ; red X

warnpc $8ABF6E
org $8ABF6E
CompassExists:
dw $37F8

; mirror portal fixes
org $8ABF74
db $24, $64, $E4, $A4 ; lowering mirror portal draw priority
org $8ABFFA
db $4C ; use other mirror portal gfx
org $8AC00E
db $01 ; draw in 2nd OAM slot

org $8AC012 ; <- 54012 - Bank0A.asm:1039 (LDA $7EF2DB : AND.b #$20 : BNE BRANCH_DELTA)
BRA + : NOP #6 : + ; skip pyramid open check

; Scrap
; $00/$01 = Dungeon Pointer
; $02/$03 = Extra Pointer
; $04 = Current World
; $05 = Current Dungeon
; $06 = Helper Bitfield
; $0B-$0F = OAM GFX Data
org $8AC02B
DrawPrizesOverride:
	PHB : LDA.b #WorldMapIcon_DungeonPointers>>16 : PHA : PLB
		LDA.l CurrentWorld : STA.b Scrap04
		REP #$20
		LDA.w #$0800+8 : STA.b OAMPtr
		LDA.w #$0A20+2 : STA.b OAMPtr+2
		LDY.b #$1A
		.next_dungeon
		STY.b Scrap05
		REP #$20
		LDA.w WorldMapIcon_DungeonPointers,Y : BNE + : JMP .advance : +
			STA.b Scrap00
			LDA.w WorldMapIcon_ExtraPointers,Y : STA.b Scrap02
			JSR WorldMap_CheckForDungeonState
			LDA.w WorldMapIcon_dungeon_tile,Y : BNE + : JMP .advance : +
			XBA : STA.b Scrap0C
			TAX : CPX.b #$68 : BNE +
				; handle red X animation
				PHX
				LDA.b FrameCounter : LSR #3 : AND.w #$0003 : TAX
				LDA.l WorldMap_RedXChars,X : TAX : STX.b Scrap0D
				PLX : CPX.b #$68
				BRA .do_dungeon
			+
			LDA.b FrameCounter : AND.w #$0010 : BEQ + : JMP .show_prizes : +
				.do_dungeon
				; determine tile size
				LDX.b #$00 : BCS +
					LDX.b #$02
				+ STX.b Scrap0B

				LDA.l CompassMode : AND.w #$00F0 : ORA.b Scrap06
				BIT.w #$0040 : BEQ .main_dungeon_icon
				BIT.w #$0003 : BEQ .main_dungeon_icon
					; draw additional dungeon icon under prize
					LDY.b #$08 ; 8 is located
					BIT.w #$0002 : BNE +
						LDY.b #$04 ; 4 is dislocated
					+
					JSR WorldMap_ValidateCoords : BCS .main_dungeon_icon
					JSR WorldMap_DrawTile

				; determine located/dislocated/hidden
				.main_dungeon_icon
				LDA.l CompassMode : AND.w #$00F0 : ORA.b Scrap06
				BIT.w #$0020 : BEQ + : BIT.w #$0004 : BNE .show_dungeon ; compass mode, show dungeon icon if its allowed to
				+ BIT.w #$0001 : BNE + : JMP .advance : + ; hidden
				.show_dungeon
				LDY.b #$00 ; 0 is located
				BIT.w #$0004 : BNE + : BIT.w #$0030 : BEQ +
					LDY.b #$04 ; 4 is dislocated
				+

				; determine if draw and/or continue
				JSR WorldMap_ValidateCoords : BCC +
					BNE .extras : BRA .advance
				+
				JSR WorldMap_DrawTile

				; TODO: draw X if prize icon is X?... here?
				.extras
				CPY.b #$04 : BCS .advance ; dislocated dungeon skips extras
				LDA.b Scrap02 : BEQ .advance : STA.b Scrap00
				LDY.b #$00
				.next_icon
				JSR WorldMap_ValidateCoords : BCC +
					BEQ .advance : INY #4 : BRA .next_icon
				+
				JSR WorldMap_DrawTile
				BRA .next_icon
			.show_prizes
			LDA.w WorldMapIcon_prize_tile,Y : BEQ .advance
			XBA : STA.b Scrap0C
			LDX.b #$02 : STX.b Scrap0B ; all prize icons are wide

			; determine located/dislocated/unknown
			LDA.l CompassMode : AND.w #$00F0 : ORA.b Scrap06
			LDY.b #$04 ; 4 is dislocated
			BIT.w #$0003 : BEQ .advance
			BIT.w #$0002 : BEQ +
				LDY.b #$08 ; 8 is located
				BIT.w #$0001 : BNE +
					; don't know what prize
					BIT.w #$0040 : BEQ .advance
						; red X
						STZ.b Scrap0B
						LDA.b FrameCounter : LSR #3 : AND.w #$0003 : TAX
						LDA.l WorldMap_RedXChars,X : AND.w #$00FF : ORA.w #$2200 : STA.b Scrap0C
			+

			; determine if draw and/or continue
			JSR WorldMap_ValidateCoords : BCS .advance
			JSR WorldMap_DrawTile
		.advance
		LDY.b Scrap05 : DEY #2 : BMI + : JMP .next_dungeon : +
	PLB
	PLA : XBA : STA.l $7EC10A
	PLA : XBA : STA.l $7EC108
	SEP #$20
RTS

; returns with C set if we skip drawing
; returns with Z unset if we want to continue loop for this dungeon
WorldMap_ValidateCoords:
	; checks if icon is valid
	LDA.b (Scrap00),Y : CMP.w #$FF00 : LDX.b #$00 : BCS .fail ; exits with C and Z set
	BIT.w #$8000 : BEQ +
		LDX.b #$40
	+
	; checks if icon is for this world
	CPX.b Scrap04 : BNE .fail ; exits with C set and Z unset
	AND.w #$7FFF : STA.l $7EC10A
	INY #2 : LDA.b (Scrap00),Y : STA.l $7EC108
	INY #2
CLC : RTS
.fail
SEC : RTS

WorldMap_DrawTile:
	SEP #$20
	LDX.b Scrap0B : TXA : STA.b (OAMPtr+2)
	INC.b OAMPtr+2
	LDA.b Scrap00 : PHA
	JSR WorldMap_CalculateOAMCoordinates
	PLA : STA.b Scrap00
	LDX.b Scrap0B : BEQ +
		LDA.b Scrap0E : SEC : SBC.b #$04 : STA.b Scrap0E
		LDA.b Scrap0F : SEC : SBC.b #$04 : STA.b Scrap0F
    +
	REP #$20
	LDA.b Scrap0E : STA.b (OAMPtr)
	INC.b OAMPtr : INC.b OAMPtr
	LDA.b Scrap0C : STA.b (OAMPtr)
	INC.b OAMPtr : INC.b OAMPtr
RTS

; Y - dungeon index
; TODO: This is terribly inefficient and needs to be rewritten someday
; DungeonItemMasks = 16-bit mask for bitfields
; DungeonsCompleted = 16-bit bitfield for beaten bosses
; MapMode = flag is maps are not wild
; MapField = 16-bit bitfield for collected maps
; MapOverlay = 16-bit bitfield for revealed prizes via Saha/Bomb Shop
; CompassMode = (repurposed version of MapMode above)
;    0x80 = flag is compasses are not wild (similar to MapMode)
;    0x10 = Maps reveals location of dungeons
;    0x20 = Compass reveals location of dungeons
;    0x40 = Boss kill reveals location of prize
; CompassField = 16-bit bitfield for collected compasses
WorldMap_CheckForDungeonState:
	PHY : TYX
		LDY.b #$00 ; used as bitfield
		; determine if prize is revealed
		LDA.l MapMode : AND.w #$0001 : BEQ .setRevealPrize ; 0 = always show, 1 = requires map
		LDA.l MapField : ORA.l MapOverlay : AND.l DungeonItemMasks,X : BEQ +
			.setRevealPrize
			TYA : ORA.w #$0001 : TAY
		+

		; determine if prize is located
		LDA.l CompassMode : BIT.w #$0040 : BEQ + ; boss defeated
			JSR WorldMap_CheckPrizeCollected : BCC ++
				TYA : AND.w #$00FC : TAY ; prize collected, hide prize icons
				BRA .dungeon_icon
			++ LDA.l DungeonsCompleted : AND.l DungeonItemMasks,X : BEQ ++
				.setLocatePrize
				TYA : ORA.w #$0002 : TAY
				BRA .dungeon_icon
			++ LDA.l MapOverlay : AND.l DungeonItemMasks,X : BNE .setLocatePrize
			BRA .dungeon_icon
		+ BIT.w #$0030 : BNE + ; Default ow map
			.defaultPrizeCheck
			LDA.l MapMode : AND.w #$00FF : BEQ .setLocatePrize ; 0 = always show, 1 = requires map
			LDA.l MapField : ORA.l MapOverlay : AND.l DungeonItemMasks,X : BNE .setLocatePrize
			BRA .dungeon_icon
		+ BIT.w #$0020 : BEQ + ; compass collected
			BIT.w #$0080 : BEQ .setLocatePrize ; 0 = always show, 1 = require compass
			LDA.l CompassExists : AND.l DungeonItemMasks,X : BEQ .setLocatePrize
			LDA.l CompassField : ORA.l MapOverlay : AND.l DungeonItemMasks,X : BNE .setLocatePrize
		+ LDA.l CompassMode : BIT.w #$0010 : BNE .defaultPrizeCheck ; map collected

		; determine if dungeon is located
		.dungeon_icon
		LDA.l CompassMode : BIT.w #$0020 : BEQ + ; compass collected
			BIT.w #$0080 : BEQ .setLocateDungeon ; 0 = always show, 1 = require compass
			LDA.l CompassExists : AND.l DungeonItemMasks,X : BEQ .setLocateDungeon
			LDA.l CompassField : AND.l DungeonItemMasks,X : BNE .setLocateDungeon
		+ ; Overworld Map: Default or Map option
		LDA.l MapMode : AND.w #$00FF : BNE + ; 0 = always show, 1 = requires map
		LDA.l MapField : AND.l DungeonItemMasks,X : BEQ +
			.setLocateDungeon
			TYA : ORA.w #$0004 : TAY
		+
	.continue
	STY.b Scrap06
	PLY
RTS

WorldMap_CheckPrizeCollected:
	PHX
		TXA : LSR : TAX
		LDA.l CrystalPendantFlags_3,X : AND.w #$00FF : BEQ .prize_not_collected
			CMP.w #$0008 : LDA.l CrystalPendantFlags,X : BCS .pendant
				AND.l CrystalsField : BRA .check
				.pendant
				AND.l PendantsField
			.check
			AND.w #$00FF : BEQ .prize_not_collected
			PLX : SEC : RTS
		.prize_not_collected
	PLX : CLC
RTS

WorldMap_LoadChrHalfSlot:
	JSL Graphics_LoadChrHalfSlot ; what we wrote over

	PHB : LDA.b #$7F : PHA : PLB
	LDA.b #PreloadedGraphicsROM>>16 : STA.b Scrap02
	REP #$20
	LDX.b GameSubMode : CPX.b #$07 : BEQ .not_flute_menu
		REP #$10
		LDX.w #(.list_end-.list_flute)-6

		.next_flute_group
		LDA.l .list_flute+4,X : TAY
		LDA.l .list_flute+2,X : STA.b Scrap03
		LDA.l .list_flute,X : STA.b Scrap00
			- LDA.b [$00],Y : STA.b ($03),Y : DEY #2 : BPL -
		TXA : SBC.w #6 : TAX : BPL .next_flute_group ; SEC is always set
		BRA .return

	.not_flute_menu
	REP #$10
	LDX.w #(.list_flute-.list)-6

	.next_group
	LDA.l .list+4,X : TAY
	LDA.l .list+2,X : STA.b Scrap03
	LDA.l .list,X : STA.b Scrap00
		- LDA.b [$00],Y : STA.b ($03),Y : DEY #2 : BPL -
	TXA : SBC.w #6 : TAX : BPL .next_group ; SEC is always set

	.return
	SEP #$30
	PLB
RTL

; from (bank $A2 only), to (bank $7F only), length
.list
dw #PreloadedGraphicsROM+$140, $7F1140, $C0-2
dw #PreloadedGraphicsROM+$320, $7F1320, $E0-2
.list_flute
dw #PreloadedGraphicsROM+$120, $7F13C0, $20-2
.list_end

warnpc $8AC3B1
pullpc
