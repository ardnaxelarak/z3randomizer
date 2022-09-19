OnMenuLoad:
	LDA.b #UploadMenuOnlyIcons>>0 : STA !NMI_AUX
	LDA.b #UploadMenuOnlyIcons>>8 : STA !NMI_AUX+1
	LDA.b #UploadMenuOnlyIcons>>16 : STA !NMI_AUX+2
	LDA.b #$0E : STA.b $10 ; what we overwrote
RTL

UploadMenuOnlyIcons:
    REP #$20
    LDA.w #MenuOnlyIcons : STA.w $4342
    LDA.w #$1801 : STA.w $4340
    LDA.w #$0240 : STA.w $4345
    LDA.w #$0F800>>1 : STA.w $2116

    SEP #$20
    LDA.b #MenuOnlyIcons>>16 : STA.w $4344
    LDA.b #$80 : STA.w $2118
    LDA.b #$10 : STA.w $420B

    RTL

MenuOnlyIcons:
incbin "menuonly.2bpp"