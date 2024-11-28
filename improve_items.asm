pushpc

org $8DE4FE
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE514
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE52A
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE540
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE556
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE56C
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE5FF
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE615
JSR.w ItemMenu_DrawEnhanced_Short
org $8DE62B
JSR.w ItemMenu_DrawEnhanced_Short

org $8DFB63
JSL.l GetItemLevelForHud

org $8DFFFB
ItemMenu_DrawEnhanced_Short:
JSL.l ItemMenu_DrawEnhanced
RTS

pullpc

ItemMenu_DrawEnhanced:
	LDA.b $02
	BEQ +
	LDA.w #$0008
+	TAY

	LDX.b $00
	LDA.b ($04),Y
	STA.w $0000,X

	INY : INY

	LDA.b ($04),Y
	STA.w $0002,X

	INY : INY

	LDA.b ($04),Y
	STA.w $0040,X

	INY : INY

	LDA.b ($04),Y
	STA.w $0042,X
	RTL

AddMagicMarker:
	LDA.w ItemCursor : AND.w #$00FF ; load item value
	PHX
	TAX
	LDA.l CanReduceMagic, X : AND.w #$00FF
	BEQ .done
	LDA.l EquipmentWRAM-1, X : AND.w #$00FF
	DEC : DEC
	BMI .done
	BEQ .half
.quarter
	LDA.w #$3D4C
	BRA .write
.half
	LDA.w #$3D3F
.write
	STA.w $FFC2, Y
	LDA.w #$3D37
	STA.w $FFC0, Y
.done
	PLX
	RTL

GetItemLevelForHud:
	LDA.l CanReduceMagic, X : AND.w #$00FF
	BNE + ; it's already $0001, so we can return
	LDA.l EquipmentWRAM-1, X ; normal, what we wrote over
+	RTL

CheckMagicLevel:
	PHP : SEP #$30
	LDA.w ItemCursor ; load item value
	TAX
	LDA.l CanReduceMagic, X
	BEQ .normal
	LDA.l EquipmentWRAM-1, X
	DEC : DEC
	BMI .normal
	BEQ .half
.quarter
	LDA.b #$02
	BRA .write
.half
	LDA.b #$01
	BRA .write
.normal
	LDA.b #$00
.write
	STA.l MagicConsumption
	PLP
	RTL


CanReduceMagic:
	db $00
	db $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01
	db $01, $00, $00, $00, $00
	db $00, $01, $01, $01, $00
