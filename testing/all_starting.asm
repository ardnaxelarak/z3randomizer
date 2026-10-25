org $B0B340

db $04 ; Bow + Silver Arrows
db $02 ; Red Boomerang
db $01 ; Hookshot
db $32 ; 50 Bombs
db $02 ; Powder
db $01 ; Fire Rod
db $01 ; Ice Rod
db $01 ; Bombos
db $01 ; Ether
db $01 ; Quake
db $01 ; Lamp
db $01 ; Hammer
db $03 ; Activated Flute
db $01 ; Bug Net
db $01 ; Book
db $01 ; Bottle Index
db $01 ; Somaria
db $01 ; Byrna
db $01 ; Cape
db $02 ; Mirror
db $02 ; Titan's Mitts
db $01 ; Boots
db $01 ; Flippers
db $01 ; Moon Pearl
skip 1
db $04 ; Gold Sword
db $03 ; Mirror Shield
db $02 ; Red Armor
db $05 ; Bottle 1 - Blue Potion
db $05 ; Bottle 2 - Blue Potion
db $05 ; Bottle 3 - Blue Potion
db $06 ; Bottle 4 - Fairy
dw $270F ; Rupee Count
dw $270F ; Rupee Display
dw $FFFC ; All Compasses
dw $FFFC ; All Big Keys
dw $FFFC ; All Maps
skip 1
db $00 ; 0 Heart Pieces
db $A0 ; 20 Hearts
db $A0 ; 20 Heart Containers
db $80 ; Full Magic
skip 1
db $32 ; 50 Bomb Capacity
db $46 ; 70 Arrow Capacity
skip 5
db $46 ; 70 Arrows
skip 1
db $6E ; All Ability Flags
skip 1
db $02 ; Quarter Magic

fillbyte $09
fill 14 ; 9 Small Keys for all dungeons

skip 2
dw $02F5 ; Both Boomerangs, Mushroom, Powder, Shovel, Active Flute
dw $00F0 ; Both Bows

org $B0B3C2
db $00 ; all flute spots
