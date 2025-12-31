pushpc
org $809383
db BG3DungeonMapStripes>>0

org $80938C
db BG3DungeonMapStripes>>8

org $809395
db BG3DungeonMapStripes>>16
pullpc

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

BG3DungeonMapStripes:
; boring stuff from vanilla
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
dw $4E60, $0100, $2100
dw $4F60, $1A40, $2101
dw $5D60, $0100, $6100
dw $6E60, $2EC0, $2110
dw $7D60, $2EC0, $6110
dw $6E63, $0100, $A100
dw $6F63, $1A40, $A101
dw $7D63, $0100, $E100
dw $0060, $7E40, $2111
dw $8063, $3E41, $2111
dw $0060, $3EC0, $2111
dw $0160, $3EC0, $2111
dw $0C60, $3EC0, $2111
dw $0D60, $3EC0, $2111
dw $1E60, $3EC0, $2111
dw $1F60, $3EC0, $2111

; new stuff here:
; horizontal borders
dw $7260, $1340, $1D11
dw $D261, $1340, $1D11
dw $F261, $1340, $1D11
dw $5263, $1340, $1D11

; vertical borders
dw $7160, $2FC0, $1D11
dw $7C60, $2FC0, $1D11

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
