LoadDungeonIndicator:
	; what we wrote over
	JSL InitializeTilesets

	LDA.w DungeonID
	CMP.b #DungeonIndicatorMap_end-DungeonIndicatorMap : BCS .done
	TAX
	LDA.l DungeonIndicatorMap, X
	TAX

	LDA.b #$80
	STA.w $2115

	REP #$20
	LDA.w #$7140
	STA.w $2116

	LDY.b #$10

-	LDA.l DungeonIndicatorGfx, X
	STA.w $2118
	INX #2
	DEY #2
	BNE -

	SEP #$20
.done
	RTL

DungeonIndicatorMap:
dw $0000
dw $0000
dw $0010
dw $0020
dw $0040
dw $0060
dw $0050
dw $00A0
dw $0070
dw $0090
dw $0030
dw $0080
dw $00B0
dw $00C0
.end

DungeonIndicatorGfx:
	incbin "menu/dr_dungeon_indicators.2bpp"
.end

