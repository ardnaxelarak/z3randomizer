!ITEMCOUNT = $F0

; ============== Replace all picked up item icons with bombos =================
org AddReceivedItemExpanded_y_offsets
fillbyte -4
fill !ITEMCOUNT

org AddReceivedItemExpanded_x_offsets
fillbyte 0
fill !ITEMCOUNT

org AddReceivedItemExpanded_item_graphics_indices
fillbyte $1B
fill !ITEMCOUNT

org AddReceivedItemExpanded_wide_item_flag
fillbyte $02
fill !ITEMCOUNT

org AddReceivedItemExpanded_properties
fillbyte 4
fill !ITEMCOUNT

org GetSpriteID_gfxSlots
fillbyte $1B
fill !ITEMCOUNT

org GetSpritePalette_gfxPalettes
fillbyte $08
fill !ITEMCOUNT

org IsNarrowSprite_smallSprites
padbyte $FF
pad PrepDynamicTile
; =============================================================================

; ===================== Remove attempt to animate rupees ======================
org $08C672
LDA.b #$0F : NOP
; =============================================================================


; ===================== Replace all menu icons with bombos ====================
macro bombos_icon()
	dw $287D, $287E, $E87E, $E87D ; Bombos
endmacro

macro empty_icon()
	dw $20F5, $20F5, $20F5, $20F5 ; No bombos
endmacro

org $0DF649
%empty_icon() ; No bow
%bombos_icon() ; Empty bow
%bombos_icon() ; Bow and arrows
%bombos_icon() ; Empty silvers bow
%bombos_icon() ; Silver bow and arrows

%empty_icon() ; No boomerang
%bombos_icon() ; Blue boomerang
%bombos_icon() ; Red boomerang

%empty_icon() ; No hookshot
%bombos_icon() ; Hookshot

%empty_icon() ; No bombs
%bombos_icon() ; Bombs

%empty_icon() ; No powder
%bombos_icon() ; Mushroom
%bombos_icon() ; Powder

%empty_icon() ; No fire rod
%bombos_icon() ; Fire rod

%empty_icon() ; No ice rod
%bombos_icon() ; Ice rod

%empty_icon() ; No bombos
%bombos_icon() ; Bombos

%empty_icon() ; No ether
%bombos_icon() ; Ether

%empty_icon() ; No quake
%bombos_icon() ; Quake

%empty_icon() ; No lamp
%bombos_icon() ; Lamp

%empty_icon() ; No hammer
%bombos_icon() ; Hammer

%empty_icon() ; No flute
%bombos_icon() ; Shovel
%bombos_icon() ; Flute (inactive)
%bombos_icon() ; Flute (active)

%empty_icon() ; No net
%bombos_icon() ; Net

%empty_icon() ; No book
%bombos_icon() ; Book of Mudora

%empty_icon() ; No bottle
%bombos_icon() ; Mushroom
%bombos_icon() ; Empty bottle
%bombos_icon() ; Red potion
%bombos_icon() ; Green potion
%bombos_icon() ; Blue potion
%bombos_icon() ; Fairy
%bombos_icon() ; Bee
%bombos_icon() ; Good bee

%empty_icon() ; No somaria
%bombos_icon() ; Cane of Somaria

%empty_icon() ; No byrna
%bombos_icon() ; Cane of Byrna

%empty_icon() ; No cape
%bombos_icon() ; Cape

%empty_icon() ; No mirror
%bombos_icon() ; Map
%bombos_icon() ; Mirror
%bombos_icon() ; Triforce (displays as arrows and bombs)

%empty_icon() ; No glove
%bombos_icon() ; Power glove
%bombos_icon() ; Titan's mitt

%empty_icon() ; No boots
%bombos_icon() ; Pegasus boots

%empty_icon() ; No flippers
%bombos_icon() ; Flippers

%empty_icon() ; No pearl
%bombos_icon() ; Moon pearl

%empty_icon() ; Nothing

%empty_icon() ; No sword
%bombos_icon() ; Fighter sword
%bombos_icon() ; Master sword
%bombos_icon() ; Tempered sword
%bombos_icon() ; Gold sword

%empty_icon() ; No shield
%bombos_icon() ; Fighter shield
%bombos_icon() ; Fire shield
%bombos_icon() ; Mirror shield

%bombos_icon() ; Green mail
%bombos_icon() ; Blue mail
%bombos_icon() ; Red mail

%empty_icon() ; No compass
%bombos_icon() ; Compass

%empty_icon() ; No big key
%bombos_icon() ; Big key
%bombos_icon() ; Big key and chest

%empty_icon() ; No map
%bombos_icon() ; Map

%empty_icon() ; No red pendant
%bombos_icon() ; Red pendant

%empty_icon() ; No blue pendant
%bombos_icon() ; Blue pendant

%empty_icon() ; No green pendant
%bombos_icon() ; Green pendant

%empty_icon() ; No white glove?
%bombos_icon() ; White glove?

%empty_icon() ; 0 heart pieces
dw $287D, $20F5, $20F5, $20F5 ; 1 heart piece
dw $287D, $20F5, $E87E, $20F5 ; 2 heart pieces
dw $287D, $287E, $E87E, $20F5 ; 3 heart pieces
; =============================================================================

; ===================== Replace menu pendants with bombos =====================
org DrawPendantCrystalDiagram_row0
dw $28FB, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $28F9, $68FB
dw $28FC, $24F5, $24F5, $24F5, $307D, $307E, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $F07E, $F07D, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $307D, $307E, $24F5, $24F5, $307D, $307E, $24F5, $68FC
dw $28FC, $24F5, $F07E, $F07D, $24F5, $24F5, $F07E, $F07D, $24F5, $68FC
dw $28FC, $24F5, $24F5, $24F5, $307D, $307E, $24F5, $24F5, $24F5, $68FC
dw $28FC, $24F5, $307D, $307E, $307D, $307E, $307D, $307E, $24F5, $68FC
dw $28FC, $24F5, $F07E, $F07D, $F07E, $F07D, $F07E, $F07D, $24F5, $68FC
dw $A8FB, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $A8F9, $E8FB
; =============================================================================

; ===================== Replace menu pendants with bombos =====================
org $308022
db $00
; =============================================================================
