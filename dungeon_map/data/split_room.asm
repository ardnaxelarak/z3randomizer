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

SplitRooms:
;  0/8       1/9       2/A       3/B       4/C       5/D       6/E       7/F
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.14) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.75) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.7d) : %d(.no) : %d(.no)

;  0/8       1/9       2/A       3/B       4/C       5/D       6/E       7/F
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.a9) : %d(.aa) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.b2) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.b9) : %d(.no) : %d(.no) : %d(.bc) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no) : %d(.d1) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.d6) : %d(.no)
%d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no) : %d(.no)

%d(.no)

.no
db $00

.no_items
db $FF

.14
db $02
%d(..areas3) : %d(..doors3) : %d(.no_items) : %d(.no_items) : %d(.no_items)
%d(..areas2) : %d(..doors2) : %d(.no_items) : %d(.no_items) : %d(.no_items)
..areas3
db $03, $C0, $FF, $00, $50
db $03, $00, $28, $30, $50
db $03, $30, $50, $D0, $FF
db $FF
..doors3
db $03, $06, $09
db $FF
..areas2
db $FF
..doors2
db $05, $0B
db $FF

.75
db $02
%d(..areas) : %d(..doors) : %d(..chests) : %d(.no_items) : %d(..enemies)
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

.7d ; GT warp maze (section next to rando room)
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..pots) : %d(..enemies)
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

.a9
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..pots) : %d(.no_items)
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
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $02, $00, $80, $00, $FF
db $FF
..doors
db $03, $06
db $FF

.b2
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..pots) : %d(..enemies)
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

.b9
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(.no_items)
..areas
db $01, $00, $20, $28, $60
db $01, $00, $20, $28, $60
db $01, $E0, $FF, $58, $60
db $FF
..doors
db $03, $09
db $FF

.bc
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..pots) : %d(.no_items)
..areas
db $03, $2C, $4C, $CA, $FF
db $FF
..doors
db $06
db $FF
..pots
db $0C, $0D
db $FF

.d1
db $01
%d(..areas) : %d(..doors) : %d(.no_items) : %d(..pots) : %d(..enemies)
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
%d(..areas) : %d(..doors) : %d(.no_items) : %d(.no_items) : %d(..enemies)
..areas
db $03, $00, $80, $00, $FF
db $FF
..doors
db $00
db $FF
..enemies
db $00, $01, $02
db $FF
