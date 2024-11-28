pushpc

org $87D35E
db $01, $02, $01, $01, $03, $02, $03

org $8DF809
MenuEquipmentIcons:
.gloves
dw $2121, $2122, $2123, $2124 ; No glove
dw $3CDA, $3CDB, $3CEA, $3CEB ; Weak glove
dw $2130, $2131, $2140, $2141 ; Power glove
dw $28DA, $28DB, $28EA, $28EB ; Titan's mitt

.boots
dw $20F5, $20F5, $20F5, $20F5 ; No boots
dw $3429, $342A, $342B, $342C ; Pegasus boots

.flippers
dw $20F5, $20F5, $20F5, $20F5 ; No flippers
dw $2C9A, $2C9B, $2C9D, $2C9E ; Flippers

.pearl
dw $20F5, $20F5, $20F5, $20F5 ; No pearl
dw $2433, $2434, $2435, $2436 ; Moon pearl

org $8DE7C7
LDA.w #MenuEquipmentIcons_gloves

org $8DE7DD
LDA.w #MenuEquipmentIcons_boots

org $8DE7F3
LDA.w #MenuEquipmentIcons_flippers

org $8DECF9
LDA.w #MenuEquipmentIcons_pearl

org $8DFADB
dw MenuEquipmentIcons_gloves
dw MenuEquipmentIcons_boots
dw MenuEquipmentIcons_flippers
dw MenuEquipmentIcons_pearl

pullpc

LoadModifiedGloveValue:
	LDA.l GloveEquipment : AND.w #$00FF
	BEQ .done
	DEC
.done
	RTL
