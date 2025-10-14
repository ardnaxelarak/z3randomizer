;================================================================================
; New bush mob randomization
;--------------------------------------------------------------------------------
org $868279
BRA +
MaybeSkipTerrainDebris:
JSL MaybeSkipTerrainDebris_long : RTS ; sticking this here, no other free space in bank 06
NOP #3
+
JSL sprite_bush_spawn
NOP ; we keep the branch 
;--------------------------------------------------------------------------------
