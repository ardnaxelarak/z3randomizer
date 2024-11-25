pushpc

org $8DF7F1
dw $2C62, $2C63, $2C72, $2C73 ; Mirror
dw $2C62, $2C63, $2C72, $2D11 ; 2-Way Mirror

org $87A93F
JSL.l CheckMirrorWorld

pullpc

CheckMirrorWorld:
	LDA.l MirrorEquipment
	DEC
	BNE +
	LDA.b $8A
	AND.b #$40
+	RTL
