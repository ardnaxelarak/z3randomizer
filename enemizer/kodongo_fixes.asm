pushpc

org $9EC147
JSL NewKodongoCollision
BRA + : NOP #3 : +

org $9EC152
Kodongo_SetDirection:

pullpc

NewKodongoCollision:
    LDA.w SpriteMoveDirection, X : INC A : AND.b #$03 : STA.w SpriteMoveDirection, X
    JSL Kodongo_InVanillaRoom : BEQ .continue
    ;If they collide more than 4 times just set direction
    LDA.w SpriteAuxTable, X : INC A : STA.w SpriteAuxTable, X : CMP.b #$04 : BCC .continue
    PLA : PLA : PEA.w Kodongo_SetDirection-1
.continue
RTL

Kodongo_InVanillaRoom:
    LDA.b RoomIndex+1 : BNE .return
    LDA.b RoomIndex : CMP.b #$19 : BEQ .return
    CMP.b #$27 : BEQ .return
    CMP.b #$77 : BEQ .return
.return
RTL
nop #10