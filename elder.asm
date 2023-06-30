NewElderCode:
{
LDA $8A : AND.b #$3F : CMP #$1B : BEQ .newCodeContinue
;Restore Jump we can keep the RTL so JML
JML $05F0CD
.newCodeContinue
PHB : PHK : PLB
LDA.b #$07 : STA $0F50, X ;Palette 
JSR Elder_Draw
JSL Sprite_PlayerCantPassThrough
JSR Elder_Code

PLB
RTL
}

    Elder_Draw:
    {

        LDA.b #$02 : STA $06 : STZ $07 ;Number of Tiles
        
        LDA $0DC0, X : ASL #04
        
        ADC.b #.animation_states : STA $08
        LDA.b #.animation_states>>8 : ADC.b #$00 : STA $09
        
        JSL Sprite_DrawMultiple_player_deferred
        JSL Sprite_DrawShadowLong

        RTS

        .animation_states
        ;Frame0
        dw 0, -9 : db $C6, $00, $00, $02
        dw 0,  0 : db $C8, $00, $00, $02
        ;Frame1
        dw 0, -8 : db $C6, $00, $00, $02
        dw 0,  0 : db $CA, $40, $00, $02
    }

    Elder_Code:
    {
        REP #$20
        LDA.l GoalItemRequirement : BEQ .despawn
        LDA.l InvincibleGanon : AND.w #$00FF : CMP.w #$0005 : BEQ .despawn
        LDA.l TurnInGoalItems : AND.w #$00FF : BNE +
            .despawn
            SEP #$20
            STZ $0DD0, X ; despawn self
            RTS
        +
        SEP #$20
        LDA.b $11
        BNE .done
        LDA.b #$96
        LDY.b #$01
        
        JSL Sprite_ShowSolicitedMessageIfPlayerFacing_PreserveMessage : BCC .dont_show
            REP #$20
            LDA.l GoalCounter
            CMP.l GoalItemRequirement : !BLT +
                SEP #$20
                JSL ActivateTriforceCutscene
            +
        .dont_show
        
        .done
        SEP #$20
        LDA.b $1A : LSR #5 : AND.b #$01 : STA.w $0DC0, X
        RTS
    }

;--------------------------------------------------------------------------------
; Triforce (Pedestal) Cutscene
;--------------------------------------------------------------------------------
ActivateTriforceCutscene:
    ; despawn other sprites
    LDY.b #$0F
    - LDA.w $0E20,Y : CMP.b #$16 : BNE +
        CPY.b #$00 : BEQ .next
        ; move Murahdahla to slot 0 for draw priority reasons
        LDA.w $0E20,Y : STA.w $0E20
        LDA.w $0D00,Y : STA.w $0D00
        LDA.w $0D10,Y : STA.w $0D10
        LDA.w $0D20,Y : STA.w $0D20
        LDA.w $0D30,Y : STA.w $0D30
        LDA.w $0D40,Y : STA.w $0D40
        LDA.w $0F50,Y : STA.w $0F50
        LDA.w $0E40,Y : STA.w $0E40
        LDA.w $0E60,Y : STA.w $0E60
        LDA.w $0DD0,Y : STA.w $0DD0
        LDA.b #$02 : STA.w $0F20
    + LDA.b #$00 : STA.w $0DD0,Y
    .next
    DEY : BPL -
    
    LDA.b #$62 ; MasterSword Sprite
    JSL Sprite_SpawnDynamically

    ; set up coords
    LDA.b $22 : STA.w $0D10,Y
    LDA.b $23 : STA.w $0D30,Y
    LDA.b $20 : CLC : ADC.b #$08 : STA.w $0D00,Y
    LDA.b $21 : ADC.b #$00 : STA.w $0D20,Y

    LDA.b #$01 : STA.w $0D90,Y ; our indicator this is a special cutscene sprite
    INC : STA.b $2F ; makes Link face downward

    ; reset modules
    LDA.b $1B : BEQ +
        LDA.b #$07
        BRA ++
    + LDA.b #$09
    ++ STA.b $10
    STZ.b $11 : STZ.b $B0
RTL

pushpc
    org $058928
    MasterSword_InPedestal_DoCutscene:
    org $0589B1
    MasterSword_ConditionalHandleReceipt_DoReceipt:

    org $0588DF
    JSL MasterSword_CheckIfPulled : PLX : NOP #2
    db $90 ; BCC instead of BEQ
    org $05890E
    JSL MasterSword_ConditionalActivateCutscene
    org $05895F
    JSL MasterSword_ConditionalGrabPose : NOP
    org $058994
    JSL MasterSword_ConditionalGrabPose : NOP
    org $058D1C
    JML MasterSword_SpawnPendantProp_ChangePalette
    MasterSword_SpawnPendantProp_ChangePalette_return:
    org $0589A3
    JSL MasterSword_ConditionalHandleReceipt : NOP #2
pullpc

MasterSword_CheckIfPulled:
    CPX.b #$80 : BEQ +
        - CLC : RTL ; not on pedestal screen, continue with cutscene
    + LDA.l $7EF280,X : AND.b #$40 ; what we wrote over
    BEQ - : SEC : RTL

MasterSword_ConditionalActivateCutscene:
    LDA.w $0D90,X : BNE .specialCutscene
        JML Sprite_CheckDamageToPlayerSameLayerLong ; what we wrote over
    .specialCutscene
    LDA.b #$02 : STA.w $02DA ; Link's 2-hands-up pose
    STA.b $EE ; draw Link on top
    LDA.b #$6A : JSL RequestSlottedTile ; draw Triforce piece in VRAM
    PLA : PLA : PLA : JML MasterSword_InPedestal_DoCutscene ; do cutscene

MasterSword_ConditionalGrabPose:
    PHA
        LDA.w $0D90,X : BNE .specialCutscene
    PLA
    STA.w $0377 : LDA.b #$01 ; what we wrote over
    RTL
    .specialCutscene
    PLA
    LDA.b #$01
RTL

MasterSword_SpawnPendantProp_ChangePalette:
    STA.w $0D40,Y : PLX ; what we wrote over
    LDA.w $0D90,X : BNE .specialCutscene
        BRA .done
    .specialCutscene
    LDA.b #$08 : STA.w $0F50,Y ; change palette
    LDA.b #$02 : STA.w $0F20,Y ; change layer
.done
JML MasterSword_SpawnPendantProp_ChangePalette_return

MasterSword_ConditionalHandleReceipt:
    LDA.w $0D90,X : BNE .specialCutscene
        LDX.b $8A : LDA.l $7EF280,X ; what we wrote over
        RTL
    .specialCutscene
        PLA : PLA : PEA.w MasterSword_ConditionalHandleReceipt_DoReceipt-1
        LDA.b 4,S : TAX
        LDY.b #$6A
    RTL

pushpc
    org $058AB6
    MasterSword_SpawnLightWell:
    org $058AD0
    MasterSword_SpawnLightFountain:
    org $058B62
    MasterSword_SpawnLightBeam:

    org $058941
    JSL MasterSword_ConditionalSpawnLightWell : NOP #2
    MasterSword_SpawnLightWell_return:
    org $058952
    JSL MasterSword_ConditionalSpawnLightFountain : NOP #2
    MasterSword_SpawnLightFountain_return:
    org $058B64
    JSL MasterSword_ConditionalSpawnLightBeam : NOP #2
pullpc

MasterSword_ConditionalSpawnLightWell:
    INC.w $0D80,X ; part of what we wrote over
    LDA.w $0D90,X : BNE .specialCutscene
        PLA : PLA : PLA : PEA.w MasterSword_SpawnLightWell_return-1
        JML MasterSword_SpawnLightWell ; part of what we wrote over
    .specialCutscene
    RTL

MasterSword_ConditionalSpawnLightFountain:
    INC.w $0D80,X ; part of what we wrote over
    LDA.w $0D90,X : BNE .specialCutscene
        PLA : PLA : PLA : PEA.w MasterSword_SpawnLightFountain_return-1
        JML MasterSword_SpawnLightFountain ; part of what we wrote over
    .specialCutscene
    RTL

MasterSword_ConditionalSpawnLightBeam:
    LDA.w $0D90,X : BNE .specialCutscene
        LDA.b #$62 : JSL Sprite_SpawnDynamically ; what we wrote over
        RTL
    .specialCutscene
    LDY.b #$FF
    RTL
