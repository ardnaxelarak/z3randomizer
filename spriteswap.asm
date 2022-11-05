org $008A01 ; 0xA01 - Bank00.asm (LDA.b #$10 : STA $4304 : STA $4314 : STA $4324)
LDA.b $BC

org $1BEDF9
JSL SpriteSwap_Palette_ArmorAndGloves ;4bytes
RTL ;1byte 
NOP #$01

org $1BEE1B
JSL SpriteSwap_Palette_ArmorAndGloves_part_two
RTL

!BANK_BASE = $29

org $BF8000
SwapSpriteIfNecessary:
	PHP
		SEP #$20 ; set 8-bit accumulator
		LDA.l SpriteSwapper : BEQ + : !ADD #!BANK_BASE : CMP.b $BC : BEQ +
			STA.b $BC
		    STZ.w $0710 ; Set Normal Sprite NMI
			JSL.l SpriteSwap_Palette_ArmorAndGloves_part_two
		+
	PLP
RTL

SpriteSwap_Palette_ArmorAndGloves:
{
    ;DEDF9
    LDA.l SpriteSwapper : BNE .continue
        LDA.b #$10 : STA.b $BC ; Load Original Sprite Location
        REP #$21
        LDA.l ArmorEquipment
        JSL $1BEDFF ; Read Original Palette Code
    RTL
    .part_two
    SEP #$30
    LDA.l SpriteSwapper : BNE .continue
        REP #$30
        LDA.l GloveEquipment 
        JSL $1BEE21 ; Read Original Palette Code
    RTL

    .continue

    PHX : PHY : PHA
    ; Load armor palette
    PHB : PHK : PLB
    REP #$20 ; set 16-bit accumulator
    
    ; Check what Link's armor value is.
    LDA.l ArmorEquipment : AND.w #$00FF : TAX
    
    LDA.l $1BEC06, X : AND.w #$00FF : ASL A : ADC.w #$F000 : STA.b Scrap00
    ;replace D308 by 7000 and search
    REP #$10 ; set 16-bit index registers
    
    LDA.w #$01E2 ; Target SP-7 (sprite palette 6)
    LDX.w #$000E ; Palette has 15 colors
    
    TXY : TAX
    
    LDA.b $BC : AND.w #$00FF : STA.b Scrap02

.loop

    LDA.b [Scrap00] : STA.l $7EC300, X : STA.l $7EC500, X
    
    INC.b Scrap00 : INC.b Scrap00
    
    INX #2
    
    DEY : BPL .loop

    SEP #$30
    
    
    PLB
    INC $15
    PLA : PLY : PLX
    RTL
}
