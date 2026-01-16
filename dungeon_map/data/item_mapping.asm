!TIER_UNKNOWN = $01
!TIER_JUNK = $02
!TIER_LOW_KEY = $03
!TIER_HEALTH = $05
!TIER_MINOR = $06
!TIER_MAP = $07
!TIER_COMPASS = $08
!TIER_SM_KEY = $09
!TIER_BIG_KEY = $0A
!TIER_MAJOR = $0B
!TIER_PENDANT = $0C
!TIER_CRYSTAL = $0D
!TIER_TFP = $0E
!TIER_TFORCE = $0F

db !TIER_MAJOR   ; 00 - Fighter Sword and Shield
db !TIER_MAJOR   ; 01 - Master Sword
db !TIER_MAJOR   ; 02 - Tempered Sword
db !TIER_MAJOR   ; 03 - Butter Sword
db !TIER_JUNK    ; 04 - Fighter Shield
db !TIER_MINOR   ; 05 - Fire Shield
db !TIER_MINOR   ; 06 - Mirror Shield
db !TIER_MAJOR   ; 07 - Fire Rod
db !TIER_MAJOR   ; 08 - Ice Rod
db !TIER_MAJOR   ; 09 - Hammer
db !TIER_MAJOR   ; 0A - Hookshot
db !TIER_MAJOR   ; 0B - Bow
db !TIER_MINOR   ; 0C - Boomerang
db !TIER_MINOR   ; 0D - Powder
db !TIER_JUNK    ; 0E - Bottle Refill (bee)
db !TIER_MAJOR   ; 0F - Bombos
db !TIER_MAJOR   ; 10 - Ether
db !TIER_MAJOR   ; 11 - Quake
db !TIER_MAJOR   ; 12 - Lamp
db !TIER_MINOR   ; 13 - Shovel
db !TIER_MAJOR   ; 14 - Flute
db !TIER_MAJOR   ; 15 - Somaria
db !TIER_MINOR   ; 16 - Bottle
db !TIER_HEALTH  ; 17 - Heartpiece
db !TIER_MINOR   ; 18 - Byrna
db !TIER_MINOR   ; 19 - Cape
db !TIER_MAJOR   ; 1A - Mirror
db !TIER_MAJOR   ; 1B - Glove
db !TIER_MAJOR   ; 1C - Mitts
db !TIER_MAJOR   ; 1D - Book
db !TIER_MAJOR   ; 1E - Flippers
db !TIER_MAJOR   ; 1F - Pearl
db !TIER_CRYSTAL ; 20 - Crystal
db !TIER_MINOR   ; 21 - Net
db !TIER_MINOR   ; 22 - Blue Mail
db !TIER_MINOR   ; 23 - Red Mail
db !TIER_LOW_KEY ; 24 - Small Key
db !TIER_COMPASS ; 25 - Compass
db !TIER_HEALTH  ; 26 - Heart Container from 4/4
db !TIER_JUNK    ; 27 - Bomb
db !TIER_JUNK    ; 28 - 3 bombs
db !TIER_MINOR   ; 29 - Mushroom
db !TIER_MINOR   ; 2A - Red boomerang
db !TIER_MINOR   ; 2B - Full bottle (red)
db !TIER_MINOR   ; 2C - Full bottle (green)
db !TIER_MINOR   ; 2D - Full bottle (blue)
db !TIER_HEALTH  ; 2E - Potion refill (red)
db !TIER_HEALTH  ; 2F - Potion refill (green)
db !TIER_HEALTH  ; 30 - Potion refill (blue)
db !TIER_JUNK    ; 31 - 10 bombs
db !TIER_BIG_KEY ; 32 - Big key
db !TIER_MAP     ; 33 - Map
db !TIER_JUNK    ; 34 - 1 rupee
db !TIER_JUNK    ; 35 - 5 rupees
db !TIER_JUNK    ; 36 - 20 rupees
db !TIER_PENDANT ; 37 - Green pendant
db !TIER_PENDANT ; 38 - Blue pendant
db !TIER_PENDANT ; 39 - Red pendant
db !TIER_MAJOR   ; 3A - Tossed bow
db !TIER_MAJOR   ; 3B - Silvers
db !TIER_MINOR   ; 3C - Full bottle (bee)
db !TIER_MINOR   ; 3D - Full bottle (fairy)
db !TIER_HEALTH  ; 3E - Boss heart
db !TIER_HEALTH  ; 3F - Sanc heart
db !TIER_JUNK    ; 40 - 100 rupees
db !TIER_JUNK    ; 41 - 50 rupees
db !TIER_JUNK    ; 42 - Heart
db !TIER_JUNK    ; 43 - Arrow
db !TIER_JUNK    ; 44 - 10 arrows
db !TIER_JUNK    ; 45 - Small magic
db !TIER_JUNK    ; 46 - 300 rupees
db !TIER_JUNK    ; 47 - 20 rupees green
db !TIER_MINOR   ; 48 - Full bottle (good bee)
db !TIER_MAJOR   ; 49 - Tossed fighter sword
db !TIER_MAJOR   ; 4A - Active Flute
db !TIER_MAJOR   ; 4B - Boots

db !TIER_MINOR   ; 4C - Bomb capacity (50)
db !TIER_MINOR   ; 4D - Arrow capacity (70)
db !TIER_MINOR   ; 4E - 1/2 magic
db !TIER_MINOR   ; 4F - 1/4 magic
db !TIER_MAJOR   ; 50 - Safe master sword
db !TIER_MINOR   ; 51 - Bomb capacity (+5)
db !TIER_MINOR   ; 52 - Bomb capacity (+10)
db !TIER_MINOR   ; 53 - Arrow capacity (+5)
db !TIER_MINOR   ; 54 - Arrow capacity (+10)
db !TIER_JUNK    ; 55 - Programmable item 1
db !TIER_JUNK    ; 56 - Programmable item 2
db !TIER_JUNK    ; 57 - Programmable item 3
db !TIER_MAJOR   ; 58 - Upgrade-only silver arrows
db !TIER_JUNK    ; 59 - Rupoor
db !TIER_JUNK    ; 5A - Nothing
db !TIER_JUNK    ; 5B - Red clock
db !TIER_JUNK    ; 5C - Blue clock
db !TIER_JUNK    ; 5D - Green clock
db !TIER_MAJOR   ; 5E - Progressive sword
db !TIER_MINOR   ; 5F - Progressive shield
db !TIER_MINOR   ; 60 - Progressive armor
db !TIER_MAJOR   ; 61 - Progressive glove
db !TIER_JUNK    ; 62 - RNG pool item (single)
db !TIER_JUNK    ; 63 - RNG pool item (multi)
db !TIER_MAJOR   ; 64 - Progressive bow
db !TIER_MAJOR   ; 65 - Progressive bow
db !TIER_JUNK    ; 66 -
db !TIER_JUNK    ; 67 -
db !TIER_JUNK    ; 68 -
db !TIER_JUNK    ; 69 -
db !TIER_TFORCE  ; 6A - Triforce
db !TIER_TFP     ; 6B - Power star
db !TIER_TFP     ; 6C - Triforce Piece
db !TIER_JUNK    ; 6D - Server request item
db !TIER_JUNK    ; 6E - Server request item (dungeon drop)
db !TIER_JUNK    ; 6F -

db !TIER_MAP     ; 70 - Map of Light World
db !TIER_MAP     ; 71 - Map of Dark World
db !TIER_MAP     ; 72 - Map of Ganon's Tower
db !TIER_MAP     ; 73 - Map of Turtle Rock
db !TIER_MAP     ; 74 - Map of Thieves' Town
db !TIER_MAP     ; 75 - Map of Tower of Hera
db !TIER_MAP     ; 76 - Map of Ice Palace
db !TIER_MAP     ; 77 - Map of Skull Woods
db !TIER_MAP     ; 78 - Map of Misery Mire
db !TIER_MAP     ; 79 - Map of Dark Palace
db !TIER_MAP     ; 7A - Map of Swamp Palace
db !TIER_MAP     ; 7B - Map of Agahnim's Tower
db !TIER_MAP     ; 7C - Map of Desert Palace
db !TIER_MAP     ; 7D - Map of Eastern Palace
db !TIER_MAP     ; 7E - Map of Hyrule Castle
db !TIER_MAP     ; 7F - Map of Sewers

db !TIER_COMPASS ; 80 - Compass of Light World
db !TIER_COMPASS ; 81 - Compass of Dark World
db !TIER_COMPASS ; 82 - Compass of Ganon's Tower
db !TIER_COMPASS ; 83 - Compass of Turtle Rock
db !TIER_COMPASS ; 84 - Compass of Thieves' Town
db !TIER_COMPASS ; 85 - Compass of Tower of Hera
db !TIER_COMPASS ; 86 - Compass of Ice Palace
db !TIER_COMPASS ; 87 - Compass of Skull Woods
db !TIER_COMPASS ; 88 - Compass of Misery Mire
db !TIER_COMPASS ; 89 - Compass of Dark Palace
db !TIER_COMPASS ; 8A - Compass of Swamp Palace
db !TIER_COMPASS ; 8B - Compass of Agahnim's Tower
db !TIER_COMPASS ; 8C - Compass of Desert Palace
db !TIER_COMPASS ; 8D - Compass of Eastern Palace
db !TIER_COMPASS ; 8E - Compass of Hyrule Castle
db !TIER_COMPASS ; 8F - Compass of Sewers

db !TIER_BIG_KEY ; 90 - Skull key
db !TIER_BIG_KEY ; 91 - Reserved
db !TIER_BIG_KEY ; 92 - Big key of Ganon's Tower
db !TIER_BIG_KEY ; 93 - Big key of Turtle Rock
db !TIER_BIG_KEY ; 94 - Big key of Thieves' Town
db !TIER_BIG_KEY ; 95 - Big key of Tower of Hera
db !TIER_BIG_KEY ; 96 - Big key of Ice Palace
db !TIER_BIG_KEY ; 97 - Big key of Skull Woods
db !TIER_BIG_KEY ; 98 - Big key of Misery Mire
db !TIER_BIG_KEY ; 99 - Big key of Dark Palace
db !TIER_BIG_KEY ; 9A - Big key of Swamp Palace
db !TIER_BIG_KEY ; 9B - Big key of Agahnim's Tower
db !TIER_BIG_KEY ; 9C - Big key of Desert Palace
db !TIER_BIG_KEY ; 9D - Big key of Eastern Palace
db !TIER_BIG_KEY ; 9E - Big key of Hyrule Castle
db !TIER_BIG_KEY ; 9F - Big key of Sewers

db !TIER_SM_KEY  ; A0 - Small key of Sewers
db !TIER_SM_KEY  ; A1 - Small key of Hyrule Castle
db !TIER_SM_KEY  ; A2 - Small key of Eastern Palace
db !TIER_SM_KEY  ; A3 - Small key of Desert Palace
db !TIER_SM_KEY  ; A4 - Small key of Agahnim's Tower
db !TIER_SM_KEY  ; A5 - Small key of Swamp Palace
db !TIER_SM_KEY  ; A6 - Small key of Dark Palace
db !TIER_SM_KEY  ; A7 - Small key of Misery Mire
db !TIER_SM_KEY  ; A8 - Small key of Skull Woods
db !TIER_SM_KEY  ; A9 - Small key of Ice Palace
db !TIER_SM_KEY  ; AA - Small key of Tower of Hera
db !TIER_SM_KEY  ; AB - Small key of Thieves' Town
db !TIER_SM_KEY  ; AC - Small key of Turtle Rock
db !TIER_SM_KEY  ; AD - Small key of Ganon's Tower
db !TIER_JUNK    ; AE - Reserved
db !TIER_LOW_KEY ; AF - Generic small key
db !TIER_CRYSTAL ; B0 - Crystal 6
db !TIER_CRYSTAL ; B1 - Crystal 1
db !TIER_CRYSTAL ; B2 - Crystal 5
db !TIER_CRYSTAL ; B3 - Crystal 7
db !TIER_CRYSTAL ; B4 - Crystal 2
db !TIER_CRYSTAL ; B5 - Crystal 4
db !TIER_CRYSTAL ; B6 - Crystal 3
db !TIER_JUNK    ; B7 - Reserved
db !TIER_JUNK    ; B8 -
db !TIER_JUNK    ; B9 -
db !TIER_JUNK    ; BA -
db !TIER_JUNK    ; BB -
db !TIER_JUNK    ; BC -
db !TIER_JUNK    ; BD -
db !TIER_JUNK    ; BE -
db !TIER_JUNK    ; BF -
db !TIER_JUNK    ; C0 -
db !TIER_JUNK    ; C1 -
db !TIER_JUNK    ; C2 -
db !TIER_JUNK    ; C3 -
db !TIER_JUNK    ; C4 -
db !TIER_JUNK    ; C5 -
db !TIER_JUNK    ; C6 -
db !TIER_JUNK    ; C7 -
db !TIER_JUNK    ; C8 -
db !TIER_JUNK    ; C9 -
db !TIER_JUNK    ; CA -
db !TIER_JUNK    ; CB -
db !TIER_JUNK    ; CC -
db !TIER_JUNK    ; CD -
db !TIER_JUNK    ; CE -
db !TIER_JUNK    ; CF -
db !TIER_JUNK    ; D0 - Bee trap
db !TIER_JUNK    ; D1 - Apples
db !TIER_JUNK    ; D2 - Fairy
db !TIER_JUNK    ; D3 - Chicken
db !TIER_JUNK    ; D4 - Big Magic
db !TIER_JUNK    ; D5 - 5 Arrows
db !TIER_JUNK    ; D6 - Good Bee
db !TIER_JUNK    ; D7 -
db !TIER_JUNK    ; D8 -
db !TIER_JUNK    ; D9 -
db !TIER_JUNK    ; DA -
db !TIER_JUNK    ; DB -
db !TIER_JUNK    ; DC -
db !TIER_JUNK    ; DD -
db !TIER_JUNK    ; DE -
db !TIER_JUNK    ; DF -
db !TIER_JUNK    ; E0 -
db !TIER_JUNK    ; E1 -
db !TIER_JUNK    ; E2 -
db !TIER_JUNK    ; E3 -
db !TIER_JUNK    ; E4 -
db !TIER_JUNK    ; E5 -
db !TIER_JUNK    ; E6 -
db !TIER_JUNK    ; E7 -
db !TIER_JUNK    ; E8 -
db !TIER_JUNK    ; E9 -
db !TIER_JUNK    ; EA -
db !TIER_JUNK    ; EB -
db !TIER_JUNK    ; EC -
db !TIER_JUNK    ; ED -
db !TIER_JUNK    ; EE -
db !TIER_JUNK    ; EF -
db !TIER_JUNK    ; F0 -
db !TIER_JUNK    ; F1 -
db !TIER_JUNK    ; F2 -
db !TIER_JUNK    ; F3 -
db !TIER_JUNK    ; F4 -
db !TIER_JUNK    ; F5 -
db !TIER_JUNK    ; F6 -
db !TIER_JUNK    ; F7 -
db !TIER_JUNK    ; F8 -
db !TIER_JUNK    ; F9 -
db !TIER_JUNK    ; FA -
db !TIER_JUNK    ; FB -
db !TIER_JUNK    ; FC -
db !TIER_JUNK    ; FD -
db !TIER_JUNK    ; FE - Server request (async)
db !TIER_JUNK    ; FF -
