
StandItemGFXIDs = $7E07E0 ; 0x8 bytes for IDs
StandingItemTransferGFX = $7E07E8 ; bit field for item transfers
SICharRecID = $7E07E9 ; ID of receipt item for temp use
SICharSource = $7E07EA ; source address of the sprite's graphics
SIVRAMAddr = $7E07ED ; VRAM address to write the next slot to
SIVRAMSlot = $7E07EF ; current vram slot to ask for
SprSIChar = $7E07F0 ; standing item character for draw routine

;===================================================================================================


SpriteDraw_DynamicStandingItem:
	JSL Sprite_PrepOAMCoord_long ; 06E41C

	LDA.b $00 : STA.b ($90),Y

	LDA.b $01 : CMP.b #$01
	LDA.b #$01 : ROL : STA.b ($92)

	INY

	REP #$21

	LDA.b $02 : ADC.w #$0010
	CMP.w #$0100

	SEP #$20 : BCS .off_screen

	SBC.b #$0F : STA.b ($90),Y

	INY

	LDA.w SprDropsItem,X : STA.b ($90),Y

	INY

	LDA.b $05 : STA.b ($90),Y

.off_screen
	JML SpriteDraw_Shadow_long ; 06DC5C

; Call from standing/dropped items to request a free slot in VRAM in underworld
; Enter with
;   A = receipt ID
;   X = sprite slot
RequestStandingItemVRAMSlot:
	JSR SetSISource
	JSR GetSIVRAMSlot
	RTL

; Take 8-bit receipt ID and turn it into a 24-bit source graphics address
; how we use this is TBD
; we could set up a buffer of 8 24-bit addresses to reference during NMI
; and we may or may not do decompression from here
SetSISource:
	STA.w SICharRecID
	PHX ; make sure X is preserved during this

	PLX
	STA.w SICharSource+1
	STY.w SICharSource+2 ; don't need to use Y, but just as an example

	RTS

GetSIVRAMSlot:
	SEP #$30

	PHX

	LDA.w SIVRAMSlot : TAX

	INC
	CMP.b #$07 : BCC .fine

	LDA.b #$00

.fine
	STA.w SIVRAMSlot

	; flag this slot for a transfer
	LDA.l .eightbits,X
	ORA.l StandingItemTransferGFX
	STA.l StandingItemTransferGFX

	; set grapgics ID to look up for NMI transfer
	LDA.w SICharRecID
	STA.w StandItemGFXIDs,X

	LDA.l .char,X
	PLX

	STA.w SprSIChar,X

	RTS



.char
	db $20
	db $22
	db $2C
	db $CB
	db $E0
	db $E5
	db $EE

.eightbits
	db 1<<0
	db 1<<1
	db 1<<2
	db 1<<3
	db 1<<4
	db 1<<5
	db 1<<6
	db 1<<7

;===================================================================================================

NMI_TransferSIGFX:
	LDA.l StandingItemTransferGFX
	BEQ .exit

	REP #$20
	AND.w #$00FF
	STA.b $00

	LDY.b #$80 : STY.w $2115

	LDX.b #$00

.next
	LSR.b $00 : BEQ .done : BCC .skip

	PHX

	TXY
	TXA : ASL : TAX

	LDA.l .addr,X : STA.w $2116

	; get source address based on ID
	LDA.w StandItemGFXIDs,Y
	; code
	STA.b $04 ; source address
	STY.w $4344 ; source bank

	LDY.b #$10 ; DMA trigger

	STA.w $4342 ; save address
	LDA.w #$1801 : STA.w $4340 ; DMA type
	LDA.w #64 : STA.w $4345 ; DMA size
	STY.w $420B

	STA.w $4345 ; DMA size again
	CLC
	LDA.b $04 : ADC.w #$0200 : STA.w $4344 ; assuming we've got things in squares in ROM
	STY.w $420B

	PLX

.skip
	INX
	BRA .next


.done
	SEP #$20

.exit
	RTL

.addr
	dw $8800>>1
	dw $8840>>1
	dw $8980>>1
	dw $9960>>1
	dw $9C00>>1
	dw $9CA0>>1
	dw $9DC0>>1