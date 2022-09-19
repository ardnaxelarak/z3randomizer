;================================================================================
; Frame Hook
;--------------------------------------------------------------------------------
FrameHookAction:
	JSL $0080B5 ; Module_MainRouting
	JSL CheckMusicLoadRequest
	PHP : REP #$30 : PHA
	
		SEP #$20
		
		LDA StatsLocked : BNE ++
			REP #$20 ; set 16-bit accumulator
				LDA LoopFrames : INC : STA LoopFrames : BNE +
					LDA LoopFrames+2 : INC : STA LoopFrames+2
				+
				LDA $10 : CMP.w #$010E : BNE + ; move this to nmi hook?
				LDA MenuFrames : INC : STA MenuFrames : BNE +
					LDA MenuFrames+2 : INC : STA MenuFrames+2
				+
		++
	REP #$30 : PLA : PLP
RTL

!NMI_MW = "$7F5047"
;--------------------------------------------------------------------------------
NMIHookAction:
	PHA : PHX : PHY : PHD ; thing we wrote over, push stuff

	LDA !NMI_MW : BEQ ++
		PHP
		SEP #$30

		LDA #$00 : STA !NMI_MW

		; Multiworld text
		LDA !NMI_MW+1 : BEQ +
			LDA #$00 : STA !NMI_MW+1
			JSL.l WriteText
		+
		PLP
	++
	
	LDA StatsLocked : AND.w #$00FF : BNE ++
		LDA NMIFrames : INC : STA NMIFrames : BNE +
			LDA NMIFrames+2 : INC : STA NMIFrames+2
		+
	++
	
JML.l NMIHookReturn
;--------------------------------------------------------------------------------
!NMI_AUX = "$7F5044"

PostNMIHookAction:
    LDA.l !NMI_AUX+2 : BEQ .return

    PHK
    PEA .return-1

    PHA

    LDA.b #$00 : STA.l !NMI_AUX+2

    REP #$20
    LDA.l !NMI_AUX+0 : DEC : PHA
    SEP #$20

    RTL

.return
    LDA.b $13 : STA.w $2100

    JML.l PostNMIHookReturn


;--------------------------------------------------------------------------------
