pushpc

org $8DF7E9
dw $28DE, $28DF, $28EE, $28EF ; Scroll
dw $2C62, $2C63, $2C72, $2C73 ; Mirror
dw $2C62, $2C63, $2C72, $2D11 ; 2-Way Mirror

org $87A93F
JSL.l CheckMirrorWorld

org $87A955
JSL.l BlockEraseFix
NOP #2

pullpc

CheckMirrorWorld:
	LDA.l MirrorEquipment
	BEQ + ; just scroll, so don't allow
	DEC
	BNE +
	LDA.b $8A
	AND.b #$40
+	RTL

BlockEraseFix:
	LDA.l MirrorEquipment
	BEQ +
		STZ.w $05FC
		STZ.w $05FD
+	RTL
