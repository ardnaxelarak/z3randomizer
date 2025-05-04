!DynamicDropGFXSlotCount_UW = (FreeUWGraphics_end-FreeUWGraphics)>>1
!DynamicDropGFXSlotCount_OW = (FreeOWGraphics_end-FreeOWGraphics)>>1

; Come in with
;   A = item receipt ID
;   X = sprite slot
RequestStandingItemVRAMSlot:
	JSL AttemptItemSubstitution
	JSL ResolveLootIDLong
	.resolved
	STA.w SprItemReceipt, X
	JSL ResolveBeeTrapLong
	PHX : PHY
	PHA
		LDA.b #$01 : STA.w SprRedrawFlag, X
		LDA.l SpriteSkipEOR : BNE + ; skips on-screen check for special cases, like for prize ancilla
		JSL Sprite_IsOnscreen : BCC ++ : +
		; skip sending the request if busy with other things
		LDA.b GameSubMode : CMP.b #$21 : BCS ++ ; skip if OW is loading Map16 GFX ; TODO: Figure out how to allow submodule 22, check DMA status instead
		LDA.b LinkState : CMP.b #$14 : BEQ ++ ; skip if we're mid-mirror
		LDA.b IndoorsFlag : BEQ + ; OW current doesn't occupy any slots that medallion gfx do
			LDA.w GfxChrHalfSlotVerify : CMP.b #$03 : BCC +
				++ PLA : JMP .return
		+

		; setup the palette
		LDA.b 1,S : PHX : JSL GetSpritePalette_resolved : PLX : STA.w SpriteOAMProp, X
	PLA
	
	; gfx that are already present in vanilla, use that instead of a new slot
	CMP.b #$34 : BCC + : CMP.b #$36+1 : BCS + ; if rupees, use animated rupee OAM slot
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC : STA.w SprItemGFXSlot,X
		JMP .success
	+ CMP.b #$24 : BEQ .key : CMP.b #$A0 : BCC + : CMP.b #$AF+1 : BCS + ; if key, use key OAM slot
		.key
		LDY.b LinkState : CPY.b #$19 : BCC ++ : CPY.b #$1A+1 : BCS ++ ; if getting tablet item, don't use key slot
			BRA +
		++
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC #2 : STA.w SprItemGFXSlot,X
		JMP .success
	+ CMP.b #$D6 : BNE + ; if good bee, use bee OAM slot
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC #3 : STA.w SprItemGFXSlot,X
		JMP .success
	+ CMP.b #$D2 : BNE + ; if fairy, use fairy OAM slot
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC : STA.w SprItemGFXSlot,X
		JMP .success
	+ CMP.b #$D1 : BNE + ; if apple, use apple OAM slot
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC #2 : STA.w SprItemGFXSlot,X
		JMP .success
	+
	PHA
		; check if gfx that are already present from previous requests
		LDY.b #$00
		- LDA.w DynamicDropGFXSlots, Y : CMP.b 1,S : BEQ +
			INY : CPY.b #$0F : !BLT -
			STZ.w RandoOverworldTargetEdge ; some free ram OWR also uses
			BRA .newSlot
		+ TYA : STA.w SprItemGFXSlot,X
		PLA : JMP .success

		.newSlot
		PHX
			LDY.b IndoorsFlag : BEQ +
				LDA.b #!DynamicDropGFXSlotCount_UW-1
				BRA ++
			+ LDA.b #!DynamicDropGFXSlotCount_OW-1
			++ STA.w DynamicDropGFXIndex

			.next
			LDA.w RandoOverworldTargetEdge : BNE +
				; on first loop, skip over gfx slots that have some item gfx loaded
				LDY.w DynamicDropGFXIndex : LDA.w DynamicDropGFXSlots, Y : BNE .slotUsed

			; loop thru other sprites, check if any use the same gfx slot
			+ LDY.b #$0F
			- TYA : CMP.b 1,S : BEQ + ; don't check self
			LDA.w SpriteAITable,Y : BEQ +
			LDA.w SprRedrawFlag, Y : BNE +
			LDA.w SpriteTypeTable,Y ; don't need E5 enemy big key drop and E9 powder item
				CMP.b #$EB : BEQ ++ ; heart piece
				CMP.b #$E4 : BEQ ++ ; enemy drop
				CMP.b #$3B : BEQ ++ ; bonk item
				CMP.b #$E7 : BEQ ++ ; mushroom
					BRA +
				++ LDA.w SprItemGFXSlot,Y : CMP.w DynamicDropGFXIndex : BNE +
					; gfx slot already in use
					.slotUsed
					DEC.w DynamicDropGFXIndex : BMI .loopAgain : BRA .next
				
			+ DEY : BPL -
		PLX
		BRA .initRequest

		.loopAgain
		LDA.w RandoOverworldTargetEdge : BNE .overflow
			INC : STA.w RandoOverworldTargetEdge
			BRA .newSlot+1
	
		.overflow ; slot already in use, use overflow slot
		STZ.w RandoOverworldTargetEdge
		LDA.b #$02 : STA.w SprRedrawFlag, X
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ STA.w SprItemGFXSlot,X
		PLX : PLA : BRA .return
	
		.initRequest
		LDA.b 1,S
		LDY.w DynamicDropGFXIndex : STA.w DynamicDropGFXSlots, Y
		TYA : STA.w SprItemGFXSlot, X
	PLA

	PHX
	REP #$30
		AND.w #$00FF
		ASL : TAX
		LDA.l StandingItemGraphicsOffsets,X : LDX.w ItemStackPtr : STA.l ItemGFXStack,X
		LDA.w DynamicDropGFXIndex : AND.w #$000F : ASL : TAX
		LDA.b IndoorsFlag : AND.w #$00FF : BEQ +
			LDA.l FreeUWGraphics,X : BRA ++
			+ LDA.l FreeOWGraphics,X
		++ LDX.w ItemStackPtr : STA.l ItemTargetStack,X
		TXA : INC #2 : STA.w ItemStackPtr
	SEP #$30
	PLX

	.success
	STZ.w SprRedrawFlag, X
	.return
	PLY : PLX
	RTL

;===================================================================================================

FreeUWGraphics:
	dw $8800>>1 ; Shovel Dirt
	dw $8840>>1 ; (Unused)
	dw $8980>>1 ; (Unused)
	dw $9960>>1 ; Arghuss/Zora Splash
	dw $9C00>>1 ; Heart Piece
;	dw $9CA0>>1 ; Apple
	dw $9DC0>>1 ; Whirlpool
	; add new slots above this line
.end

FreeOWGraphics:
	dw $8180>>1 ; Push Block
	;dw $8800>>1 ; Shovel Dirt
	dw $9960>>1 ; Arghuss/Zora Splash
	dw $9C00>>1 ; Heart Piece
	;dw $9CA0>>1 ; Apple
	;dw $9DC0>>1 ; Whirlpool
	; add new slots above this line
.end

FixedItemGraphics:
	dw $9400>>1 ; (overflow full slot)
	dw $9D40>>1 ; Fairy
	dw $9CA0>>1 ; Apple
.thin
	dw $9C60>>1 ; (overflow thin slot)
	dw $8160>>1 ; Rupee
	dw $8D60>>1 ; Key
	dw $9C80>>1 ; Bee

; Below are the two default 16-byte tables that are loaded
; into SpriteDynamicOAM, and adjustments are applied afterwards
; Format of SpriteDynamicOAM:
; First 8 bytes are the top half, last 8 bytes are bottom half (unused by 16x16 gfx)
; X Offset (2 bytes)
; Y Offset (2 bytes)
;    - these offsets are relative to its normal draw position
; VRAM Location (1 byte) - relative to $8000, every 8x8 tile
;                           increments by 1 (ie. small key is $6B)
; Palette Data (1 byte)
; TBD (2 bytes)

DynamicOAMTile_thin:
	dw 4, 0 : db $00, $00, $20, $00
	dw 4, 8 : db $00, $00, $20, $00

DynamicOAMTile_full:
	dw 0, -1 : db $00, $00, $20, $02
	dd 0, 0

;===================================================================================================
; Come in with
;   A = item receipt ID
;   X = sprite slot
; Returns with Carry flag set if gfx drawing was skipped
DrawPotItem:
	PHA
		; TODO: Figure out a better way to stop items during transitions, or figure
		; out how to get narrow items to continue drawing narrow during transitions
		; This has a side effect of ItemID $00 (unused in rando currently)
		; disappearing during various submodule uses, like dialogue/trap door actions
		CMP.b #$00 : BNE +
			LDA.b GameSubMode : BEQ +
				PLA : SEC : RTL
		; TODO: allow drawing if gfx are not using a VRAM slot that changes during medallion
		+ LDA.b IndoorsFlag : BEQ + ; OW current doesn't occupy any slots that medallion gfx do
			LDA.w GfxChrHalfSlotVerify : CMP.b #$03 : BCC +
				PLA : SEC : RTL
		+
		JSR PrepItemAnimation
	PLA
	
	PHX
	TAX
	STA.b Scrap07 ; store loot ID temporarily, will get overwritten in Sprite_DrawMultiple_quantity_preset call
	LDA.l BeeTrapDisguise : BEQ +
		TAX : STA.b Scrap07
	+ 
	LDA.l SpriteProperties_standing_width,X : BEQ .narrow

	.full
	PLX
	LDA.b #$01 : STA.b Scrap06
	LDA.b #$0C : JSL OAM_AllocateFromRegionC
	LDA.b #$02 : PHA
		REP #$20 : LDA.w #DynamicOAMTile_full
	BRA .transfer

	.narrow
	PLX
	LDA.b #$02 : STA.b Scrap06
	LDA.b #$10 : JSL OAM_AllocateFromRegionC
	LDA.b #$03 : PHA
		REP #$20 : LDA.w #DynamicOAMTile_thin

    .transfer
	STA.b Scrap08
	PHK : PLY : STY.b Scrap0A
	LDY.b #$7E : PHB : PHY : PLB
		; transfer fixed table data into WRAM
		LDY.b #$0E
		- LDA.b [$08],Y : STA.w SpriteDynamicOAM,Y
			DEY : DEY : BPL -

		LDY.b #FreeUWGraphics>>16 : PHB : PHY : PLB
		LDA.w SprItemGFXSlot,X : AND.w #$00FF : ASL : TAY
		LDA.b IndoorsFlag : AND.w #$00FF : BEQ +
			CPY.b #(FreeUWGraphics_end-FreeUWGraphics) : BCC ++
			TYA : SEC : SBC.w #(FreeUWGraphics_end-FreeUWGraphics) : TAY : BRA .fixed
			++ LDA.w FreeUWGraphics, Y : BRA .setVRAM
		+ CPY.b #(FreeOWGraphics_end-FreeOWGraphics) : BCC ++
			TYA : SEC : SBC.w #(FreeOWGraphics_end-FreeOWGraphics) : TAY : BRA .fixed
			++ LDA.w FreeOWGraphics, Y : BRA .setVRAM

		.fixed
		LDA.b Scrap06 : LSR : BCC +
			LDA.w FixedItemGraphics, Y : BRA .setVRAM
		+ LDA.w FixedItemGraphics_thin, Y

		.setVRAM
		LSR #4 : AND.w #$FBFF : PLB : PHA
		STA.w SpriteDynamicOAM+4

		LDA.b Scrap06 : LSR : PLA : BCS .adjustFull
			; narrow
			CLC : ADC.w #$0010 : STA.w SpriteDynamicOAM+12
			CMP.w #$00F4 : BNE +
				; exception for good bee, needs blank tile on top
				LDA.w #$007C : STA.w SpriteDynamicOAM+4
			+

		.adjust
		LDA.w SpriteTypeTable, X : AND.w #$00FF : CMP.w #$003B : BNE +
			LDA.b RoomIndex : CMP.w #$0107 : BNE .shiftLeft ; bonk item
			LDA.w SpriteTypeTable, X : AND.w #$00FF
		+ CMP.w #$00E4 : BNE +
			LDA.b OverworldIndex : AND.w #$00FF : CMP.w #$0018 : BEQ .shiftLeft ; bottle vendor key
		+
		.adjustFull
		LDA.b RoomIndex : CMP.w #$0087 : BNE +
			LDA.b IndoorsFlag : AND.w #$00FF : BEQ +
			LDA.w SpriteTypeTable, X : AND.w #$00FF : CMP.w #$00EB : BEQ .drawSpecial
			LDA.w SprItemFlags, X : AND.w #$00FF : BEQ .shiftUpLeft ; hera cage item
			BRA .shiftLeft
		+
		LDA.w SprItemFlags, X : AND.w #$00FF : BEQ .drawSpecial

			.shiftUpLeft
			DEC.w SpriteDynamicOAM+2 : DEC.w SpriteDynamicOAM+10
			.shiftLeft
			LDA.w SpriteDynamicOAM : SEC : SBC.w #$0004
			STA.w SpriteDynamicOAM : STA.w SpriteDynamicOAM+8

		.drawSpecial
		; special animation handling
		LDY.b Scrap07 : CPY.b #$D2 : BNE + ; fairy
			LDY.w SpriteDirectionTable, X : BEQ ++ : CPY.b #$03 : BEQ ++ ; use other fairy GFX
				LDA.w SpriteDynamicOAM+4 : CLC : ADC.w #$0002 : STA.w SpriteDynamicOAM+4
			++ CPY.b #$02 : BCC .draw ; move fairy up 2 pixels
				LDA.w SpriteDynamicOAM+2 : SEC : SBC.w #$0002 : STA.w SpriteDynamicOAM+2
				BRA .draw
		+ CPY.b #$D6 : BNE + ; good bee
			LDY.w SpriteDirectionTable, X : BEQ ++ : CPY.b #$03 : BEQ ++ ; use other bee GFX
				LDA.w SpriteDynamicOAM+12 : SEC : SBC.w #$0010 : STA.w SpriteDynamicOAM+12
			++ CPY.b #$02 : BCC + ; move bee up 2 pixels
				LDA.w SpriteDynamicOAM+10 : SEC : SBC.w #$0002 : STA.w SpriteDynamicOAM+10
		+

		.draw
		LDA.w #SpriteDynamicOAM : STA.b Scrap08
		SEP #$20
		STZ.b Scrap07
		LDA.b #$00 : STA.l SpriteSkipEOR
		JSL Sprite_DrawMultiple_quantity_preset
	PLB
	
	LDA.b OAMPtr : CLC : ADC.b #$08 : STA.b OAMPtr
	INC.b OAMPtr+2 : INC.b OAMPtr+2

	PLA
	CLC
	RTL

DynamicDropGFXClear:
	PHA : PHX
		LDX.b #$0E
		- STZ.w DynamicDropGFXSlots, X : DEX : BPL -
	PLX : PLA
RTL

ConditionalPushBlockTransfer:
	LDA.b IndoorsFlag : BNE +
		LDA.b #$0F ; don't transfer push block when on the OW
		BRA .return-3
	+
	LDA.b #$1F : STA.w DMAENABLE ; what we wrote over
	.return
RTL

PrepItemAnimation:
	LDA.b FrameCounter : AND.b #$30 : LSR #4 : STA.w SpriteDirectionTable, X
RTS

PrepAncillaAnimation:
	PHP : SEP #$20
		LDA.b FrameCounter : AND.b #$30 : LSR #4 : STA.w AncillaDirection, X
	PLP
RTL

WaitForNewVBlank:
	LDA.b #$00 : STA.w NMITIMEN ; Disable interrupts
	- LDA.w RDNMI : BMI - ; Wait until v-blank is over
	- LDA.w RDNMI : BPL - ; Wait until v-blank starts
	LDA.b #$80 : STA.w NMITIMEN
RTL

TransferCommonToVRAM:
	PHP
	REP #$21
	SEP #$10

	LDA.w #BigDecompressionBuffer+$2400
	LDX.b #BigDecompressionBuffer>>16
	STA.w $4302
	STX.w $4304

	LDX.b #$80 : STX.w $2115
	LDA.w #$1801 : STA.w $4300
	LDA.w #$1000 : STA.w $4305
	LDA.w #$4800 : STA.w $2116
	LDX.b #$01 : STX.w DMAENABLE

	PLP
RTL

pushpc
; fix Arghuss/Zora splash graphics
org $868595
    db $E7, $E7, $E7, $E7, $E7, $C0, $C0
pullpc

