pushpc
	org $82D6E2
	JSL CheckLoadRewind
	BCC +
	JMP.w $D83F
	+
pullpc

; pushpc
; 	org $87A46E
; 	JSL CheckBookTriggerSave
; pullpc

CheckBookTriggerSave:
	LDA.b $10
	CMP.b #$07
	BNE +

	JSL SaveRewind

	; what we wrote over
+	LDA.b $3A
	AND.b #$BF
RTL

CheckLoadRewind:
	; what we wrote over
	STZ.w $011A
	STZ.w $011C
;	STZ.w $010A ; removed for MSU patch anyway

	LDA.l RewindTrigger
	AND.w #$00FF
	BEQ .no_state

	JSR.w LoadRewind
	SEC
	RTL

.no_state
	LDA.l $7EF3CC ; rest of what we wrote over
	CLC
	RTL

LoadRewind:
	LDA.l RewindDungeonEntrance
	STA.w $010E

	LDA.l RewindRoomId
	STA.b $A0
	STA.w $048E

	LDA.l RewindVerticalScroll
	STA.b $E8
	STA.b $E6
	STA.w $0122
	STA.w $0124

	LDA.l RewindHorizontalScroll
	STA.b $E2
	STA.b $E0
	STA.w $011E
	STA.w $0120

	LDA.l RewindYCoordinate
	STA.b $20

	LDA.l RewindXCoordinate
	STA.b $22

	LDA.l RewindCameraTriggerY
	STA.w $0618

	INC A
	INC A
	STA.w $061A

	LDA.l RewindCameraTriggerX
	STA.w $061C

	INC A
	INC A
	STA.w $061E

	LDA.w #$01F8
	STA.b $EC

	LDA.l RewindOverworldDoorTilemap
	STA.w $0696
	STZ.w $0698

	LDA.w #$0000
	STA.w $0610

	LDA.w #$0110
	STA.w $0612

	LDA.w #$0000
	STA.w $0614

	LDA.w #$0100
	STA.w $0616

	SEP #$20

	LDA.l RewindCameraScrollBoundaries
	STA.w $0601

	LDA.l RewindCameraScrollBoundaries+1
	STA.w $0603

	LDA.l RewindCameraScrollBoundaries+2
	STA.w $0605

	LDA.l RewindCameraScrollBoundaries+3
	STA.w $0607

	LDA.l RewindCameraScrollBoundaries+4
	STA.w $0609

	LDA.l RewindCameraScrollBoundaries+5
	STA.w $060B

	LDA.l RewindCameraScrollBoundaries+6
	STA.w $060D

	LDA.l RewindCameraScrollBoundaries+7
	STA.w $060F

	STZ.w $0600
	STZ.w $0602

	LDA.b #$10
	STA.w $0604
	STA.w $0606

	STZ.w $0608
	STZ.w $060A
	STZ.w $060C
	STZ.w $060E

	LDA.l RewindLinkFacing
	STA.b $2F

	LDA.l RewindMainGFX
	STA.w $0AA1
	
	LDA.l RewindSong
	STA.w $0132

	LDA.l RewindFloor
	STA.b $A4

	LDA.l RewindDungeonId
	STA.w $040C

	LDA.l Rewind_6C
	STA.b $6C

	LDA.l Rewind_EE
	STA.b $EE

	LDA.l Rewind_0476
	STA.w $0476

	LDA.l Rewind_A6
	STA.b $A6

	LDA.l Rewind_A7
	STA.b $A7

	LDA.l Rewind_A9
	STA.b $A9

	LDA.l Rewind_AA
	STA.b $AA

	STZ.w $02E4

	PHP
	REP #$30
	LDA.w #$0000
	STA.l RewindTrigger

	LDA.w #$FFFF
	STA.l RewindRoomId

	PHB
	LDX.w #RewindSRAM
	LDY.w #SaveDataWRAM
	LDA.w #$4FF
	MVN SaveDataWRAM>>16, RewindSRAM>>16
	PLB
	PLP
RTS

SaveRewind:
	PHP
	REP #$20

	LDA.w $010E
	STA.l RewindDungeonEntrance

	LDA.b $A0
	STA.l RewindRoomId

	LDA.b $E8
	STA.l RewindVerticalScroll

	LDA.b $E2
	STA.l RewindHorizontalScroll

	LDA.b $20
	STA.l RewindYCoordinate

	LDA.b $22
	STA.l RewindXCoordinate

	LDA.w $0618
	STA.l RewindCameraTriggerY

	LDA.w $061C
	STA.l RewindCameraTriggerX

	LDA.w $0696
	STA.l RewindOverworldDoorTilemap

	SEP #$20

	LDA.w $0601
	STA.l RewindCameraScrollBoundaries

	LDA.w $0603
	STA.l RewindCameraScrollBoundaries+1

	LDA.w $0605
	STA.l RewindCameraScrollBoundaries+2

	LDA.w $0607
	STA.l RewindCameraScrollBoundaries+3

	LDA.w $0609
	STA.l RewindCameraScrollBoundaries+4

	LDA.w $060B
	STA.l RewindCameraScrollBoundaries+5

	LDA.w $060D
	STA.l RewindCameraScrollBoundaries+6

	LDA.w $060F
	STA.l RewindCameraScrollBoundaries+7

	LDA.b $2F
	STA.l RewindLinkFacing

	LDA.w $0AA1
	STA.l RewindMainGFX
	
	LDA.w $0132
	STA.l RewindSong

	LDA.b $A4
	STA.l RewindFloor

	LDA.w $040C
	STA.l RewindDungeonId

	LDA.b $6C
	STA.l Rewind_6C

	LDA.b $EE
	STA.l Rewind_EE

	LDA.w $0476
	STA.l Rewind_0476

	LDA.b $A6
	STA.l Rewind_A6

	LDA.b $A7
	STA.l Rewind_A7

	LDA.b $A9
	STA.l Rewind_A9

	LDA.b $AA
	STA.l Rewind_AA

	PHB
	REP #$30
	LDX #SaveDataWRAM
	LDY #RewindSRAM
	LDA #$4FF
	MVN RewindSRAM>>16, SaveDataWRAM>>16
	PLB
	PLP
RTL
