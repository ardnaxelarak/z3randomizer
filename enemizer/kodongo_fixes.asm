pushpc

org $9EC147
JSL NewKodongoCollision
JMP.w .continue : NOP #2
.continue

org $9EC152
Kodongo_SetDirection:

pullpc

NewKodongoCollision:
    LDA $0DE0, X : INC A : AND.b #$03 : STA $0DE0, X
    ;If they collide more than 4 times just set direction
    LDA $0DA0, X : INC A : STA $0DA0, X : CMP #$04 : BCC .continue
    PLA : PLA : PEA.w Kodongo_SetDirection-1
.continue
RTL