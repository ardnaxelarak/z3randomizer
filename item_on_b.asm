;--------------------------------------------------------------------------------
ItemMenuLocations:
	dw $11C8 ; Bow
	dw $11CE ; Boomerang
	dw $11D4 ; Hookshot
	dw $11DA ; Bombs
	dw $11E0 ; Powder / Mushroom
	dw $1288 ; Fire Rod
	dw $128E ; Ice Rod
	dw $1294 ; Bombos
	dw $129A ; Ether
	dw $12A0 ; Quake
	dw $1348 ; Lamp
	dw $134E ; Hammer
	dw $1354 ; Flute / Shovel
	dw $135A ; Bug Net
	dw $1360 ; Book
	dw $1408 ; Bottles
	dw $140E ; Somaria
	dw $1414 ; Byrna
	dw $141A ; Cape
	dw $1420 ; Mirror

DrawBIndicator:
	LDA.l ItemOnB : AND.w #$00FF : BEQ .done
	DEC : ASL : TAX
	LDA.l ItemMenuLocations, X : TAX
	LDA.w #$3D3F
	STA.w $0042, X

.done ; what we wrote over
	LDA.w $0202
	AND.w #$00FF
	DEC
	ASL
	TAX
	RTL
;--------------------------------------------------------------------------------
ItemHandlerLocs:
	dw $A003 ; Bow
	dw $A0B8 ; Boomerang
	dw $AB23 ; Hookshot
	dw $A139 ; Bombs
	dw $FFFF ; Powder / Mushroom
	dw $9EEC ; Fire Rod
	dw $9EEC ; Ice Rod
	dw $A55E ; Bombos
	dw $A489 ; Ether
	dw $A640 ; Quake
	dw $A246 ; Lamp
	dw $9F82 ; Hammer
	dw $FFFF ; Flute / Shovel
	dw $AFEE ; Bug Net
	dw $A46E ; Book
	dw $FFFF ; Bottles
	dw $AEBB ; Somaria
	dw $FFFF ; Byrna
	dw $FFFF ; Cape
	dw $A913 ; Mirror
ValidItemOnB:
	db $FF
	db $00, $00, $00, $00, $FF
	db $00, $00, $00, $00, $00
	db $00, $00, $FF, $00, $00
	db $FF, $00, $FF, $FF, $00

UseItem:
	JSL CheckDetonateBomb : BCS .normal

	LDA.l ItemOnB : BEQ .normal
	TAX
	LDA.b $6C : BNE .prevent_swing
	CPX.b #$11 : BNE .not_somaria
	LDA.w $02F5 : BNE .prevent_swing
	.not_somaria
	LDA.l ValidItemOnB, X : BNE .normal
	LDA.b $3A : ORA.b #$40 : STA.b $3A
	LDA.l $8DFA35, X : STA.w $0304
	CPX.b #$06 : BEQ .fire_rod
	CPX.b #$07 : BNE .not_rod
	.ice_rod
	LDA.b #$02 : STA.w $0307
	BRA .not_rod
	.fire_rod
	LDA.b #$01 : STA.w $0307
	.not_rod
	TXA : DEC : ASL : TAX
	LDA.l ItemHandlerLocs+1, X : STA.b $01
	LDA.l ItemHandlerLocs, X : STA.b $00
	JSL Link_UseItemLong
	.prevent_swing
	SEC
	RTL
	.normal
	LDA.b #$80 : TSB.b $3A
	LDA.b #$01 : TSB.b $50
	CLC
	RTL
