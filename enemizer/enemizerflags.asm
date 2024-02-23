; ;Enemizer Flags
EnemizerFlags:
.randomize_bushes
db #$00 ;368100 ; Enable random enemy under bushes
.close_blind_door
db #$00 ;408101 : 200101 ; Enable blind's door closing for other bosses
.moldorm_eye_count
db #$01 ;408102 : 200102 ; Moldorm eye count, default to 2 eyes (1)
EnemizerFlag_Randomize_Sprites:
db #$00 ;408103 : 200103 ; Randomize Sprites.
.agahnim_fun_balls
db #$00 ;408104 : 200104 ; make Agahnim balls deflect back
.enable_mimic_override
db #$00 ;408105 : 200105 ; toggle mimic code between new and old
; free byte ;408106 : 200106
db #$00
.center_boss_drops
db #$00 ;368107
.killable_theives_id  ; must be set to C4 to make thieves killable...
db #$B8 ;368108
.enemies_live_upon_falling
db #$00 ; 368109  ; when set to 1 enemies don't die when falling into a hole

db #$00 ;40810A : 20010A
db #$00 ;40810B : 20010B
db #$00 ;40810C : 20010C
db #$00 ;40810D : 20010D
db #$00 ;40810E : 20010E
db #$00 ;40810F : 20010F
db #$00 ;408110 : 200110
db #$00 ;408111 : 200111
db #$00 ;408112 : 200112
db #$00 ;408113 : 200113
db #$00 ;408114 : 200114
db #$00 ;408115 : 200115
db #$00 ;408116 : 200116
db #$00 ;408117 : 200117
db #$00 ;408118 : 200118
db #$00 ;408119 : 200119
db #$00 ;40811A : 20011A
db #$00 ;40811B : 20011B
db #$00 ;40811C : 20011C
db #$00 ;40811D : 20011D
db #$00 ;40811E : 20011E
db #$00 ;40811F : 20011F
