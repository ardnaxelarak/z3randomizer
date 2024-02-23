;--------------------------------------------------------------------------------
PreOverworld_LoadProperties_ChooseMusic:
    ; A: scratch space (value never used)
    ; Y: set to overworld animated tileset
    ; X: set to music track/command id
    JSL FixFrogSmith ; Just a convenient spot to install this hook

    LDY.b #$58 ; death mountain animated tileset.

    LDA.b OverworldIndex : ORA.b #$40 ; check both light and dark world DM at the same time
    CMP.b #$43 : BEQ +
    CMP.b #$45 : BEQ +
    CMP.b #$47 : BEQ +
        LDY.b #$5A ; Main overworld animated tileset

    + JSL Overworld_DetermineMusic

    .lastCheck
    LDA.w MusicControlQueue : CMP.b #$F2 : BNE +
    CPX.w LastAPUCommand : BNE +
        ; If the last played command (MusicControlQueue) was half volume (#$F2)
        ; and the actual song playing (LastAPUCommand) is same as the one for this area (X)
        ; then play the full volume command (#F3) instead of restarting the song
        LDX.b #$F3
    +

    JML PreOverworld_LoadProperties_SetSong
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
Overworld_FinishMirrorWarp:
    REP #$20

    LDA.w #$2641 : STA.w DMAP7

    LDX.b #$3E

    LDA.w #$FF00

.clear_hdma_table

    STA.w IrisPtr+$0000, X : STA.w IrisPtr+$0040, X
    STA.w IrisPtr+$0080, X : STA.w IrisPtr+$00C0, X
    STA.w IrisPtr+$0100, X : STA.w IrisPtr+$0140, X
    STA.w IrisPtr+$0180, X

    DEX #2 : BPL .clear_hdma_table
    LDA.w #$0000 : STA.l FadeTimer : STA.l FadeDirection

    SEP #$20

    JSL ReloadPreviouslyLoadedSheets

    LDA.b #$80 : STA.b HDMAENQ

    JSL Overworld_DetermineAmbientSFX
    JSL Overworld_DetermineMusic

.done
    STX.w MusicControlRequest

    LDA.b GameSubMode : STA.w GameSubModeCache

    STZ.b GameSubMode
    STZ.b SubSubModule
    STZ.w SubModuleInterface
    STZ.w SkipOAM

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
    LDA.l ProgressIndicator : CMP.b #$02 : !BGE +
        LDX.b #$03 ; If phase < 2, play the rain music
        BRA .done
    
    + LDA.b OverworldIndex : CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BEQ .darkMountain

    LDX.b #$02  ; hyrule field theme

    LDA.l CurrentWorld : BEQ +
        LDX.b #$09  ; default dark world theme

    ; Check if we're entering the village
    + LDA.b OverworldIndex : CMP.b #$18 : BNE +
        ; Check what phase we're in
        ; LDA ProgressIndicator : CMP.b #$03 : !BGE .bunny
            LDX.b #$07 ; Default village theme (phase <3)
            BRA .bunny
    
    ; Check if we're entering the lost woods
    + CMP.b #$00 : BNE +
        LDA.l OverworldEventDataWRAM+$80 : AND.b #$40 : BNE .bunny
            LDX.b #$05 ; lost woods theme
            BRA .bunny
    
    + CMP.b #$40 : BNE .bunny
        LDX.b #$0F    ; dark woods theme
        BRA .bunny

.darkMountain
    LDX.b #$0D  ; dark mountain theme

.bunny
    ; if not inverted and light world, or inverted and dark world, skip moon pearl check
    LDA.l CurrentWorld : CLC : ROL #$03 : CMP.l InvertedMode : BEQ .done
        LDA.l MoonPearlEquipment : BNE .done
            LDX.b #$04    ; bunny theme

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;$012D to be set to any ambient SFX for the area
Overworld_DetermineAmbientSFX:
    LDA.l ProgressIndicator : CMP.b #$02 : !BGE +
        BRA .done ; rain state sfx handled elsewhere
    
    + LDA.b OverworldIndex : CMP.b #$43 : BEQ .darkMountain
    CMP.b #$45 : BEQ .darkMountain
    CMP.b #$47 : BEQ .darkMountain

    CMP.b #$70 : BEQ .mire

    LDA.b #$05 : BRA .setSfx ; silence

.mire
    LDA OverworldEventDataWRAM+$70 : AND.b #$20 : BNE .done
        LDA.b #$01 : BRA .setSfx ; Misery Mire rain SFX

.darkMountain
    LDA.b #$09 : BRA .setSfx ; set storm ambient SFX

.setSfx
    CMP.w LastSFX1 : BEQ +
        STA.w SFX1
    + STZ.w SFX1

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
;0 = Is Kakariko Overworld
;1 = Not Kakariko Overworld
PsychoSolder_MusicCheck:
    LDA.b OverworldIndex : CMP.b #$18 : BNE .done ; thing we overwrote - check if overworld location is Kakariko
        LDA.b IndoorsFlag  ; Also check that we are outdoors
    .done
RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Additional dark world checks to determine whether or not to fade out music
; on mosaic transitions
; 
; On entry, A = $8A (overworld area being loaded)
Overworld_MosaicDarkWorldChecks:
    CMP.b #$40 : BEQ .checkCrystals
    CMP.b #$42 : BEQ .checkCrystals
    CMP.b #$50 : BEQ .checkCrystals
    CMP.b #$51 : BNE .doFade

.checkCrystals
    LDA.l CrystalsField : CMP.b #$7F : BEQ .done

.doFade
    LDA.b #$F1 : STA.w MusicControlRequest  ; thing we wrote over, fade out music

.done
    RTL
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; This is the where the music can change due to an UW transition
;
; On entry, A=16bit XY=8bit, A & X safe to mod, Y unknown
Underworld_DoorDown_Entry:
    LDX #$FF ; some junk value to be used later to determine if the below lines will change the track
    LDA.l ProgressIndicator : AND.w #$00FF : CMP.w #2 : !BLT .vanilla
    LDA.l DRMode : BNE .done

.vanilla ; thing we wrote over
    LDA.b RoomIndex : CMP.w #$0012 : BNE +
        LDX.b #$14 ; value for Sanc music
        BRA .done
    + LDA.b PreviousRoom : CMP.w #$0012 : BNE .done
        LDX.b #$10 ; value for Hyrule Castle music
.done
    LDA.b RoomIndex : RTL
;--------------------------------------------------------------------------------
; This is for changing to/from ToH dungeon/boss music
;
; A=16bit XY=8bit
CheckHeraBossDefeated:
LDA RoomDataWRAM[$07].high : AND.w #$00FF : BEQ +
    SEC : RTL
+ CLC : RTL

FallingMusicFadeOut:
    CMP.w #$0017 ; what we wrote over
    BNE .return
        LDA.w LastAPUCommand : AND.w #$00FF : CMP.w #$0015 ; if boss music is playing, then fade out
.return
    RTL
;--------------------------------------------------------------------------------
