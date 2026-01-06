MapDrawingData:
.floor_data_offset
	dw $0000, $0000
	dw $0019, $000C
	dw $0032, $0018
	dw $004B, $0024
	dw $0064, $0030
	dw $007D, $003C
	dw $0096, $0048
	dw $00AF, $0054
	dw $00C8, $0060

.row_data_offset
	dw $0000, $0000
	dw $0005, $0004
	dw $000A, $0008
	dw $000F, $000C
	dw $0014, $0010

.corner_tile_address
	dw $00E2, $0160
	dw $00F8, $0178
	dw $03A2, $03A0
	dw $03B8, $03B8

.row_tile_address
	dw $00E4, $0162
	dw $03A4, $03A2

.row_tile_length
	dw $0014, $0016

.column_tile_address
	dw $0122, $01A0
	dw $0138, $01B8

.column_tile_length
	dw $0280, $0200

.floor_label_address
	dw $035E, $035C

.row_start_address
	dw $0124, $01A2
	dw $01A4, $0262
	dw $0224, $0322
	dw $02A4, $03D2
	dw $0324, $04A2

.column_count
	dw $0005, $0004

.column_spacing
	dw $0004, $0006

.row_count
	dw $0005, $0003

.bg1_grid_start
	dw $1091, $10D1

.sprite_offset_x_base
	dw $0090, $0088

.sprite_offset_y_base
	dw $001F, $002F
	dw $007F, $008F

.entrance_sprite_offset_y_base
	dw $0087, $0097

.supertile_pixel_spacing
	dw $0010, $0018

.floor_pixel_column_wrap
	dw $0040, $0048

.floor_pixel_row_wrap
	dw $0040, $0030

macro Map_LDA(addr, label)
	pushpc
	org <addr>
	JSR LDA_<label>
	pullpc

	LDA_<label>:
		PHX
		LDA.l DungeonMapMode
		ASL A
		TAX
		LDA.l MapDrawingData_<label>, X
		PLX
		RTS
endmacro

macro Map_LDAY(addr, label)
	pushpc
	org <addr>
	JSR LDA_Y_<label>
	pullpc

	if not(defined("LDA_Y_<label>"))
		!LDA_Y_<label> = 1
		LDA_Y_<label>:
			PHX
			TYA
			CLC : ADC.l DungeonMapMode
			ASL A
			TAX
			LDA.l MapDrawingData_<label>, X
			PLX
			RTS
	endif
endmacro

macro Map_LDAX(addr, label)
	pushpc
	org <addr>
	JSR LDA_X_<label>
	pullpc

	LDA_X_<label>:
		PHX
		TXA
		CLC : ADC.l DungeonMapMode
		ASL A
		TAX
		LDA.l MapDrawingData_<label>, X
		PLX
		RTS
endmacro

macro Map_CMP(addr, label)
	pushpc
	org <addr>
	JSR CMP_<label>
	pullpc

	CMP_<label>:
		PHX
		PHA
		LDA.l DungeonMapMode
		ASL A
		TAX
		PLA
		CMP.l MapDrawingData_<label>, X
		BEQ .z_flag_set
	.z_flag_clear
		PLX
		REP #$02
		RTS
	.z_flag_set
		PLX
		SEP #$02
		RTS
endmacro

macro Map_ADC(addr, label)
	pushpc
	org <addr>
	JSR ADC_<label>
	pullpc

	ADC_<label>:
		PHX
		PHA
		LDA.l DungeonMapMode
		ASL A
		TAX
		PLA
		CLC : ADC.l MapDrawingData_<label>, X
		PLX
		RTS
endmacro

macro Map_ADCY(addr, label)
	pushpc
	org <addr>
	JSR ADC_Y_<label>
	pullpc

	if not(defined("ADC_Y_<label>"))
		!ADC_Y_<label> = 1
		ADC_Y_<label>:
			PHX
			PHA
			TYA
			CLC : ADC.l DungeonMapMode
			ASL A
			TAX
			PLA
			CLC : ADC.l MapDrawingData_<label>, X
			PLX
			RTS
	endif
endmacro

pushpc

org $8AE5DA
	ADC.b $02 ; swap position of load and add for ease

org $8AEBDB
JSR ADC_Y_sprite_offset_y_base

org $8AE652 ; steal some space from the old map-drawing code we're no longer using

%Map_LDAY($8AE45F, corner_tile_address)
%Map_LDAY($8AE489, row_tile_address)
%Map_CMP($8AE4B0, row_tile_length)
%Map_LDAY($8AE4C1, column_tile_address)
%Map_CMP($8AE4EA, column_tile_length)
%Map_LDA($8AE54A, floor_label_address)
%Map_LDAX($8AE5D7, row_data_offset)
%Map_LDAY($8AE5F7, floor_data_offset)
%Map_CMP($8AE5A2, row_count)
%Map_CMP($8AE7FA, column_count)
%Map_ADC($8AE896, sprite_offset_x_base)
%Map_ADCY($8AE8B5, sprite_offset_y_base)
%Map_ADC($8AE952, sprite_offset_y_base)
%Map_ADCY($8AEBDB, sprite_offset_y_base)

warnpc $8AE7F6
padbyte $EA
pad $8AE7F6

pullpc

incsrc data/doors_connections.asm

PrepDrawRow:
	CLC : ADC.l DungeonMapMode
	ASL A
	TAX
	LDA.l MapDrawingData_row_start_address, X
	CLC : ADC.b $06
	AND.w #$0FFF
	TAX

	LDA.l DungeonMapMode
	CMP.w #$0001
	BNE .done

	JSR DrawRowOfRoomConnections

.done
	RTL


TripleTable:
	dw $0000, $0003, $0006

DrawRowOfRoomConnections:
	PHB : PHK : PLB
	PHX

	LDA.b $00
	ASL A
	TAY
	LDA.w TripleTable, Y
	TAY

	LDA.w $B9FC00, Y
	AND.w #$00FF
	JSR DrawHorizontalConnector
	INY
	INX #6

	LDA.w $B9FC00, Y
	AND.w #$00FF
	JSR DrawHorizontalConnector
	INY
	INX #6

	LDA.w $B9FC00, Y
	AND.w #$00FF
	JSR DrawHorizontalConnector

	LDA.b $00
	CMP.w #$0002
	BCS .done

	PLX : PHX
	ASL A : ASL A
	TAY

	LDA.w $B9FC09, Y
	AND.w #$00FF
	JSR DrawVerticalConnector
	INY
	INX #6

	LDA.w $B9FC09, Y
	AND.w #$00FF
	JSR DrawVerticalConnector
	INY
	INX #6

	LDA.w $B9FC09, Y
	AND.w #$00FF
	JSR DrawVerticalConnector
	INY
	INX #6

	LDA.w $B9FC09, Y
	AND.w #$00FF
	JSR DrawVerticalConnector
	INY
	INX #6

.done
	PLX
	PLB
	RTS

; A = connector index
; X = address
DrawHorizontalConnector:
	PHY
	ASL A : ASL A
	TAY
	LDA.w DoorConnectionTiles_horizontal+0, Y
	ORA.w #$1400
	STA.l $7F0004, X
	LDA.w DoorConnectionTiles_horizontal+2, Y
	ORA.w #$1400
	STA.l $7F0044, X
	PLY
	RTS

; A = connector index
; X = address
DrawVerticalConnector:
	PHY
	ASL A : ASL A
	TAY
	LDA.w DoorConnectionTiles_vertical+0, Y
	ORA.w #$1400
	STA.l $7F0080, X
	LDA.w DoorConnectionTiles_vertical+2, Y
	ORA.w #$1400
	STA.l $7F0082, X
	PLY
	RTS
