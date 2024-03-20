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
		JSL Sprite_IsOnscreen : BCC ++
		; skip sending the request if busy with other things
		LDA.b GameSubMode : CMP.b #$21 : BCS ++ ; skip if OW is loading Map16 GFX ; TODO: Figure out how to allow submodule 22, check DMA status instead
		LDA.b LinkState : CMP.b #$14 : BEQ ++ ; skip if we're mid-mirror
		LDA.b IndoorsFlag : BEQ + ; OW current doesn't occupy any slots that medallion gfx do
			LDA.w GfxChrHalfSlotVerify : CMP.b #$03 : BCC +
				++ PLA : JMP .return
		+

		LDA.b 1,S : PHX : JSL GetSpritePalette : PLX : STA.w SpriteOAMProp, X ; setup the palette
	PLA
	
	; gfx that are already present in vanilla, use that instead of a new slot
	CMP.b #$34 : BCC + : CMP.b #$36+1 : BCS + ; if rupees, use animated rupee OAM slot
		LDA.b IndoorsFlag : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC : STA.w SprItemGFXSlot,X
		JMP .success
	+ CMP.b #$A0 : BCC + : CMP.b #$AF+1 : BCS + ; if key, use key OAM slot
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
nop #10
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
	dw $8800>>1
	dw $8840>>1
	dw $8980>>1
	dw $9960>>1 ; Arghuss Splash apparently
	dw $9C00>>1
;	dw $9CA0>>1
	dw $9DC0>>1
	; add new slots above this line
.end
	dw $0000 ; overflow slot, intentionally blank
	; above this line, add slots that we want to draw to specific slots

FreeOWGraphics:
	dw $8180>>1 ; Push Block
	;dw $8800>>1 ; Shovel Dirt
	dw $9960>>1 ; Arghuss/Zora Splash
	dw $9C00>>1 ; Heart Piece
	;dw $9CA0>>1 ; Apple
	;dw $9DC0>>1 ; Whirlpool
	; add new slots above this line
.end
	dw $0000 ; overflow slot, intentionally blank
	; above this line, add slots that we want to draw to specific slots

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
	PLA
	
	PHX
	TAX
	STA.b Scrap07 ; store loot ID temporarily, will get overwritten in Sprite_DrawMultiple_quantity_preset call
	LDA.l BeeTrapDisguise : BEQ +
		TAX : STA.b Scrap07
	+ 
	LDA.l SpriteProperties_standing_width,X : BEQ .narrow

	; TODO: Instead of loading the whole fixed 16 bytes from DynamicOAMTile**_** into SpriteDynamicOAM
	;       Do something more like how DrawDynamicTile does it
	;       Then we won't need all the separate DynamicOAMTile**_** tables
	.full
	PLX
	LDA.b #$01 : STA.b Scrap06
	LDA.b #$0C : JSL OAM_AllocateFromRegionC
	LDA.b #$02 : PHA
		REP #$20
		LDA.b IndoorsFlag : AND.w #$00FF : BEQ +
			LDA.w #DynamicOAMTileUW_full
			BRA .transfer
		+ LDA.w #DynamicOAMTileOW_full
	BRA .transfer

	.narrow
	PLX
	LDA.b #$02 : STA.b Scrap06
	LDA.b #$10 : JSL OAM_AllocateFromRegionC
	LDA.b #$03 : PHA
		REP #$20
		LDA.b IndoorsFlag : AND.w #$00FF : BEQ +
			LDA.w #DynamicOAMTileUW_thin
			BRA .transfer
		+ LDA.w #DynamicOAMTileOW_thin
    .transfer
	STA.b Scrap08
	LDA.w SprItemGFXSlot,X
	AND.w #$00FF
	ASL : ASL : ASL : ASL
	ADC.b Scrap08
	STA.b Scrap08
	PHK : PLY : STY.b Scrap0A
	LDY.b #$7E : PHB : PHY : PLB

		; transfer fixed table data into WRAM
		LDY.b #$0E
		- LDA.b [$08],Y : STA.w SpriteDynamicOAM,Y
			DEY : DEY : BPL -

		LDA.w SprItemFlags, X : AND.w #$00FF : BNE .draw
			LDA.b Scrap06 : LSR : BCC +
				; full
				LDA.w #$0000
				STA.w SpriteDynamicOAM : STA.w SpriteDynamicOAM+2
				BRA .draw
			+ ; narrow
			LDA.w SpriteTypeTable, X : AND.w #$00FF : CMP.w #$003B : BEQ .draw ; bonk item
			LDA.b RoomIndex : CMP.w #$0120 : BNE +
				LDA.b IndoorsFlag : BEQ .draw ; good bee statue
			+
			LDA.b OverworldIndex : AND.w #$00FF : CMP.w #$0018 : BNE +
				LDA.w SpriteTypeTable, X : AND.w #$00FF : CMP.w #$00E4 : BEQ .draw ; bottle vendor key
			+
				LDA.w #$0004
				STA.w SpriteDynamicOAM : STA.w SpriteDynamicOAM+8

		.draw
		; special handling
		LDY.b Scrap07 : CPY.b #$D2 : BNE + ; fairy
			LDA.b FrameCounter : AND.w #$0020 : BEQ ++ ; alternate every 32 frames
				LDA.w SpriteDynamicOAM+4 : CLC : ADC.w #$02 ; use other fairy GFX
				STA.w SpriteDynamicOAM+4
			++ LDA.b FrameCounter : SEC : SBC.w #$10 : AND.w #$0020 : BEQ + ; alternate every 32 frames
				LDA.w SpriteDynamicOAM+2 : SEC : SBC.w #$02 ; move fairy up 2 pixels
				STA.w SpriteDynamicOAM+2
		+ CPY.b #$D6 : BNE + ; good bee
			LDA.b FrameCounter : AND.w #$0020 : BEQ ++ ; alternate every 32 frames
				LDA.w SpriteDynamicOAM+12 : SEC : SBC.w #$10 ; use other fairy GFX
				STA.w SpriteDynamicOAM+12
			++ LDA.b FrameCounter : SEC : SBC.w #$10 : AND.w #$0020 : BEQ + ; alternate every 32 frames
				LDA.w SpriteDynamicOAM+10 : SEC : SBC.w #$02 ; move fairy up 2 pixels
				STA.w SpriteDynamicOAM+10
		+

		LDA.w #SpriteDynamicOAM : STA.b Scrap08
		SEP #$20
		STZ.b Scrap07
		LDA.b #$00 : STA.l SpriteSkipEOR
		JSL Sprite_DrawMultiple_quantity_preset
	PLB
	
	LDA.b $90 : CLC : ADC.b #$08 : STA.b $90
	INC.b $92 : INC.b $92

	PLA
	CLC
	RTL

DynamicOAMTileUW_thin:
	dw 0, 0 : db $40, $00, $20, $00
	dw 0, 8 : db $50, $00, $20, $00

	dw 0, 0 : db $42, $00, $20, $00
	dw 0, 8 : db $52, $00, $20, $00

	dw 0, 0 : db $4C, $00, $20, $00
	dw 0, 8 : db $5C, $00, $20, $00

	dw 0, 0 : db $CB, $00, $20, $00
	dw 0, 8 : db $DB, $00, $20, $00

	dw 0, 0 : db $E0, $00, $20, $00
	dw 0, 8 : db $F0, $00, $20, $00

	dw 0, 0 : db $EE, $00, $20, $00
	dw 0, 8 : db $FE, $00, $20, $00

	; add new slots above this line

	dw 0, 0 : db $E3, $00, $20, $00 ; overflow slot
	dw 0, 8 : db $F3, $00, $20, $00

	; above this line, add slots that we want to draw to specific slots

	dw 0, 0 : db $0B, $00, $20, $00 ; animated rupees slot
	dw 0, 8 : db $1B, $00, $20, $00

	dw 0, 0 : db $6B, $00, $20, $00 ; key
	dw 0, 8 : db $7B, $00, $20, $00

	dw 0, 0 : db $7C, $00, $20, $00 ; good bee
	dw 0, 8 : db $F4, $00, $20, $00

DynamicOAMTileUW_full:
	dw -4, -1 : db $40, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $42, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $4C, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $CB, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $E0, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $EE, $00, $20, $02
	dd 0, 0

	; add new rotating slots above this line

	dw -4, -1 : db $A0, $00, $20, $02 ; overflow slot
	dd 0, 0

	; above this line, add slots that we want to draw to specific slots

	dw -4, -1 : db $EA, $00, $20, $02 ; fairy
	dd 0, 0

	dw -4, -1 : db $E5, $00, $20, $02 ; apple
	dd 0, 0

DynamicOAMTileOW_thin:
	dw 0, 0 : db $0C, $00, $20, $00
	dw 0, 8 : db $1C, $00, $20, $00

	; dw 0, 0 : db $40, $00, $20, $00
	; dw 0, 8 : db $50, $00, $20, $00

	dw 0, 0 : db $CB, $00, $20, $00
	dw 0, 8 : db $DB, $00, $20, $00

	dw 0, 0 : db $E0, $00, $20, $00
	dw 0, 8 : db $F0, $00, $20, $00

	;dw 0, 0 : db $E5, $00, $20, $00
	;dw 0, 8 : db $F5, $00, $20, $00

	;dw 0, 0 : db $EE, $00, $20, $00
	;dw 0, 8 : db $FE, $00, $20, $00

	; add new slots above this line

	dw 0, 0 : db $E3, $00, $20, $00 ; overflow slot
	dw 0, 8 : db $F3, $00, $20, $00

	; above this line, add slots that we want to draw to specific slots

	dw 0, 0 : db $0B, $00, $20, $00 ; animated rupees slot
	dw 0, 8 : db $1B, $00, $20, $00

	dw 0, 0 : db $6B, $00, $20, $00 ; key
	dw 0, 8 : db $7B, $00, $20, $00

	dw 0, 0 : db $7C, $00, $20, $00 ; good bee
	dw 0, 8 : db $F4, $00, $20, $00

DynamicOAMTileOW_full:
	dw 0, 0 : db $0C, $00, $20, $02
	dd 0, 0

	; dw 0, 0 : db $40, $00, $20, $02
	; dd 0, 0

	dw 0, 0 : db $CB, $00, $20, $02
	dd 0, 0

	dw 0, 0 : db $E0, $00, $20, $02
	dd 0, 0

	;dw 0, 0 : db $E5, $00, $20, $02
	;dd 0, 0

	;dw 0, 0 : db $EE, $00, $20, $02
	;dd 0, 0

	; add new slots above this line

	dw 0, 0 : db $A0, $00, $20, $02 ; overflow slot
	dd 0, 0

	; above this line, add slots that we want to draw to specific slots

	dw 0, 0 : db $EA, $00, $20, $02 ; fairy
	dd 0, 0

	dw 0, 0 : db $E5, $00, $20, $02 ; apple
	dd 0, 0

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
	LDA.b #$1F : STA.w $420B ; what we wrote over
	.return
RTL

pushpc
; fix Arghuss/Zora splash graphics
org $868595
    db $E7, $E7, $E7, $E7, $E7, $C0, $C0
pullpc

