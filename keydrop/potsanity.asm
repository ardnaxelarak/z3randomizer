; hooks
; todo: look up this hook in jpdasm
org $01E6B0
	JSL RevealPotItem
	RTS

org $06926e ; <- 3126e - sprite_prep.asm : 2664 (LDA $0B9B : STA $0CBA, X)
JSL SpriteKeyPrep : NOP #2

org $06d049 ; <- 35049 sprite_absorbable : 31-32 (JSL Sprite_DrawRippleIfInWater : JSR Sprite_DrawAbsorbable)
JSL SpriteKeyDrawGFX : BRA + : NOP : +

org $06d180
JSL BigKeyGet : BCS $07 : NOP #5

org $06d18d ; <- 3518D - sprite_absorbable.asm : 274 (LDA $7EF36F : INC A : STA $7EF36F)
JSL KeyGet

org $06f9f3 ; bank06.asm : 6732 (JSL Sprite_LoadProperties)
JSL LoadProperties_PreserveItemMaybe


; refs to other functions
org $06d23a
Sprite_DrawAbsorbable:
org $1eff81
Sprite_DrawRippleIfInWater:
org $0db818
Sprite_LoadProperties:

; defines
SpawnedItemID = $7E0720 ; 0x02
SpawnedItemPotIndex = $7E0722 ; 0x02
SpawnedItemIsMultiWorld = $7E0724 ; 0x02
SpawnedItemFlag = $7E0726 ; 0x02
PotItems = $01DDE7 ;original secret table?

RoomData_PotItems_Pointers = $01DB67

org $AA8000
;tables:
MultiWorldTable:
; Reserve $200 256 * 2

org $A98200
RevealPotItem:
	STA.b $04 ; save tilemap coordinates
	STZ.w SpawnedItemFlag
	LDA.w $0B9C : AND.w #$FF00 : STA.w $0B9C

	LDA.b $A0 : ASL : TAX

	LDA.l RoomData_PotItems_Pointers,X : STA.b $00 ; we may move this
	LDA.w #RoomData_PotItems_Pointers>>16 : STA.b $02

	LDY.w #$FFFD : LDX.w #$FFFF

.next_pot
	INY : INY : INY

	LDA.b [$00],Y
	CMP.w #$FFFF : BEQ .exit

	INX

	STA.w $06 ; remember the exact value
	AND.w #$3FFF
	CMP.b $04 : BNE .next_pot ; not the correct value

	STZ.w SpawnedItemIsMultiWorld
	BIT.b $06
	BVS LoadMultiWorldPotItem
	BMI LoadMajorPotItem

.normal_secret
	PLX ; remove the JSL return lower 16 bits
	PEA.w $01E6E2-1 ; change return address to go back to the vanilla routine
.exit
	RTL

LoadMultiWorldPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

	INC.w SpawnedItemIsMultiWorld
	PHX
	ASL : TAX

	LDA.l MultiWorldTable+1,X : AND.w #$00FF : STA.w !MULTIWORLD_SPRITEITEM_PLAYER_ID

	LDA.l MultiWorldTable+0,X : AND.w #$00FF

	PLX

	BRA SaveMajorItemDrop

LoadMajorPotItem:
	INY : INY
	LDA.b [$00],Y : AND.w #$00FF

SaveMajorItemDrop:
	; A currently holds the item receipt ID
	; X currently holds the pot item index
	STA.w SpawnedItemID
	STX.w SpawnedItemPotIndex
	INC SpawnedItemFlag
	LDA.w #$0008 : STA $0B9C ; indicates we should use the key routines
	RTL


SpriteKeyPrep:
	LDA.w $0B9B : STA.w $0CBA, x ; what we wrote over
	PHA
		LDA.l SpawnedItemFlag : BEQ +
		LDA.l SpawnedItemID : STA $0E80, X
		CMP #$24 : BNE ++ ; todo: check how the big key drop flows through this
			LDA $A0 : CMP.b #$80 : BNE +
			LDA SpawnedItemFlag : BNE +
				LDA #$24  ; it's the big key drop?
		++ JSL PrepDynamicTile
	+ PLA
	RTL

SpriteKeyDrawGFX:
    JSL Sprite_DrawRippleIfInWater
    PHA
        BRA +
            -
    + LDA $0E80, X
   	CMP.b #$24 : BNE +
   		LDA $A0 : CMP #$80 : BNE ++
   		LDA SpawnedItemFlag : BNE ++
    		LDA #$24 : BRA +
    	++ PLA
		   PHK : PEA.w .jslrtsreturn-1
		   PEA.w $068014 ; an rtl address - 1 in Bank06
		   JML Sprite_DrawAbsorbable
		   .jslrtsreturn
		   RTL
    + JSL DrawDynamicTile ; see DrawHeartPieceGFX if problems
    CMP #$03 : BNE +
        PHA : LDA $0E60, X : ORA.b #$20 : STA $0E60, X : PLA
    + JSL.l Sprite_DrawShadowLong
    PLA : RTL

KeyGet:
    LDA $7EF36F ; what we wrote over
    PHA
    	LDY $0E80, X
    	; todo: may need to check if we are in a dungeon or not $FF
    	LDA $A0 : CMP #$87 : BNE + ;check for hera cage
    	LDA SpawnedItemFlag : BNE + ; if it came from a pot, it's fine
    		JSR ShouldKeyBeCountedForDungeon : BCC ++
			JSL CountChestKeyLong
    		++ PLA : RTL
    	+ STY $00
    	LDA !MULTIWORLD_ITEM_PLAYER_ID : BNE .receive
    	PHX
    		; todo: may need to check if we are in a dungeon or not $FF
    		LDA $040C : LSR : TAX
    		LDA $00 : CMP.l KeyTable, X : BNE +
    			- JSL.l FullInventoryExternal : JSL CountChestKeyLong : PLX : PLA : RTL
    		+ CMP.b #$AF : beq - ; universal key
    		CMP.b #$24 : beq -   ; small key for this dungeon
    	PLX
    	.receive
    	JSL $0791b3 ; Player_HaltDashAttackLong
    	JSL.l Link_ReceiveItem
	PLA : DEC : RTL

KeyTable:
db $A0, $A0, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD

; Input Y - the item type
ShouldKeyBeCountedForDungeon:
	PHX
		; todo: may need to check if we are in a dungeon or not $FF
		LDA $040C : LSR : TAX
		TYA : cmp KeyTable, X : BNE +
			- PLX : SEC : RTS
		+ CMP.B #$24 : BEQ -
	PLX : CLC : RTS


BigKeyGet:
	LDY $0E80, X
	CPY #$32 : BNE +
		STZ $02E9 : LDY.b #$32 ; what we wrote over
		PHX : JSL Link_ReceiveItem : PLX ; what we wrote over
		CLC : RTL
	+ SEC : RTL

LoadProperties_PreserveItemMaybe:
    LDA $0E80, X : PHA
    JSL Sprite_LoadProperties
    PLA : STA $0e80, X
    RTL

org $01E676
db $14, $14, $07 ; Blue rupee   xyz:{ 0x050, 0x140, U }
db $28, $94, $08 ; Blue rupee   xyz:{ 0x0A0, 0x140, U }
db $24, $95, $1F ; Blue rupee   xyz:{ 0x050, 0x150, U }
db $28, $95, $4E ; Blue rupee   xyz:{ 0x0A0, 0x150, U }
db $14, $96, $5E ; Blue rupee   xyz:{ 0x050, 0x160, U }
db $28, $96, $64 ; Blue rupee   xyz:{ 0x0A0, 0x160, U }
db $18, $98, $4B ; Blue rupee   xyz:{ 0x060, 0x180, U }
db $1C, $98, $44 ; Blue rupee   xyz:{ 0x070, 0x180, U }
db $20, $98, $07 ; Blue rupee   xyz:{ 0x080, 0x180, U }
db $24, $98, $11 ; Blue rupee   xyz:{ 0x090, 0x180, U }