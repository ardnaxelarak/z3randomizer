LoadStripes:
	CPY.b #$09
	BEQ .dungeon_map
.not_dungeon_map
	LDA.w $80937A, Y
	STA.b $00
	LDA.w $809383,Y
	STA.b $01
	LDA.w $80938C,Y
	STA.b $02
	RTL

.dungeon_map
	LDA.l DungeonMapMode
	CMP.b #$01
	BEQ .doors

.not_doors
	LDA.b #BG3DungeonMapStripes>>0
	STA.b $00
	LDA.b #BG3DungeonMapStripes>>8
	STA.b $01
	LDA.b #BG3DungeonMapStripes>>16
	STA.b $02
	RTL

.doors
	LDA.b #BG3DungeonMapDoorStripes>>0
	STA.b $00
	LDA.b #BG3DungeonMapDoorStripes>>8
	STA.b $01
	LDA.b #BG3DungeonMapDoorStripes>>16
	STA.b $02
	RTL

LoadLastHUDPalette:
	; what we wrote over
	JSL $9BEE52

	REP #$20
	LDA.l MapHUDPalette
	STA.l PaletteBuffer+$3A
	LDA.l MapHUDPalette+2
	STA.l PaletteBuffer+$3C
	LDA.l MapHUDPalette+4
	STA.l PaletteBuffer+$3E
	SEP #$20
	RTL

macro VanillaCommonMapStripes()
	dw $4260, $0100, $2100
	dw $4360, $0E40, $2101
	dw $4B60, $0100, $6100
	dw $6260, $2EC0, $2110
	dw $6B60, $2EC0, $6110
	dw $6263, $0100, $A100
	dw $6363, $0E40, $A101
	dw $6B63, $0100, $E100
	dw $8460, $0B00, $2102, $2103, $2104, $2105, $2106, $2107
	dw $A460, $0B00, $2112, $2113, $2114, $2115, $2116, $2117
	dw $5D60, $0100, $6100
	dw $7D60, $2EC0, $6110
	dw $7D63, $0100, $E100
	dw $0060, $7E40, $2111
	dw $8063, $3E41, $2111
	dw $0060, $3EC0, $2111
	dw $0160, $3EC0, $2111
	dw $0C60, $3EC0, $2111
	dw $0D60, $3EC0, $2111
	dw $1E60, $3EC0, $2111
	dw $1F60, $3EC0, $2111
endmacro


BG3DungeonMapStripes:
%VanillaCommonMapStripes()
; left edge of map border, from vanilla
dw $4E60, $0100, $2100
dw $4F60, $1A40, $2101
dw $6E60, $2EC0, $2110
dw $6E63, $0100, $A100
dw $6F63, $1A40, $A101

; horizontal borders
dw $7260, $1240, $1D11
dw $D261, $1240, $1D11
dw $F261, $1240, $1D11
dw $5263, $1240, $1D11

; vertical borders
dw $7160, $2EC0, $1D11
dw $7C60, $2EC0, $1D11

macro TopOfSquares(start)
	; silly Big Endian
	db <start>>>8, <start>, $00, $13
	dw $5D4C, $1D4C, $5D4C, $1D4C, $5D4C, $1D4C, $5D4C, $1D4C, $5D4C, $1D4C
endmacro

macro BottomOfSquares(start)
	; silly Big Endian
	db <start>>>8, <start>, $00, $13
	dw $DD4C, $9D4C, $DD4C, $9D4C, $DD4C, $9D4C, $DD4C, $9D4C, $DD4C, $9D4C
endmacro

macro FullRow(start)
	%TopOfSquares(<start>)
	%BottomOfSquares(<start>+$20)
endmacro

; top grid
%FullRow($6092)
%FullRow($60D2)
%FullRow($6112)
%FullRow($6152)
%FullRow($6192)

%FullRow($6212)
%FullRow($6252)
%FullRow($6292)
%FullRow($62D2)
%FullRow($6312)

db $FF

BG3DungeonMapDoorStripes:
%VanillaCommonMapStripes()
; left edge of map border, adjusted from vanilla
dw $4D60, $0100, $2100
dw $4E60, $1C40, $2101
dw $6D60, $2EC0, $2110
dw $6D63, $0100, $A100
dw $6E63, $1C40, $A101

; horizontal borders
dw $B160, $1440, $1D11
dw $1161, $1440, $1D11
dw $7161, $1440, $1D11
dw $D161, $1440, $1D11
dw $3162, $1440, $1D11
dw $9162, $1440, $1D11
dw $F162, $1440, $1D11
dw $5163, $1440, $1D11

; vertical borders
dw $B060, $12C0, $1D11
dw $BC60, $12C0, $1D11
dw $3062, $12C0, $1D11
dw $3C62, $12C0, $1D11

macro TopOfDoorSquares(start)
	; silly Big Endian
	db <start>>>8, <start>, $00, $15
	dw $5D4C, $1D4C, $1D11, $5D4C, $1D4C, $1D11, $5D4C, $1D4C, $1D11, $5D4C, $1D4C
endmacro

macro BottomOfDoorSquares(start)
	; silly Big Endian
	db <start>>>8, <start>, $00, $15
	dw $DD4C, $9D4C, $1D11, $DD4C, $9D4C, $1D11, $DD4C, $9D4C, $1D11, $DD4C, $9D4C
endmacro

macro FullDoorRow(start)
	%TopOfDoorSquares(<start>)
	%BottomOfDoorSquares(<start>+$20)
endmacro

; top grid
%FullDoorRow($60D1)
%FullDoorRow($6131)
%FullDoorRow($6191)

%FullDoorRow($6251)
%FullDoorRow($62B1)
%FullDoorRow($6311)

db $FF
