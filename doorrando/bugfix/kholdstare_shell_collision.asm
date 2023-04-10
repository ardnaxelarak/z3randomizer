pushpc

org $9E9463
JSL CheckKholdShellCoordinates
BCC Sprite_A3_KholdstareShell_link_not_close
BRA Sprite_A3_KholdstareShell_link_close
NOP #13

Sprite_A3_KholdstareShell_link_close = $9E9478
Sprite_A3_KholdstareShell_link_not_close = $9E9480

pullpc

CheckKholdShellCoordinates:

LDA.w $0D30, X
XBA
LDA.w $0D10, X  ; full 16 bit X coordinate of sprite

REP #$21
SBC.w #$0020
CMP.b $22
BCS .not_colliding

ADC.w #$0040
CMP.b $22
BCC .not_colliding

SEP #$20
LDA.w $0D20, X
XBA
LDA.w $0D00, X  ; full 16 bit Y coordinate of sprite

REP #$21
SBC.w #$001F  ; could go to 27 and let link squeeze in at Lanmo 2 (please adjust the following one)
CMP.b $20
BCS .not_colliding

ADC.w #$0037
CMP.b $20
BCC .not_colliding

SEP #$20  ; collision detected
SEC
RTL

.not_colliding
SEP #$30
CLC
RTL

