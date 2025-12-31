; $CA has room_id
DrawDungeonMapRoom:
	PHB : PHK : PLB ; need to keep this in same bank as data, or else specify bank

	; base no-info palette
	LDA.w #$0C00
	STA.b $0C

	PHX
	LDX.w DungeonID
	LDA.l MapField
	AND.l DungeonMask, X
	BEQ +
		LDA.w #$1400
		STA.b $0C
		LDA.b $0E
		ORA.w #$8000
		STA.b $0E
	+

	LDA.l CompassField
	AND.l DungeonMask, X
	BEQ +
		LDA.b $0E
		ORA.w #$4000
		STA.b $0E
	+
	PLX

	LDA.b $0E
	BNE +
		; we haven't seen the supertile at all and don't have map or compass
		LDA.w #$0F7B
		STA.l $7F0042, X
		ORA.w #$4000
		STA.l $7F0040, X
		ORA.w #$8000
		STA.l $7F0000, X
		AND.w #$BFFF
		STA.l $7F0002, X
		JMP .done
	+

	AND.w #$000F
	BEQ +
		LDA.w #$1400
		STA.b $0C
	+

	LDA.b $CA
	AND.w #$00FF
	ASL A : ASL A
	TAY

	macro DrawQuadrant(quadrant, writeOffset)
		?DrawQuadrant:
		LDA.w SupertileRoomShapes+<quadrant>, Y
		AND.w #$00FF
		CMP.w #$00FF : BEQ ?.empty
		CLC : ADC.w #$0340
		ORA.w #(3-<quadrant>)<<14
		PHA
		LDA.b $0E
		AND.w #1<<(3-<quadrant>)
		BNE ?.visited 
			PLA
			ORA.b $0C
			BRA ?.write
		?.visited
			PLA
			ORA.w #$0800
		?.write
		STA.l $7F0000+<writeOffset>, X
		?.empty
	endmacro

	%DrawQuadrant(0, $00)
	%DrawQuadrant(1, $02)
	%DrawQuadrant(2, $40)
	%DrawQuadrant(3, $42)

.done
	PLB
	RTL
