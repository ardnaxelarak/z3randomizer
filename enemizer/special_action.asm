;================================================================================
; Special action
;================================================================================
check_special_action:
{
    LDA.w $0CF3 : BEQ .no_special_action
        LDA.b #$05 : STA.b GameSubMode    ; $11[0x01] - (Main) Submodule Index (See $B0)
        STZ.w $0CF3                       ; $0CF3[0x01] - free ram
    .no_special_action
    JSL Player_Main
RTL
}