;--------------------------------------------------------------------------------
PreOverworld_LoadProperties_ChooseMusic:
    ; A: scratch space (value never used)
    ; Y: set to overworld animated tileset
    ; X: set to music track/command id
    JSL.l FixFrogSmith ; Just a convenient spot to install this hook

    LDY.b #$58 ; death mountain animated tileset.

    LDA $8A : ORA #$40 ; check both light and dark world DM at the same time
    CMP.b #$43 : BEQ +
    CMP.b #$45 : BEQ +
    CMP.b #$47 : BEQ +

    LDY.b #$5A ; Main overworld animated tileset

    ; if we are in the light world go ahead and set chosen selection
    ;LDA $7EF3CA : BEQ .checkInverted+4
    + JSL Overworld_DetermineMusic

    .lastCheck
    LDA $0132 : CMP.b #$F2 : BNE +
    CPX $0130 : BNE +
        ; If the last played command ($0132) was half volume (#$F2)
        ; and the actual song playing ($0130) is same as the one for this area (X)
        ; then play the full volume command (#F3) instead of restarting the song
        LDX.b #$F3
    +

    JML.l PreOverworld_LoadProperties_SetSong
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
Overworld_FinishMirrorWarp:
    REP #$20

    LDA.w #$2641 : STA $4370

    LDX.b #$3E

    LDA.w #$FF00

.clear_hdma_table

    STA $1B00, X : STA $1B40, X
    STA $1B80, X : STA $1BC0, X
    STA $1C00, X : STA $1C40, X
    STA $1C80, X

    DEX #2 : BPL .clear_hdma_table

    LDA.w #$0000 : STA $7EC007 : STA $7EC009

    SEP #$20

    JSL $00D7C8               ; $57C8 IN ROM

    LDA.b #$80 : STA $9B

    JSL Overworld_DetermineAmbientSFX
    JSL Overworld_DetermineMusic

.done
    STX $012C

    LDA $11 : STA $010C

    STZ $11
    STZ $B0
    STZ $0200
    STZ $0710

    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
BirdTravel_LoadTargetAreaMusic:
    JSL Overworld_DetermineAmbientSFX
    JSL Overworld_DetermineMusic
    STZ $04C8 ; Clear peg puzzle count
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;X to be set to music track to load
Overworld_DetermineMusic:
    LDA $7EF3C5 : CMP.b #$02 : !BGE +
        LDX.b #$03 ; If phase < 2, play the rain music
        BRA .done
    
    + LDA $8A : CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BEQ .darkMountain

    LDX.b #$02  ; hyrule field theme

    LDA $7EF3CA : BEQ +
        LDX.b #$09  ; default dark world theme

    ; Check if we're entering the village
    + LDA $8A : CMP.b #$18 : BNE +
        ; Check what phase we're in
        ; LDA $7EF3C5 : CMP.b #$03 : !BGE .bunny
            LDX.b #$07 ; Default village theme (phase <3)
            BRA .bunny
    
    ; Check if we're entering the lost woods
    + CMP.b #$00 : BNE +
        LDA $7EF300 : AND.b #$40 : BNE .bunny
            LDX.b #$05 ; lost woods theme
            BRA .bunny
    
    + LDA $8A : CMP.b #$40 : BNE +
        LDX #$0F    ; dark woods theme
        BRA .bunny

.darkMountain
    LDX.b #$0D  ; dark mountain theme

.bunny
    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    LDA $7EF3CA : CLC : ROL #$03 : CMP InvertedMode : BEQ .done
        LDA $7EF357 : BNE .done
            LDX #$04    ; bunny theme

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;$012D to be set to any ambient SFX for the area
Overworld_DetermineAmbientSFX:
    LDA $7EF3C5 : CMP.b #$02 : !BGE +
        BRA .done ; rain state sfx handled elsewhere
    
    + LDA $8A : CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BEQ .darkMountain

    CMP.b #$70 : BEQ .mire

    LDA.b #$05 : BRA .setSfx ; silence

.mire
    LDA $7EF2F0 : AND.b #$20 : BNE .done
        LDA.b #$01 : BRA .setSfx ; Misery Mire rain SFX

.darkMountain
    LDA.b #$09 : BRA .setSfx ; set storm ambient SFX

.setSfx
    CMP $0131 : BEQ +
        STA $012D
    + STZ $012D

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Is Kakariko Overworld
;1 = Not Kakariko Overworld
PsychoSolder_MusicCheck:
    LDA $040A : CMP.b #$18 : BNE .done ; thing we overwrote - check if overworld location is Kakariko
        LDA $1B  ; Also check that we are outdoors
    .done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Additional dark world checks to determine whether or not to fade out music
; on mosaic transitions
; 
; On entry, A = $8A (overworld area being loaded)
Overworld_MosaicDarkWorldChecks:
    CMP.b #$40 : beq .checkCrystals
    CMP.b #$42 : beq .checkCrystals
    CMP.b #$50 : beq .checkCrystals
    CMP.b #$51 : bne .doFade

.checkCrystals
    LDA $7EF37A : CMP.b #$7F : BEQ .done

.doFade
    LDA.b #$F1 : STA $012C  ; thing we wrote over, fade out music

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; This is the where the music can change due to an UW transition
;
; On entry, A=16bit XY=8bit, A & X safe to mod, Y unknown
Underworld_DoorDown_Entry:
    LDX #$FF ; some junk value to be used later to determine if the below lines will change the track
    LDA.l $7EF3C5 : AND.w #$00FF : CMP.w #2 : !BLT .vanilla
    LDA.l DRMode : BNE .done

.vanilla ; thing we wrote over
    LDA $A0 : CMP.w #$0012 : BNE +
        LDX.b #$14 ; value for Sanc music
        BRA .done
    + LDA $A2 : CMP.w #$0012 : BNE .done
        LDX.b #$10 ; value for Hyrule Castle music
.done
    LDA $A0 : RTL
;--------------------------------------------------------------------------------
; This is for changing to/from ToH dungeon/boss music
;
; A=16bit XY=8bit
CheckHeraBossDefeated:
LDA $7EF00F : AND.w #$00FF : BEQ +
    SEC : RTL
+ CLC : RTL
