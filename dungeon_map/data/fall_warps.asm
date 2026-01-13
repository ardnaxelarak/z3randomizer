FallTable:
db $1007, $1017 ; Moldorm Arena
db $1017, $1027 ; Below Moldorm drop to Big Chest
db $101E, $103E ; IP first drop
db $1027, $1031 ; ToH Big Chest drop
db $1031, $1077 ; Second Floor ToH
db $1039, $1029 ; Mothula drop
db $103A, $100A ; Pod front drop
db $103D, $1096 ; GT Torches drop
db $104D, $10A6 ; Moldorm 2 drop
db $1054, $1034 ; Left side Swamp
db $105E, $107E ; IP drop to tall icy room
db $107E, $109E ; Freezors drop (to big chest)
db $208C, $101C ; Ice Armos drop
db $1097, $10D1 ; Mire Cutscene
db $109E, $10BE ; IP Big Chest tile (push blocks)
db $10CE, $10DE ; Kholdstare drop
; db $65, $AC ; TT Attic
; db $77, $A7 ; ToH drop to fairy room (Herapot)
; db $A9, $89 ; EP drop to fairy room
; db $BE, $4F ; IP drop to fairy room
db $FF

WarpTable:
dw $2009, $104B ; PoD Basement (start)
dw $100A, $1009 ; PoD Stalfos Basement
dw $100B, $206A ; PoD Turtle Room to Boss
dw $104B, $2009 ; PoD Basement (mimics)
dw $207B, $209D ; GT post-compass island hardhat
dw $207D, $109B ; GT warp maze
dw $109D, $307B ; GT compass room
dw $109B, $207D ; GT warp maze
dw $10B1, $20B2 ; South of Fishbone warp
dw $10D1, $10B1 ; Mire Big Key Chest warp
; db $89, $A9 ; EP Fairy Room
; db $A7, $17 ; ToH Fairy Room
; db $4F, $BE ; IP Fairy Room
dw $FFFF
