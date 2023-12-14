; ;================================================================================
; ; insert kholdstare & trinexx shell gfx file
; ;--------------------------------------------------------------------------------
; ; pc file address = 0x123000
; org $24B000
; GFX_Kholdstare_Shell:
; incbin shell.gfx
; warnpc $24C001      ; should have written 0x1000 bytes and apparently we need to go 1 past that or it'll yell at us

; org $24C000
; GFX_Trinexx_Shell:
; incbin rocks.gfx
; warnpc $24C801

; GFX_Trinexx_Shell2:
; incbin rocks2.gfx
; warnpc $24C8C1
; ;--------------------------------------------------------------------------------

    ; ; *$4C290-$4C2D4 LOCAL
    ; Dungeon_LoadSprites:

; *$4C114-$4C174 LONG
org $9C114
Dungeon_ResetSprites: ; Bank09.asm(822)

; *$4C44E-$4C498 LONG
org $9C44E
Sprite_ResetAll: ; Bank09.asm(1344)

;--------------------------------------------------------------------------------

;================================================================================
; On Room Transition -> Move Sprite depending on the room loaded
;--------------------------------------------------------------------------------
org $028979 ;  JSL Dungeon_ResetSprites ; REPLACE THAT (Sprite initialization) original jsl : $09C114
JSL boss_move
org $028C16 ;  JSL Dungeon_ResetSprites ; REPLACE THAT (Sprite initialization) original jsl : $09C114
JSL boss_move
org $029338 ;  JSL Dungeon_ResetSprites ; REPLACE THAT (Sprite initialization) original jsl : $09C114
JSL boss_move
org $028256 ;  JSL Dungeon_ResetSprites ; REPLACE THAT (Sprite initialization) original jsl : $09C114
JSL boss_move
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------

;================================================================================
; Draw kholdstare shell
;--------------------------------------------------------------------------------
org $0DD97F ; jump point
Kholdstare_Draw:

org $1E9518 ; sprite_kholdstare.asm (154) : JSL Kholdstare_Draw
JSL new_kholdstare_code ; Write new gfx in the vram
;--------------------------------------------------------------------------------

;================================================================================
; Draw trinexx shell
;--------------------------------------------------------------------------------
org $1DAD67 ; sprite_trinexx.asm (62) : LDA.b #$03 : STA $0DC0, X
JSL new_trinexx_code : NOP
;--------------------------------------------------------------------------------
