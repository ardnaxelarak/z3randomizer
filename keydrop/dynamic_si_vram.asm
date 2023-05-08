; where we shove the decompressed graphics to send to WRAM
DynamicDropGFX = $7ECC00

; this will just count from 0 to 4 to determine which slot we're using
; we're expecting 5 items max per room, and order is irrelevant
; we just need to keep track of where they go
DynamicDropGFXIndex = $7E1E70
!DynamicDropGFXSlotCount_UW = (FreeUWGraphics_end-FreeUWGraphics)>>1
!DynamicDropGFXSlotCount_OW = (FreeOWGraphics_end-FreeOWGraphics)>>1

; this will keep track of the above for each item
SprItemGFX = $7E0780

; this is the item requested and a flag (we anticipate no more than 3 requests to be active, but built to support 8)
DynamicDropRequest = $7E1E71 ; bitfield indicating which request slot to process
DynamicDropQueue = $7E1E72 ; 0x08 bytes, occupies 1 byte for each slot in the request queue (loot id at first, but stores GFX index)

; Come in with
;   A = item receipt ID
;   X = slot
RequestSlottedTile:
	PHX : PHY

	PHA
		; skip sending the request if busy with other 
		LDA.b $11 : CMP.b #$21 : BCS ++ ; skip if OW is loading Map16 GFX ; TODO: Figure out how to allow submodule 22, check DMA status instead
		LDA.b $5D : CMP.b #$14 : BEQ ++ ; skip if we're mid-mirror
		LDA.b $1B : BEQ + ; OW current doesn't occupy any slots that medallion gfx do
			CMP.b #$08 : BCC + : CMP.b #$0A+1 : BCS + ; skip if we're mid-medallion
				++ PLA : JMP .return
		+

		LDA.w $0E20, X : CMP.b #$C0 : BNE + ; if catfish
			TYX
		+ CMP.b #$52 : BNE + ; if zora
			TYX
		+

		LDA 1,S : JSL.l GetSpritePalette : STA $0F50, X ; setup the palette
	PLA
	
	; gfx that are already present, use that instead of a new slot
	CMP.b #$34 : BCC + : CMP.b #$36+1 : BCS + ; if rupees, use animated rupee OAM slot
		LDA.b $1B : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ STA.w SprItemGFX,X
		JMP .success
	+ CMP.b #$A0 : BCC + : CMP.b #$AF+1 : BCS + ; if key, use key OAM slot
		LDA.b $1B : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC : STA.w SprItemGFX,X
		JMP .success
	+ CMP.b #$B5 : BNE + ; if good bee, use bee OAM slot
		LDA.b $1B : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ INC : INC : STA.w SprItemGFX,X
		JMP .success
	+ CMP.b #$B2 : BNE + ; if fairy, use fairy OAM slot
		LDA.b $1B : BEQ ++
			LDA.b #!DynamicDropGFXSlotCount_UW
			BRA +++
		++ LDA.b #!DynamicDropGFXSlotCount_OW
		+++ STA.w SprItemGFX,X
		JMP .success
	+
	
	PHA : PHX
		LDY.b #$00
		LDA.w DynamicDropRequest
		- LSR : INY : BCS -
		CPY.b #$08 : BCC +
			; all request slots occupied, exit without drawing
			PLX : PLA
			LDY.b #$FE ; indicate failure
			BRA .return
		+ TYX
		LDA.b #$00 : SEC
		- ROL : DEX : BNE -
		DEY ; y = slot index, a = new request bit flag
		ORA.w DynamicDropRequest
		STA.w DynamicDropRequest
	PLX : PLA
	STA.w DynamicDropQueue,Y

	LDA.w DynamicDropGFXIndex
	INC
	PHX
	LDX.b $1B : BEQ +
		CMP.b #!DynamicDropGFXSlotCount_UW : BCC .fine
		BRA ++
	+ CMP.b #!DynamicDropGFXSlotCount_OW : BCC .fine

	++ LDA.b #$00

.fine
	PLX
	STA.w DynamicDropGFXIndex
	STA.w SprItemGFX,X

	; decompress graphics
	PHX : PHY

	REP #$20
	LDA.w #DynamicDropGFX-$7E9000
	TYX : BEQ +
		- CLC : ADC.w #$0080 : DEX : BNE -
	+ STA.l !TILE_UPLOAD_OFFSET_OVERRIDE
	SEP #$20

	LDA.w DynamicDropQueue,Y
	JSL.l GetSpriteID
	JSL.l GetAnimatedSpriteTile_variable

	SEP #$30
	PLY : PLX
	LDA.w DynamicDropGFXIndex : STA.w DynamicDropQueue,Y
	LDA.w DynamicDropQueue,Y ; we want A to return the loot id

	.success
	STZ.w !SPRITE_REDRAW, X
	.return
	PLY : PLX
	RTL

;===================================================================================================

TransferPotGFX:
	SEP #$10
	REP #$20
	LDA.w DynamicDropRequest : AND.w #$00FF
	BEQ .no

	.next
	LDY.b #$00
	- INY : LSR : BCC -

	PHY
		LDA.w #$0000
		- ROL : DEY : BNE -
	PLY
	DEY ; y = slot index, a = request bit flag

	EOR.w DynamicDropRequest : STA.w DynamicDropRequest

	LDA.w DynamicDropQueue,Y
	ASL
	TAX
	LDA.b $1B : AND.w #$00FF : BEQ +
		LDA.l FreeUWGraphics,X
		BRA ++
	+ LDA.l FreeOWGraphics,X
	++ STA.w $2116

	; calculate bottom row now
	CLC : ADC.w #$0200>>1 : PHA

	LDX.b #$7E : STX.w $4314
	LDA.w #DynamicDropGFX
	CPY.b #$00 : BEQ +
		- CLC : ADC.w #$0080 : DEY : BNE -
	+ STA.w $4302

	LDX.b #$80 : STX.w $2115
	LDA.w #$1801 : STA.w $4300

	LDA.w #$0040 : STA.w $4305
	LDY.b #$01

	STY.w $420B
	STA.w $4305

	PLA
	STA.w $2116
	STY.w $420B

	LDA.w DynamicDropRequest : AND.w #$00FF
	BNE .next

.no
	RTL


FreeUWGraphics:
	dw $8800>>1
	dw $8840>>1
	dw $8980>>1
;	dw $9960>>1 ; Arghuss Splash apparently
;	dw $9C00>>1
	dw $9CA0>>1
	dw $9DC0>>1
.end

FreeOWGraphics:
	;dw $8800>>1 ; Shovel Dirt
	dw $9960>>1 ; Arghuss/Zora Splash
	dw $9C00>>1 ; Heart Piece
	dw $9CA0>>1 ; Apple
	;dw $9DC0>>1 ; Whirlpool
.end

;===================================================================================================
; Come in with
;   A = item receipt ID
;   X = sprite slot
; Returns with Carry flag set if gfx drawing was skipped
DrawSlottedTile:
	PHA
		; TODO: allow drawing if gfx are not using a VRAM slot that changes during medallion
		LDA.b $5D : CMP.b #$08 : BCC + : CMP.b #$0A+1 : BCS + ; skip if we're mid-medallion
			PLA : SEC : RTL
		+
	PLA
	STA.b $BD ; store loot ID temporarily, will get overwritten in Sprite_DrawMultiple_quantity_preset call
	JSL.l IsNarrowSprite : BCS .narrow

	; TODO: Instead of loading the whole fixed 16 bytes from DynamicOAMTile**_** into !SPRITE_DYNAMIC_OAM
	;       Do something more like how DrawDynamicTile does it
	;       Then we won't need all the separate DynamicOAMTile**_** tables
	.full
	LDA.b #$01 : STA $06
	LDA #$0C : JSL.l OAM_AllocateFromRegionC
	LDA #$02 : PHA
		REP #$20
		LDA.b $1B : AND.w #$00FF : BEQ +
			LDA.w #DynamicOAMTileUW_full
			BRA .transfer
		+ LDA.w #DynamicOAMTileOW_full
	BRA .transfer

	.narrow
	LDA.b #$02 : STA $06
	LDA #$10 : JSL.l OAM_AllocateFromRegionC
	LDA #$03 : PHA
		REP #$20
		LDA.b $1B : AND.w #$00FF : BEQ +
			LDA.w #DynamicOAMTileUW_thin
			BRA .transfer
		+ LDA.w #DynamicOAMTileOW_thin
    .transfer
	STA.b $08
	LDA.w SprItemGFX,X
	AND.w #$00FF
	ASL : ASL : ASL : ASL
	ADC.b $08
	STA.b $08
	PHK : PLY : STY.b $0A
	LDY #$7E : PHB : PHY : PLB

		; transfer fixed table data into WRAM
		LDY.b #$0E
		- LDA.b [$08],Y : STA.w !SPRITE_DYNAMIC_OAM,Y
			DEY : DEY : BPL -

		LDA.w SprItemFlags, X : AND.w #$00FF : BNE .draw
			LDA.b $06 : LSR : BCC +
				; full
				LDA.w #$0000
				STA.w !SPRITE_DYNAMIC_OAM : STA.w !SPRITE_DYNAMIC_OAM+2
				BRA .draw
			+ ; narrow
			LDA.w $0E20, X : AND.w #$00FF : CMP.w #$003B : BEQ .draw ; bonk item
				LDA.w #$0004
				STA.w !SPRITE_DYNAMIC_OAM : STA.w !SPRITE_DYNAMIC_OAM+8

		.draw
		; special handling
		LDY.b $BD : CPY.b #$B2 : BNE + ; fairy
			LDA.b $1A : AND.w #$0020 : BEQ ++ ; alternate every 32 frames
				LDA.w !SPRITE_DYNAMIC_OAM+4 : CLC : ADC.w #$02 ; use other fairy GFX
				STA.w !SPRITE_DYNAMIC_OAM+4
			++ LDA.b $1A : SEC : SBC.w #$10 : AND.w #$0020 : BEQ + ; alternate every 32 frames
				LDA.w !SPRITE_DYNAMIC_OAM+2 : SEC : SBC.w #$02 ; move fairy up 2 pixels
				STA.w !SPRITE_DYNAMIC_OAM+2
		+ CPY.b #$B5 : BNE + ; good bee
			LDA.b $1A : AND.w #$0020 : BEQ ++ ; alternate every 32 frames
				LDA.w !SPRITE_DYNAMIC_OAM+12 : SEC : SBC.w #$10 ; use other fairy GFX
				STA.w !SPRITE_DYNAMIC_OAM+12
			++ LDA.b $1A : SEC : SBC.w #$10 : AND.w #$0020 : BEQ + ; alternate every 32 frames
				LDA.w !SPRITE_DYNAMIC_OAM+10 : SEC : SBC.w #$02 ; move fairy up 2 pixels
				STA.w !SPRITE_DYNAMIC_OAM+10
		+

		LDA.w #!SPRITE_DYNAMIC_OAM : STA.b $08
		SEP #$20
		STZ.b $07
		LDA.b #$00 : STA.l !SKIP_EOR
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

	dw 0, 0 : db $E5, $00, $20, $00
	dw 0, 8 : db $F5, $00, $20, $00

	dw 0, 0 : db $EE, $00, $20, $00
	dw 0, 8 : db $FE, $00, $20, $00

	; add new slots above this line

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

	dw -4, -1 : db $E5, $00, $20, $02
	dd 0, 0

	dw -4, -1 : db $EE, $00, $20, $02
	dd 0, 0

	; add new slots above this line

	dw -4, -1 : db $EA, $00, $20, $02 ; fairy
	dd 0, 0

DynamicOAMTileOW_thin:
	; dw 0, 0 : db $40, $00, $20, $00
	; dw 0, 8 : db $50, $00, $20, $00

	dw 0, 0 : db $CB, $00, $20, $00
	dw 0, 8 : db $DB, $00, $20, $00

	dw 0, 0 : db $E0, $00, $20, $00
	dw 0, 8 : db $F0, $00, $20, $00

	dw 0, 0 : db $E5, $00, $20, $00
	dw 0, 8 : db $F5, $00, $20, $00

	;dw 0, 0 : db $EE, $00, $20, $00
	;dw 0, 8 : db $FE, $00, $20, $00

	; add new slots above this line

	dw 0, 0 : db $0B, $00, $20, $00 ; animated rupees slot
	dw 0, 8 : db $1B, $00, $20, $00

	dw 0, 0 : db $6B, $00, $20, $00 ; key
	dw 0, 8 : db $7B, $00, $20, $00

	dw 0, 0 : db $7C, $00, $20, $00 ; good bee
	dw 0, 8 : db $F4, $00, $20, $00

DynamicOAMTileOW_full:
	; dw 0, 0 : db $40, $00, $20, $02
	; dd 0, 0

	dw 0, 0 : db $CB, $00, $20, $02
	dd 0, 0

	dw 0, 0 : db $E0, $00, $20, $02
	dd 0, 0

	dw 0, 0 : db $E5, $00, $20, $02
	dd 0, 0

	;dw 0, 0 : db $EE, $00, $20, $02
	;dd 0, 0

	; add new slots above this line

	dw 0, 0 : db $EA, $00, $20, $02 ; fairy
	dd 0, 0

