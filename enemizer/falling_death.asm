pushpc

org $868536
JSL CheckFallingDeathFlag

org $86FBF8
JSL CheckFallingDeathFlag

Sprite_ManuallySetDeathFlagUW = $89C2F5

pullpc

CheckFallingDeathFlag:
	LDA.l !ENEMY_FALLING_STAY_ALIVE
	BEQ +
	RTL
	+ JML.l Sprite_ManuallySetDeathFlagUW  ; original code

