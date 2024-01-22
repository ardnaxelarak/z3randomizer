org $09C29A
JSL LoadUnderworldSprites : NOP

; these hooks change the LDA.b ($00) commands to use LDA.b [$00] commands
; so we can store the sprites in a different bank
; also needs to change the use of $02 to $03 for slot index to make that possible

org $09C2B2
LDA.b [$00]

org $09C2C1
LDA.b [$00],Y

org $09C2CA
INC.b $03 ; change slot variable to $03

;org $09C329  standing items overwrote this one
;LDA.b [$00],Y

org $09C332
LDA.b [$00],Y

org $09C345
DEC.b $03 : LDX.b $03

org $09C350
LDA.b [$00],Y

org $09C35A
DEC.b $03

org $09C36E
JSL GetSpriteSlot16Bit ; depended on high bit being zero, which it isn't anymore

org $09C383
LDX.b $03

org $09C38C
LDA.b [$00],Y

org $09C398
LDA.b [$00],Y

org $09C3AA
LDA.b [$00],Y

org $09C3BF
LDA.b [$00],Y

org $09C3DF
LDA.b $03

org $09C3F3
LDA.b [$00],Y

org $09C3FB
LDA.b [$00],Y

org $09C404
LDA.b [$00],Y

org $09C416
LDA.b [$00],Y




