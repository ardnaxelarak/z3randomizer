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
	BNE .4x3
	LDA.l DRMode
	BNE .6x6

.5x5
	LDA.b #BG3DungeonMap5x5Stripes>>0
	STA.b $00
	LDA.b #BG3DungeonMap5x5Stripes>>8
	STA.b $01
	LDA.b #BG3DungeonMap5x5Stripes>>16
	STA.b $02
	RTL

.4x3
	LDA.b #BG3DungeonMap4x3Stripes>>0
	STA.b $00
	LDA.b #BG3DungeonMap4x3Stripes>>8
	STA.b $01
	LDA.b #BG3DungeonMap4x3Stripes>>16
	STA.b $02
	RTL

.6x6
	LDA.b #BG3DungeonMap6x6Stripes>>0
	STA.b $00
	LDA.b #BG3DungeonMap6x6Stripes>>8
	STA.b $01
	LDA.b #BG3DungeonMap6x6Stripes>>16
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


BG3DungeonMap5x5Stripes:
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

BG3DungeonMap4x3Stripes:
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

BG3DungeonMap6x6Stripes:
; vanilla
dw $4260, $0100, $2100
dw $4360, $0E40, $2101
dw $4B60, $0100, $6100
dw $8460, $0B00, $2102, $2103, $2104, $2105, $2106, $2107
dw $A460, $0B00, $2112, $2113, $2114, $2115, $2116, $2117
dw $0060, $7E40, $2111
dw $8063, $3E41, $2111
dw $0060, $3EC0, $2111
dw $0160, $3EC0, $2111
dw $0C60, $3EC0, $2111
dw $0D60, $3EC0, $2111
dw $1E60, $3EC0, $2111
dw $1F60, $3EC0, $2111

; left side border
dw $6260, $2AC0, $2110
dw $6B60, $2AC0, $6110
dw $2263, $0100, $A100
dw $2363, $0E40, $A101
dw $2B63, $0100, $E100

; right side top area border
dw $4E60, $0100, $2100
dw $4F60, $1A40, $2101
dw $5D60, $0100, $6100
dw $6E60, $1AC0, $2110
dw $7D60, $1AC0, $6110
dw $2E62, $0100, $A100
dw $2F62, $1A40, $A101
dw $3D62, $0100, $E100

; right side bottom area border
dw $8E62, $0100, $2100
dw $8F62, $1A40, $2101
dw $9D62, $0100, $6100
dw $AE62, $06C0, $2110
dw $BD62, $06C0, $6110
dw $2E63, $0100, $A100
dw $2F63, $1A40, $A101
dw $3D63, $0100, $E100

; blank between right side areas
dw $4E62, $1E40, $2111
dw $6E62, $1E40, $2111

dw $4063, $4640, $2111
dw $6063, $4640, $2111

; map area inside top area
dw $6F60, $1A40, $1D11
dw $8F60, $1A40, $1D11
dw $AF60, $1A40, $1D11
dw $CF60, $1A40, $1D11
dw $EF60, $1A40, $1D11
dw $0F61, $1A40, $1D11
dw $2F61, $1A40, $1D11
dw $4F61, $1A40, $1D11
dw $6F61, $1A40, $1D11
dw $8F61, $1A40, $1D11
dw $AF61, $1A40, $1D11
dw $CF61, $1A40, $1D11
dw $EF61, $1A40, $1D11
dw $0F62, $1A40, $1D11

; center square
dw $3561, $0300
dw $5D4C, $1D4C

dw $5561, $0300
dw $DD4C, $9D4C

; map area inside bottom area
dw $AF62, $1A40, $1D11

dw $CF62, $1B00
dw $1D11, $5D4C, $1D4C, $1D11, $5D4C, $1D4C, $1D11, $5D4C, $1D4C, $1D11, $1D11, $5D4C, $1D4C, $1D11

dw $EF62, $1B00
dw $1D11, $DD4C, $9D4C, $1D11, $DD4C, $9D4C, $1D11, $DD4C, $9D4C, $1D11, $1D11, $DD4C, $9D4C, $1D11

dw $0F63, $1A40, $1D11

db $FF
