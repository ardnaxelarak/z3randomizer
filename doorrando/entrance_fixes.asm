;===================================================================================================
; The only specific concern to keep in mind with this code is that your databank will be $00
; Actually, it should be $80, if you're using my fastrom changes.
;
; Leave all your door data vanilla
; Do not try to adjust doors as I previously suggested (not worth the effort)
; We need a few hooks and some light hardcoding either way
; Might as well just do it in a brute, but reliable, way
;
; In brief, this is the hack we're making:
;  1) Let vanilla routines draw the door normally
;  2) Draw over what vanilla just drew
;  3) Hijack the door tile type routine
;     and replace the vanilla value with that of solid collision
;===================================================================================================
pushpc

org $01892F
DoorDrawJankMove:
	JML PrepDoorDraw

.return
	JSL AdjustEscapeDoorGraphics
	RTS

; we don't want to overwrite the JMP ($000E) that's already there
; Well, we could, but we don't need to
warnpc $018939

org $01BF43
	JSL AdjustEscapeDoorCollision

pullpc

;===================================================================================================

PrepDoorDraw:
	; first off, we need this routine to return to our jank hook
	; otherwise, finding a reliable place to put the graphics change check will be a pin
	; so push the address to return to the routine

	; It's a lot to explain why this is necessary
	; Much easier to just tell you to look at $01890D in the disassembly
	; and you should understand the vanilla program flow we need to reject
	PEA.w DoorDrawJankMove_return-1

	; copy vanilla code (but fast rom)
	LDA.l $8186F0,X
	STA.b $0E

	LDX.b $02
	LDA.b $04

	; and to execute the jump, we'll use the JMP ($000E) we carefully avoided overwriting
	JML.l $818939

;===================================================================================================

; Adjustment stage 1: graphics
AdjustEscapeDoorGraphics:
	JSR IdentifyBlockedEntrance
	BCS .replace_graphics
	JSR IdentifySancEntrance
	BCS .fix_sanctuary_entrance
	JSR IdentifySwampEntrance
	BCS .fix_swamp_entrance
	; Do nothing
	RTL

;---------------------------------------------------------------------------------------------------

.replace_graphics  ; for blocked doors
	; using the value in $19A0 should be fine for finding the graphics
	; the only caveat is that this appears to locate the tile just above the north-west corner
	; so below, I've indicated that offset with a +$xxx after the base tilemap buffer
	; The only odd thing I notice with this position is that some bad hardcoded adjust for
	; exploding walls that shouldn't affect how we use this value at all!
	LDY.w $0460 ; get door index

	LDX.w $19A0-2,Y ; get tilemap index

	; hardcoded shutter door graphics tile replacement

	; the horizontal flips could easily be explicit LDAs
	; but it's probably best the door is symmetrical
	; using ORA makes your intent more clear
	; and gives you fewer values to change if you experiment with other graphics

	; row 1
	LDA.w #$8838
	STA.l $7E2000+$080,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$086,X

	; row 2
	LDA.w #$8828
	STA.l $7E2000+$100,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$106,X

	LDA.w #$8829
	STA.l $7E2000+$102,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$104,X

	; the state of the A, X, and Y registers is irrelevant when we exit
	; they're all subsequently loaded with new values
	RTL

.fix_sanctuary_entrance
	LDY.w $0460 ; get door index
	LDX.w $19A0-2,Y ; get tilemap index

	; row 0
	LDA.w #$14C4
	STA.l $7E2000+$000,X  ; sanity check = should calculate to 7e3bbc
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$006,X

	LDA.w #$14C5
	STA.l $7E2000+$002,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$004,X

	; row 1
	LDA.w #$14E8
	STA.l $7E2000+$082,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$084,X

	; row 2
	LDA.w #$14F8
	STA.l $7E2000+$102,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$104,X

.fix_swamp_entrance
	LDY.w $0460 ; get door index
	LDX.w $19A0-2,Y ; get tilemap index

	; row 0
	LDA.w #$9DfC
	STA.l $7E2000+$000,X
	STA.l $7E2000+$002,X
	STA.l $7E2000+$004,X
	STA.l $7E2000+$006,X

	; row 1
	LDA.w #$0908
	STA.l $7E2000+$080,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$086,X

	LDA.w #$14E8
	STA.l $7E2000+$082,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$084,X

	; row 2
	LDA.w #$0918
	STA.l $7E2000+$100,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$106,X

	LDA.w #$14F8
	STA.l $7E2000+$102,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$104,X

	; row 3
	LDA.w #$A82C
	STA.l $7E2000+$180,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$186,X

	LDA.w #$A82D
	STA.l $7E2000+$182,X
	ORA.w #$4000 ; horizontally flip
	STA.l $7E2000+$184,X
	RTL

IdentifySancEntrance:
	LDA.b $A0 : CMP.w #$0012 : BNE +
	LDA.b $0A : CMP.w #$0010 : BNE +
		SEC : RTS
	+ CLC : RTS

IdentifySwampEntrance:
	LDA.b $A0 : CMP.w #$0036 : BNE +
	LDA.b $0A : CMP.w #$0010 : BNE +
		SEC : RTS
	+ CLC : RTS

;===================================================================================================

; Leaving this here in case you desire a fully custom door later
; For now, we'll just hardcode the tiles, as I did above
; I put these in column order because that's how they're expected for the vanilla draw routines
; but I changed my mind on redefining things
; and am too lazy to change it to a row-wise listing
BlockedEntrance:
	dw $8838, $8828, $A888 ; column 0
	dw $14E8, $8829, $C888 ; column 1
	dw $14E8, $8829, $A888 ; column 2
	dw $C838, $C828, $C888 ; column 3

;===================================================================================================

; Adjustment stage 2: collision
AdjustEscapeDoorCollision:
	LSR ; vanilla shift

	; save our parameters
	; but one or both of these may not be necessary depending on how you detect these doors
	; all that matters is that after identifying blockage, we have:
	;   Y is the same as what we entered with
	;   X has A>>1, for whatever A entered with
	PHA
	LDA.w $1980, Y  ; grab door info (type)
	AND.w #$00FF
	STA.b $0A       ; store in temporary variable
	JSR IdentifyBlockedEntrance

	PLX ; this is a TAX in vanilla, just have X pull A instead

	BCS .block_entrance

	; vanilla value
	LDA.b $00

	RTL

.block_entrance
	LDA.w #$0101 ; load tile type for solid collision

	RTL

;===================================================================================================

; Enter with:
;	$0A containing the door information: position and type bytes
;       which should be from $1980, Y or [$B7], Y depending on where in the door process we are
; Exit with:
;   carry clear - leave door alone
;   carry set   - block door
IdentifyBlockedEntrance:
	LDA.l ProgressIndicator : AND.w #$00FF : CMP.w #$0002 : BCS .leave_alone ; only in rain states (0 or 1)
	LDA.l ProgressFlags : AND.w #$0004 : BNE .leave_alone ; zelda's been rescued
	LDA.l BlockSanctuaryDoorInRain : BEQ + ;flagged
	LDA.b $A0 : CMP.w #$0012 : BNE +
		; we're in the sanctuary
		; 	this code could be removed because you can't reach sanc without zelda currently
		; 	but that's enforced in the logic, so this is to catch that case in case some mode allows it
		LDA.l FollowerIndicator : AND.w #$00FF : CMP.w #$0001 : BEQ .leave_alone ; zelda is following
		LDA.b $0A
		CMP.w #$000A : BCC .leave_alone
		CMP.w #$0014 : BCS .leave_alone
			.block_door
			SEC : RTS
	+ LDA.l BlockCastleDoorsInRain : AND.w #$00FF : BEQ .leave_alone
	LDX #$FFFE
	- INX #2
	LDA.l RemoveRainDoorsRoom, X : CMP.w #$FFFF : BEQ .leave_alone
	CMP $A0 : BNE -
	LDA.b $0A
	CMP.w #$000A : BCC .continue
	CMP.w #$0014 : BCS .continue
	BRA .block_door
	.continue
	BRA -
	.leave_alone
	CLC : RTS

;===================================================================================================