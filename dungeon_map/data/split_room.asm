IncomingDoorMap:
; north
db $06, $07, $08
; west
db $09, $0A, $0B
; south
db $00, $01, $02
; east
db $03, $04, $05

macro d(label)
dw <label>-SplitRooms
endmacro

macro sq(byte)
db <byte>
endmacro

SplitRooms:
;  0/8       1/9       2/A       3/B       4/C       5/D       6/E       7/F
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.09) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.14) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.1a) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.2a) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.35) : %d(.36) : %d(.37)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.57)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.6a) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.75) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.7b) : %d(.7c) : %d(.7d) : %d(.no) : %d(.no)

;  0/8       1/9       2/A       3/B       4/C       5/D       6/E       7/F
%d(.no) : %d(.no) : %d(.82) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.87)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.8c) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.9d) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.a2) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.a9) : %d(.aa) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.b2) : %d(.no) : %d(.no) : %d(.no) : %d(.b6) : %d(.no)
%d(.no) : %d(.b9) : %d(.no) : %d(.no) : %d(.bc) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.c7)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.d1) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.d6) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.db) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no)

.no
db $00

.no_items
db $FF

.09
db $01
%sq($04)
%d(..areas) : %d(.no_items) : %d(..stairs)
%d(.no_items) : %d(.no_items) : %d(..enemies)
..areas
db $03, $80, $FF, $00, $80
db $FF
..stairs
db $01
db $FF
..enemies
db $02
db $FF

.14
db $02
%sq($00)
%d(..areas3) : %d(..doors3) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(.no_items)
%sq($00)
%d(..areas2) : %d(..doors2) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(.no_items)
..areas3
db $03, $C0, $FF, $00, $50
db $03, $00, $28, $30, $50
db $03, $30, $50, $D0, $FF
db $FF
..doors3
db $03, $06, $09
db $FF
..areas2
db $03, $B0, $D0, $D0, $FF
db $03, $30, $50, $00, $28
db $FF
..doors2
db $00, $08
db $FF

.1a ; PoD Big Chest (2) // Falling bridge and such (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(.no_items) : %d(.no_items)
..areas
db $03, $00, $2C, $70, $98
db $FF
..doors
db $04
db $FF
..chests
db $00
db $FF

.2a ; PoD Arena Right-Side Chest (2) // Arena (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(.no_items) : %d(.no_items)
..areas
db $03, $D8, $FF, $A8, $C8
db $FF
..doors
db $0B
db $FF
..chests
db $00
db $FF

.35 ; Swamp BK Chest (2) // Swamp second trench (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(..pots) : %d(.no_items)
..areas
db $03, $00, $70, $00, $80
db $FF
..doors
db $03
db $FF
..chests
db $00
db $FF
..pots
db $01, $02, $03, $04, $05
db $FF

.36 ; Swamp Big Lobby (1) // Tiny Top-Right Blocked Corner (2)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(..pots) : %d(.no_items)
..areas
db $03, $D4, $FF, $00, $48
db $FF
..doors
db $09
db $FF
..pots
db $00, $01
db $FF

.37 ; Swamp Second Chest (2) // Swamp first trench (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(.no_items) : %d(..enemies)
..areas
db $03, $90, $FF, $00, $80
db $FF
..doors
db $09
db $FF
..chests
db $00
db $FF
..enemies
db $02, $03
db $FF

.57 ; SW pot cage (2) // middle section (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(..pots) : %d(..enemies)
..areas
db $03, $80, $FF, $80, $FF
db $FF
..doors
db $08, $0B
db $FF
..chests
db $01
db $FF
..pots
db $02, $03, $04, $05
db $FF
..enemies
db $08, $09, $0A, $0B
db $FF

.6a ; pre-helmasaur-king (2) // PoD rupee basement (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(..enemies)
..areas
db $03, $B4, $C4, $00, $B4
db $03, $A8, $D0, $B0, $D0
db $FF
..doors
db $02
db $FF
..enemies
db $00, $01, $04, $05
db $FF

.74 ; desert north -- trapped area (2) // everything else (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(..enemies)
..areas
db $03, $4C, $C4, $CC, $FF
db $FF
..doors
db $07
db $FF
..enemies
db $06, $07
db $FF

.75 ; desert cannonball (2) // desert northeast + trap room (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..chests) : %d(.no_items) : %d(..enemies)
..areas
db $03, $80, $FF, $00, $FF
db $FF
..doors
db $08
db $FF
..chests
db $00
db $FF
..enemies
db $06, $07
db $FF

.7b ; GT post-compass (3) // island hardhat (2) // DMs room (1)
db $02
%sq($00)
%d(..areas3) : %d(..doors3) : %d(.no_items)
%d(.no_items) : %d(..pots3) : %d(..enemies3)
%sq($00)
%d(..areas2) : %d(..doors2) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(..enemies2)

..areas3
db $03, $00, $FF, $00, $80
db $FF
..doors3
db $09
db $FF
..pots3
db $00, $01, $02, $03, $04
db $FF
..enemies3
db $00, $01
db $FF

..areas2
db $03, $80, $FF, $80, $FF
db $FF
..doors2
db $0B
db $FF
..enemies2
db $06, $07
db $FF

.7c ; GT falling bridge // rando room
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(..pots) : %d(..enemies)
..areas
db $03, $00, $80, $00, $FF
db $FF
..doors
db $03, $05
db $FF
..pots
db $00, $01, $02, $03
db $FF
..enemies
db $01, $02, $03, $04
db $FF

.7d ; GT warp maze (section next to rando room)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(..pots) : %d(..enemies)
..areas
db $03, $00, $FF, $00, $80
db $03, $00, $80, $80, $FF
db $03, $CA, $DA, $9A, $A6
db $FF
..doors
db $05
db $FF
..pots
db $00, $01, $02, $03
db $FF
..enemies
db $00, $01, $02, $03, $09
db $FF

.82 ; HC Basement (1) + catwalk (2)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $03, $00, $20, $00, $50
db $FF
..doors
db $00, $03
db $FF

.87 ; Hera basement: cage (0) // torches (1)
db $01
%sq($08)
%d(..areas) : %d(.no_items) : %d(..stairs)
%d(..chests) : %d(..pots) : %d(..enemies)
..areas
db $03, $00, $FF, $00, $80
db $03, $80, $FF, $80, $FF
db $FF
..stairs
db $00
db $FF
..chests
db $00
db $FF
..pots
db $00, $01, $02, $03, $04, $05, $06, $07
db $FF
..enemies
db $00, $01, $02, $05, $06, $09, $0C
db $FF

.8c
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(..pots) : %d(..enemies)
..areas
db $03, $80, $FF, $80, $FF
db $FF
..doors
db $08
db $FF
..chests
db $03
db $FF
..pots
db $02, $03, $04, $05, $06
db $FF
..enemies
db $06, $07, $09
db $FF

.9d
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(..enemies)
..areas
db $03, $00, $FF, $80, $FF
db $FF
..doors
db $05
db $FF
..enemies
db $06, $07, $08
db $FF

.a2 ; Mire abyss -- EW bridge (2), stairs to basement + hookable chest (1)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $01, $00, $FF, $70, $84
db $FF
..doors
db $04, $0A
db $FF

.a9
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(..pots) : %d(.no_items)
..areas
db $03, $00, $40, $70, $FF
db $03, $00, $FF, $A0, $FF
db $03, $C0, $FF, $70, $FF
db $FF
..doors
db $04, $07, $0A
db $FF
..pots
db $04, $05, $06, $07
db $FF

.aa
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $02, $00, $80, $00, $FF
db $01, $34, $D4, $B8, $FF
db $FF
..doors
db $03, $06
db $FF

.b2
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(..pots) : %d(..enemies)
..areas
db $02, $00, $FF, $00, $80
db $03, $60, $A0, $00, $40
db $FF
..doors
db $01, $09
db $FF
..pots
db $00, $01, $02, $03, $04, $05, $06
db $FF
..enemies
db $00, $01, $02, $03, $04
db $FF

.b6
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(..pots) : %d(..enemies)
..areas
db $03, $80, $FF, $00, $FF
db $FF
..doors
db $08
db $FF
..pots
db $00
db $FF
..enemies
db $04
db $FF

.b9
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $01, $00, $20, $28, $60
db $01, $E0, $FF, $28, $60
db $01, $00, $FF, $58, $60
db $FF
..doors
db $03, $09
db $FF

.bc
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(..pots) : %d(.no_items)
..areas
db $03, $2C, $4C, $CA, $FF
db $FF
..doors
db $06
db $FF
..pots
db $0C, $0D
db $FF

.c7 ; TR Torch Maze (1) // Tiny Bottom-Left Blocked Corner (2)
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(..pots) : %d(.no_items)
..areas
db $03, $00, $1C, $A8, $FF
db $FF
..doors
db $05
db $FF
..pots
db $02, $03
db $FF

.d1
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(.no_items) : %d(..pots) : %d(..enemies)
..areas
db $03, $80, $FF, $00, $A8
db $FF
..doors
db $02
db $FF
..pots
db $02, $03, $04, $05
db $FF
..enemies
db $00, $01, $07
db $FF

.d6
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(.no_items) : %d(..enemies)
..areas
db $03, $00, $80, $00, $FF
db $FF
..doors
db $00
db $FF
..chests
db $00
db $FF
..enemies
db $00, $01, $02
db $FF

.db
db $01
%sq($00)
%d(..areas) : %d(..doors) : %d(.no_items)
%d(..chests) : %d(.no_items) : %d(.no_items)
..areas
db $02, $B0, $FF, $90, $C0
db $FF
..doors
db $0B
db $FF
..chests
db $01
db $FF
