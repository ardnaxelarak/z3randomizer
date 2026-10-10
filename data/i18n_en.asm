encoder dialog = "textbytecharmap.txt"

encoder dialog

macro NoText()
	db $FB, $FE, $6E, $00, $FE, $6B, $04
endmacro

; set_cursor
db $FB, $FC, $00
db $F9, "   "
db $F8, "  "
db $99, $FE, $68

; set_cursor2
db $FB, $FC, $00
db $F8, "   "
db $F9, "  "
db $99, $FE, $68

; game_over_menu
db $FB, $FC, $00
db "Save-Continue"
db $F8, "Save-Quit"
db $F9, "Continue"

; var_test
db $FB
db "0= "
db $FE, $6C, $00
db ", 1= "
db $FE, $6C, $01
db $F8, "2= "
db $FE, $6C, $02
db ", 3= "
db $FE, $6C, $03

; follower_no_enter
db $FB
db "Can't you take me"
db $F8
db "some place nice?"

; choice_1_3
db $FB, $FC, $00
db $F7, $99
db $F8, " "
db $F9, " "
db $FE, $71

; choice_2_3
db $FB, $FC, $00
db $F7, " "
db $F8, $99
db $F9, " "
db $FE, $71

; choice_3_3
db $FB, $FC, $00
db $F7, " "
db $F8, " "
db $F9, $99
db $FE, $71

; choice_1_2
db $FB, $FC, $00
db $F7, $99
db $F8, " "
db $FE, $72

; choice_2_2
db $FB, $FC, $00
db $F7, " "
db $F8, $99
db $FE, $72

; uncle_leaving_text
db $FB
db "I'm just going"
db $F8
db "out for a pack"
db $F9
db "of smokes."

; uncle_dying_sewer
%NoText()

; tutorial_guard_1
db $FB
db "Only adults should"
db $F8
db "travel at night."

; tutorial_guard_2
db $FB
db "You can press X to"
db $F8
db "see the map."

; tutorial_guard_3
db $FB
db "Press A to lift"
db $F8
db "nearby things."

; tutorial_guard_4
db $FB
db "When you has a"
db $F8
db "sword, press B"
db $F9
db "to slash it."

; tutorial_guard_5
db $FB, $0C, $24, $83, $9A, $63
db " "
db $75, $28, $71, $7C, $5F, $6E, $36, $14

; tutorial_guard_6
db $FB
db "Are you really"
db $F8
db "still reading"
db $F9
db "these?"

; tutorial_guard_7
db $FB
db "Geez! There really"
db $F8
db "are a lot of things"

; priest_sanctuary_before_leave
%NoText()

; sanctuary_enter
%NoText()

; zelda_sanctuary_story
%NoText()

; priest_sanctuary_before_pendants
%NoText()

; priest_sanctuary_after_pendants_before_master_sword
%NoText()

; prient_sanctuary_dying
db $FB
db "THEY TOOK HER"
db $F8
db "TO THE CASTLE!"
db $F9
db "TAKE YOUR"
db $FA, $F6
db "SWORD AND SAVE"
db $F6
db "HER!"

; zelda_save_sewers
%NoText()

; priest_info
%NoText()

; zelda_sanctuary_before_leave
%NoText()

; telepathic_intro
%NoText()

; telepathic_reminder
db $FB, $FE, $6B, $02, $FC, $06
db "I'm in the"
db $F8
db "castle basement."

; zelda_go_to_throne
%NoText()

; zelda_push_throne
%NoText()

; zelda_switch_room_pull
%NoText()

; zelda_save_lets_go
%NoText()

; zelda_save_repeat
%NoText()

; zelda_before_pendants
%NoText()

; zelda_after_pendants_before_master_sword
%NoText()

; telepathic_zelda_right_after_master_sword
db $FB, $FE, $6B, $02, $FC, $06
db "Hi "
db $FE, $6A
db ","
db $F8
db "have you been"
db $F9
db "thinking about"
db $FA, $F6
db "me?"
db $F6
db "ARRRRRGGHH"
db $9F, $F6, $9F
db " "
db $9F
db " "
db $9F

; zelda_sewers
%NoText()

; zelda switch_room
%NoText()

; kakariko_sahasrahla_wife
db $FB
db "Heya, "
db $FE, $6A
db "!"
db $F8
db "Long time no"
db $F9
db "see."
db $FA, $F6
db "You want a"
db $F6
db "Master Sword?"
db $F6, $FA, $F6
db "Well good luck"
db $F6
db "with that."

; kakariko_sahasrahla_wife_sword_story
db $FB
db "IT OCCURS TO"
db $F8
db "ME THAT I LIKE"
db $F9
db "TOAST AND JAM,"
db $FA, $F6
db "BUT CHEESE AND"
db $F6
db "CRACKERS IS"
db $F6
db "BETTER."
db $FA, $F6
db "YOU LIKE?"
db $F6
db "  "
db $99
db " CHEESE"
db $F6
db "    JAM"
db $FE, $68

; kakariko_sahasrahla_wife_closing
db $FB
db "ANYWHO, I HAVE"
db $F8
db "THINGS TO DO."
db $F9
db "YOU SEE THOSE"
db $FA, $F6
db "2 OVENS?"
db $F6, $F6
db "YEAH, 2!"
db $FA, $F6
db "WHO HAS 2"
db $F6
db "OVENS"
db $F6
db "NOWADAYS?!"

; kakariko_sahasrahla_wife_after_master_sword
db $FB
db "COOL SWORD!"
db $F8, $F9, $FA, $F6, $9F, $F6, $F6, $FA, $F6, $9F, $F6, $F6, $FA, $F6
db "PLEASE SAVE US"

; kakariko_alert_guards
db $FB
db "Guards! Help!"
db $F8
db "The creeper"
db $F9, $FE, $6A
db " is here!"

; 0x30 - sahasrahla_quest_have_pendants
db $FB, $FE, $6D, $01
db "COOL BEANS,"
db $F8
db "BUT I THINK"
db $F9
db "YOU SHOULD"
db $FA, $F6
db "MOSEY ON OVER"
db $F6
db "TO THE LOST"
db $F6
db "WOODS."

; sahasrahla_quest_have_master_sword
%NoText()

; sahasrahla_quest_information
db $FB, $FE, $6D, $01
db "SAHASRAHLA, I"
db $F8
db "AM. YOU WOULD"
db $F9
db "DO WELL TO"
db $FA, $F6
db "FIND THE 3"
db $F6
db "PENDANTS FROM"
db $F6
db "THE 3 DUNGEONS"
db $FA, $F6
db "IN THE LIGHT"
db $F6
db "WORLD."
db $F6
db "UNDERSTAND?"
db $FA, $F6
db "  "
db $99
db " YES"
db $F6
db "    NO"
db $FE, $68

; sahasrahla_bring_courage
%NoText()

; sahasrahla_have_ice_rod
db $FB, $FE, $6D, $01
db "LIKE, I SIT"
db $F8
db "HERE, AND TELL"
db $F9
db "YOU WHAT TO"
db $FA, $F6
db "DO?"
db $F6, $F6, $FA, $F6
db "ALRIGHT, GO"
db $F6
db "AND FIND ALL"
db $F6
db "THE MAIDENS,"
db $FA, $F6
db "THERE ARE,"
db $F6
db "LIKE, MAYBE 7"
db $F6
db "OF THEM. I"
db $FA, $F6
db "DUNNO ANYMORE."
db $F6
db "I'M OLD."

; telepathic_sahasrahla_beat_agahnim
%NoText()

; telepathic_sahasrahla_beat_agahnim_no_pearl
%NoText()

; sahasrahla_have_boots_no_icerod
%NoText()

; sahasrahla_have_courage
%NoText()

; sahasrahla_found
%NoText()

; sign_rain_north_of_links_house
db $FB, $FD, $13
db " Dying uncle"
db $F8
db "  this way"
db $9F

; sign_north_of_links_house
db $FB, $9B, $9C
db " Randomizer"
db $F8
db "The telepathic"
db $F9
db "tiles can have"
db $FA, $F6
db "hints!"

; sign_path_to_death_mountain
db $FB
db "Cave to lost,"
db $F8
db "old man."
db $F9
db "Good luck."

; sign_lost_woods
db $FB, $F8
db $FD, $13, " Lost Woods"

; sign_zora
db $FB
db "DANGER!"
db $F8
db "Deep water!"
db $F9
db "Zoras!"

; sign_outside_magic_shop
db $FB
db "Welcome to the"
db $F8
db "Magic Shoppe"

; 0x40 - sign_death_mountain_cave_back
db $FB
db "Cave away from"
db $F8
db "Sky Cabbages"

; sign_east_of_links_house
db $FB
db $FD, $14, " Lake Hylia"
db $F8, $F9
db " Also, a Shop"

; sign_south_of_lumberjacks
db $FB
db $FD, $16, " Kakariko"
db $F8
db "  Village"

; sign_east_of_desert
db $FB
db $FD, $16, " Desert"
db $F8, $F9
db "     It's hot."

; sign_east_of_sanctuary
db $FB
db $FD, $13, $FD, $15, " Potions!"
db $F8, $F9
db "WISH WATERFALL"

; sign_east_of_castle
db $FB
db $FD, $15, " EAST PALACE"
db $F8, $F9
db $FD, $16, " CASTLE"

; sign_north_of_lake
db $FB, $F8
db " Lake  Hylia"

; sign_desert_thief
db $FB
db "Don't talk to"
db $F8
db "me or touch my"
db $F9
db "sign!"

; sign_lumberjacks_house
db $FB
db "Lumberjacks, Inc."
db $F8
db "You see 'em,"
db $F9
db "We saw 'em."

; sign_north_kakariko
db $FB
db $FD, $14, " Kakariko"
db $F8
db "  Village"

; witch_bring_mushroom
db $FB
db "Double, double"
db $F8
db "toil and"
db $F9
db "trouble!"
db $FA, $F6
db "Bring me a"
db $F6
db "mushroom!"

; witch_brewing_the_item
%NoText()

; witch_assistant_no_bottle
db $FB
db "You got to"
db $F8
db "give me the"
db $F9
db "mushroom, Numpty!"

; witch_assistant_no_empty_bottle
%NoText()

; witch_assistant_informational
%NoText()

; witch_assistant_no_bottle_buying
db $FB
db "IF ONLY YOU"
db $F8
db "HAD SOMETHING"
db $F9
db "TO PUT THAT"
db $FA, $F6
db "IN, LIKE A"
db $F6
db "BOTTLE"
db $9F

; 0x50 - potion_shop_no_empty_bottles
db $FB
db "WHOA, BUCKO!"
db $F8
db "NO EMPTY"
db $F9
db "BOTTLES."

; item_get_lamp
%NoText()

; item_get_boomerang
%NoText()

; item_get_bow
%NoText()

; item_get_shovel
%NoText()

; item_get_magic_cape
%NoText()

; item_get_powder
%NoText()

; item_get_flippers
%NoText()

; item_get_power_gloves
%NoText()

; item_get_pendant_courage
%NoText()

; item_get_pendant_power
%NoText()

; item_get_pendant_wisdom
%NoText()

; item_get_mushroom
%NoText()

; item_get_book
%NoText()

; item_get_moonpearl
%NoText()

; item_get_compass
%NoText()

; 0x60 - item_get_map
%NoText()

; item_get_ice_rod
%NoText()

; item_get_fire_rod
%NoText()

; item_get_ether
%NoText()

; item_get_bombos
%NoText()

; item_get_quake
%NoText()

; item_get_hammer
%NoText()

; item_get_ocarina
%NoText()

; item_get_cane_of_somaria
%NoText()

; item_get_hookshot
%NoText()

; item_get_bombs
%NoText()

; item_get_bottle
%NoText()

; item_get_big_key
%NoText()

; item_get_titans_mitts
%NoText()

; item_get_magic_mirror
%NoText()

; item_get_fake_mastersword
%NoText()

; 0x70 - post_item_get_fake_mastersword
%NoText()

; item_get_red_potion
%NoText()

; item_get_green_potion
%NoText()

; item_get_blue_potion
%NoText()

; item_get_bug_net
%NoText()

; item_get_blue_mail
%NoText()

; item_get_red_mail
%NoText()

; item_get_tempered_sword
%NoText()

; item_get_mirror_shield
%NoText()

; item_get_cane_of_byrna
%NoText()

; missing_big_key
db $FB
db "Something is missing"
db $F9
db "The Big Key?"

; missing_magic
%NoText()

; item_get_pegasus_boots
%NoText()

; talking_tree_info_start
db $FB
db "Whoa! I can"
db $F8
db "talk again!"

; talking_tree_info_1
db $FB
db "YANK ON THE"
db $F8
db "PITCHFORK IN"
db $F9
db "THE CENTER OF"
db $FA, $F6
db "TOWN, YA HEARD"
db $F6
db "IT HERE."

; talking_tree_info_2
db $FB
db "GANON IS SUCH"
db $F8
db "A DINGUS, NO"
db $F9
db "ONE LIKES HIM,"
db $FA, $F6
db "YA HEARD IT"
db $F6
db "HERE."

; 0x80 - talking_tree_info_3
db $FB
db "THERE IS A"
db $F8
db "PORTAL NEAR"
db $F9
db "THE LOST"
db $FA, $F6
db "WOODS, YA"
db $F6
db "HEARD IT HERE."

; talking_tree_info_4
db $FB
db "USE BOMBS TO"
db $F8
db "QUICKLY KILL"
db $F9
db "THE HINOX, YA"
db $FA, $F6
db "HEARD IT HERE."

; talking_tree_info_other
db $FB
db "I can breathe!"

; item_get_pendant_power_alt
%NoText()

; item_get_pendant_wisdom_alt
%NoText()

; game_shooting_choice
db $FB
db "20 rupees."
db $F8
db "5 arrows."
db $F9
db "Win rupees!"
db $FA, $F6
db "Want to play?"
db $F6
db "  "
db $99
db " Yes"
db $F6
db "    No"
db $FE, $68

; game_shooting_yes
db $FB
db "Let's do this!"

; game_shooting_no
db $FB
db "WHERE ARE YOU"
db $F8
db "GOING?"
db $F9
db "STRAIGHT UP!"

; game_shooting_continue
db $FB
db "Keep playing?"
db $F8
db "  "
db $99
db " Yes"
db $F9
db "    No"
db $FE, $68

; pond_of_wishing
db $FB
db "-Wishing Pond-"
db $F8, $F9
db " ON VACATION"

; pond_item_select
db $FB
db "Pick something"
db $F8
db "to throw in."
db $FE, $69

; pond_item_test
%NoText()

; pond_will_upgrade
%NoText()

; pond_item_test_no
db $FB
db "You sure?"
db $F8
db "  "
db $99
db " Oh yeah"
db $F9
db "    Um"
db $FE, $68

; pond_item_test_no_no
db $FB
db "Well, I don't"
db $F8
db "want it, so"
db $F9
db "take it back."

; pond_item_boomerang
%NoText()

; 0x90 - pond_item_shield
db $FB
db "I GRANT YOU"
db $F8
db "THE ABILITY TO"
db $F9
db "BLOCK"
db $FA, $F6
db "FIREBALLS."
db $F6
db "DON'T LOSE"
db $F6
db "THIS TO A"
db $FA, $F6
db "PIKIT!"

; pond_item_silvers
db $FB
db "SO, WOULDN'T"
db $F8
db "IT BE NICE TO"
db $F9
db "KILL GANON?"
db $FA, $F6
db "THESE SHOULD"
db $F6
db "HELP IN THE"
db $F6
db "FINAL PHASE."

; pond_item_bottle_filled
db $FB
db "Bottle filled!"
db $F8
db "Money saved!"

; pond_item_sword
db $FB
db "THANK YOU FOR"
db $F8
db "THE SWORD,"
db $F9
db "HERE IS A"
db $FA, $F6
db "STICK OF"
db $F6
db "BUTTER."

; pond_of_wishing_happiness
db $FB
db "HAPPINESS UP!"
db $F8
db "YOU ARE NOW"
db $F9, $FE, $6C, $01, $FE, $6C, $00
db " HAPPY!"

; pond_of_wishing_choice
db $FB
db "YOUR WISH?"
db $F8
db "  "
db $99
db "MORE BOMBS"
db $F9
db "   MORE ARROWS"
db $FE, $68

; pond_of_wishing_bombs
db $FB
db "WOO-HOO!"
db $F8
db "YOU CAN NOW"
db $F9
db "CARRY "
db $FE, $6C, $01, $FE, $6C, $00
db " BOMBS"

; pond_of_wishing_arrows
db $FB
db "WOO-HOO!"
db $F8
db "YOU CAN NOW"
db $F9
db "HOLD "
db $FE, $6C, $01, $FE, $6C, $00
db " ARROWS"

; pond_of_wishing_full_upgrades
db $FB
db "YOU HAVE ALL I"
db $F8
db "CAN GIVE YOU,"
db $F9
db "HERE ARE YOUR"
db $FA, $F6
db "RUPEES BACK."

; mountain_old_man_first
%NoText()

; mountain_old_man_deadend
%NoText()

; mountain_old_man_turn_right
%NoText()

; mountain_old_man_lost_and_alone
%NoText()

; mountain_old_man_drop_off
%NoText()

; mountain_old_man_in_his_cave_pre_agahnim
%NoText()

; mountain_old_man_in_his_cave
%NoText()

; 0xA0 - mountain_old_man_in_his_cave_post_agahnim
%NoText()

; tavern_old_man_awake
db $FB
db "LIFE? LOVE?"
db $F8
db "HAPPINESS? THE"
db $F9
db "QUESTION YOU"
db $FA, $F6
db "SHOULD REALLY"
db $F6
db "ASK IS  WAS"
db $F6
db "THIS GENERATED"
db $FA, $F6
db "BY STOOPS ALU"
db $F6
db "OR STOOPS JET?"

; tavern_old_man_unactivated_flute
db $FB
db "YOU SHOULD"
db $F8
db "PLAY THAT"
db $F9
db "FLUTE FOR THE"
db $FA, $F6
db "WEATHERVANE,"
db $F6
db "CAUSE REASONS."

; tavern_old_man_know_tree_unactivated_flute
db $FB
db "YOU SHOULD"
db $F8
db "PLAY THAT"
db $F9
db "FLUTE FOR THE"
db $FA, $F6
db "WEATHERVANE,"
db $F6
db "CAUSE REASONS."

; tavern_old_man_have_flute
db $FB
db "LIFE? LOVE?"
db $F8
db "HAPPINESS? THE"
db $F9
db "QUESTION YOU"
db $FA, $F6
db "SHOULD REALLY"
db $F6
db "ASK IS  WAS"
db $F6
db "THIS GENERATED"
db $FA, $F6
db "BY STOOPS ALU"
db $F6
db "OR STOOPS JET?"

; chicken_hut_lady
db $FB
db "THIS IS"
db $F8
db "CHRISTOS' HUT."
db $F9, $FA, $F6
db "HE'S OUT,"
db $F6
db "SEARCHING FOR"
db $F6
db "A BOW."

; running_man
db $FB
db "HI, DO YOU"
db $F8
db "KNOW VEETORP?"
db $F9, $FA, $F6
db "YOU REALLY"
db $F6
db "SHOULD. AND"
db $F6
db "ALL THE OTHER"
db $FA, $F6
db "GREAT GUYS WHO"
db $F6
db "MADE THIS"
db $F6
db "POSSIBLE."
db $FA, $F6
db "GO THANK THEM."
db $F6, $F6, $FA, $F6
db "IF YOU CAN"
db $F6
db "CATCH THEM"
db $9F

; game_race_sign
db $FB
db "Why are you"
db $F8
db "reading this"
db $F9
db "sign? Run!!!"

; sign_bumper_cave
db $FB
db "You need cape,"
db $F8
db "but not hookshot"

; sign_catfish
db $FB
db "Toss rocks"
db $F8
db "Toss items"
db $F9
db "Toss cookies"

; sign_north_village_of_outcasts
db $FB
db $FD, $13, " Skull Woods"
db $F8, $F9
db $FD, $14, " Steve's Town"

; sign_south_of_bumper_cave
db $FB, $F8
db $FD, $15, " KatDevsGames' Cave"

; sign_east_of_pyramid
db $FB, $F8
db $FD, $15, " Dark Palace"

; sign_east_of_bomb_shop
db $FB, $F8
db $FD, $16, " Bomb Shoppe"

; sign_east_of_mire
db $FB, $F8
db $FD, $16, " Misery Mire"
db $F9
db " No way in."
db $FA, $F6
db " No way out."

; sign_village_of_outcasts
db $FB
db "Have a trulie"
db $F8
db "awesome day!"

; 0xB0 - sign_before_wishing_pond
db $FB
db "Waterfall"
db $F8
db "up ahead:"
db $F9
db "Make wishes!"

; sign_before_catfish_area
db $FB
db $FD, $15, $FD, $13 " Have you"
db $F8
db "met Woeful Ike?"

; castle_wall_guard
db $FB
db "Looking for a"
db $F8
db "princess? Look"
db $F9
db "downstairs."

; gate_guard
db $FB
db "NO LONKS"
db $F8
db "ALLOWED!"

; telepathic_tile_eastern_palace
db $FB, $FE, $6B, $02
db "You need a bow to"
db $F8
db "get past the red"
db $F9
db "eyegore. Derpy."

; telepathic_tile_tower_of_hera_floor_4
db $FB, $FE, $6B, $02
db "If you find a shiny"
db $F8
db "ball, you can be"
db $F9
db "you in the Dark"
db $F6
db "World."

; hylian_text_1
db $FB
db $FD, $10, $FD, $12, $FD, $12, " "
db $FD, $10, $FD, $12, $FD, $12, " "
db $FD, $10, $FD, $12, $FD, $12
db $F8
db " ", $FD, $11, " ", $FD, $10, $FD, $12, $FD, $12, $FD, $10, " ", $FD, $11
db $F9
db $FD, $10, $FD, $12, $FD, $12, " "
db $FD, $11, $FD, $10, $FD, $10, $FD, $11, " "
db $FD, $12, $FD, $12, $FD, $11

; mastersword_pedestal_translated
db $FB
db "A Test of Strength"
db $F8
db "If you have 3"
db $F9
db "pendants, I'm yours"

; telepathic_tile_spectacle_rock
db $FB, $FE, $6B, $02
db "Use the"
db $F8
db "mirror, or the"
db $F9
db "hookshot and"
db $FA, $F6
db "hammer, to get"
db $F6
db "to Tower of"
db $F6
db "Hera!"

; telepathic_tile_swamp_entrance
db $FB, $FE, $6B, $02
db "Drain the"
db $F8
db "floodgate to"
db $F9
db "raise the"
db $FA, $F6
db "water here!"

; telepathic_tile_thieves_town_upstairs
db $FB, $FE, $6B, $02
db "Blind hates"
db $F8
db "bright light."

; telepathic_tile_misery_mire
db $FB, $FE, $6B, $02
db "Lighting 4"
db $F8
db "torches will"
db $F9
db "open your way"
db $FA, $F6
db "forward!"

; hylian_text_2
%NoText()

; desert_entry_translated
%NoText()

; telepathic_tile_under_ganon
db $FB
db "Try not to fall"
db $F8
db "next time!"

; telepathic_tile_palace_of_darkness
db $FB, $FE, $6B, $02
db "This is a"
db $F8
db "funny looking"
db $F9
db "enemizer"

; telepathic_tile_desert_bonk_torch_room
db $FB, $FE, $6B, $02
db "Things can be"
db $F8
db "knocked down,"
db $F9
db "if you fancy"
db $FA, $F6
db "yourself a"
db $F6
db "dashing dude."

; telepathic_tile_castle_tower
db $FB, $FE, $6B, $02
db "You can reflect"
db $F8
db "Agahnim's energy"
db $F9
db "with sword, bug"
db $FA, $F6
db "net or hammer."

; telepathic_tile_ice_large_room
db $FB, $FE, $6B, $02
db "ALL RIGHT STOP"
db $F8
db "COLLABORATE"
db $F9
db "AND LISTEN"
db $FA, $F6
db "ICE IS BACK"
db $F6
db "WITH MY BRAND"
db $F6
db "NEW INVENTION."

; telepathic_tile_turtle_rock
db $FB, $FE, $6B, $02
db "You shall not pass"
db $F8
db " ", $9F, "without"
db $F9
db "the Red Cane."

; telepathic_tile_ice_entrance
db $FB, $FE, $6B, $02
db "You can use"
db $F8
db "Fire Rod or"
db $F9
db "Bombos to"
db $FA, $F6
db "pass."

; telepathic_tile_ice_stalfos_knights_room
db $FB, $FE, $6B, $02
db "Knock 'em down"
db $F8
db "and then bomb"
db $F9
db "them dead."

; telepathic_tile_tower_of_hera_entrance
db $FB, $FE, $6B, $02
db "This is a bad"
db $F8
db "place, with a"
db $F9
db "guy who will"
db $FA, $F6
db "make you fall"
db $9F, $F6, $F6, $FA, $F6
db "a lot."

; houlihan_room
db $FB
db "Oops!"
db $F8
db "You shouldn't be"
db $F9
db "here!"

; caught_a_bee
db $FB
db "Caught a bee"
db $F8
db "  "
db $99
db " Keep"
db $F9
db "    Release"
db $FE, $68

; caught_a_fairy
db $FB
db "Caught fairy!"
db $F8
db "  "
db $99
db " Keep"
db $F9
db "    Release"
db $FE, $68

; no_empty_bottles
db $FB
db "Whoa, bucko!"
db $F8
db "No empty bottles."

; game_race_boy_time
db $FB
db "Your time was"
db $F8, $FE, $6C, $03, $FE, $6C, $02
db " min "
db $FE, $6C, $01, $FE, $6C, $00
db " sec."

; game_race_girl
db $FB
db "You have 15"
db $F8
db "seconds,"
db $F9
db "go"
db $9F
db " Go"
db $9F
db " GO"
db $9F

; game_race_boy_success
db $FB
db "Nice!"
db $F8
db "You can have"
db $F9
db "this trash!"

; game_race_boy_failure
db $FB
db "Too slow!"
db $F8
db "I keep my"
db $F9
db "precious!"

; game_race_boy_already_won
db $FB
db "You already"
db $F8
db "have your"
db $F9
db "prize, dingus!"

; 0xD0 - game_race_boy_sneaky
db $FB
db "THOUGHT YOU"
db $F8
db "COULD SNEAK"
db $F9
db "IN, EH?"

; bottle_vendor_choice
%NoText()

; bottle_vendor_get
%NoText()

; bottle_vendor_no
db $FB
db "Fine! I didn't"
db $F8
db "want your"
db $F9
db "money anyway."

; bottle_vendor_already_collected
db $FB
db "Dude! You"
db $F8
db "already have it!"

; bottle_vendor_bee
db $FB
db "Cool! A bee!"
db $F8
db "Here's 100"
db $F9
db "rupees."

; bottle_vendor_fish
db $FB
db "Whoa! A fish!"
db $F8
db "you walked"
db $F9
db "this all the"
db $FA, $F6
db "way here?"

; bridge_guy_item_get_bottle
%NoText()

; blacksmiths_what_you_want
%NoText()

; blacksmiths_paywall
%NoText()

; blacksmiths_extra_okay
%NoText()

; blacksmiths_tempered_already
%NoText()

; blacksmiths_temper_no
db $FB
db "Oh, come by"
db $F8
db "any time!"

; blacksmiths_bogart_sword
%NoText()

; blacksmiths_get_sword
%NoText()

; blacksmiths_shop_before_saving
db $FB
db "I LOST MY"
db $F8
db "FRIEND. HELP"
db $F9
db "ME FIND HIM!"

; 0xE0 - blacksmiths_shop_saving
%NoText()

; blacksmiths_collect_frog
%NoText()

; blacksmiths_still_working
db $FB
db "SOMETHING THIS"
db $F8
db "PRECIOUS TAKES"
db $F9
db "TIME"
db $9F
db " COME"
db $FA, $F6
db "BACK LATER."

; blacksmiths_saving_bows
db $FB
db "THANKS!"
db $F8, $F9
db "THANKS!"

; blacksmiths_hammer_anvil
db $FB
db "DERNT TAKE ER"
db $F8
db "JERBS!"

; dark_flute_boy_storytime
%NoText()

; dark_flute_boy_get_shovel
%NoText()

; dark_flute_boy_no_get_shovel
db $FB
db "OH I SEE, NOT"
db $F8
db "GOOD ENOUGH"
db $F9
db "FOR YOU"
db $9F
db " FINE!"

; dark_flute_boy_flute_not_found
db $FB
db "STILL HAVEN'T"
db $F8
db "FOUND THE"
db $F9
db "ITEM? DIG IN"
db $FA, $F6
db "THE LIGHT"
db $F6
db "WORLD AROUND"
db $F6
db "HERE, DINGUS!"

; dark_flute_boy_after_shovel_get
db $FB
db "SO I GAVE YOU"
db $F8
db "AN ITEM, AND"
db $F9
db "YOU'RE STILL"
db $FA, $F6
db "HERE."
db $F6, $F6, $FA, $F6, $F6, $F6, $FA, $F6
db "I MEAN, WE CAN"
db $F6
db "SIT HERE AND"
db $F6
db "STARE AT EACH"
db $FA, $F6
db "OTHER, IF YOU"
db $F6
db "LIKE"
db $9F, $F6, $FA, $F6, $F6, $F6, $FA, $F6, $F6, $F6, $FA, $F6
db "FINE, I GUESS"
db $F6
db "YOU SHOULD"
db $F6
db "JUST GO."

; shop_fortune_teller_lw_hint_0
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, THE BOOK"
db $F9
db "OPENS THE"
db $FA, $F6
db "DESERT"

; shop_fortune_teller_lw_hint_1
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, NOTHING"
db $F9
db "DOING"

; shop_fortune_teller_lw_hint_2
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, I'M"
db $F9
db "CHEAP"

; shop_fortune_teller_lw_hint_3
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, AM I"
db $F9
db "CHEAP?"

; shop_fortune_teller_lw_hint_4
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, ZORA"
db $F9
db "LIVES AT THE"
db $FA, $F6
db "END OF THE"
db $F6
db "RIVER"

; shop_fortune_teller_lw_hint_5
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, THE CAPE"
db $F9
db "CAN PASS"
db $FA, $F6
db "THROUGH THE"
db $F6
db "BARRIER"

; shop_fortune_teller_lw_hint_6
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, SPIN,"
db $F9
db "HAMMER, OR NET"
db $FA, $F6
db "TO HURT"
db $F6
db "AGAHNIM"

; shop_fortune_teller_lw_hint_7
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, YOU CAN"
db $F9
db "JUMP IN THE"
db $FA, $F6
db "WELL BY THE"
db $F6
db "BLACKSMITHS"

; shop_fortune_teller_lw_hint_no_rupees
db $FB, $FE, $6D, $01
db "THE BLACK CATS"
db $F8
db "ARE HUNGRY,"
db $F9
db "COME BACK WITH"
db $FA, $F6
db "RUPEES"

; shop_fortune_teller_lw
db $FB, $FE, $6D, $01
db "WELCOME TO THE"
db $F8
db "FORTUNE"
db $F9
db "SHOPPE!"
db $FA, $F6
db "FANCY A READ?"
db $F6
db "  "
db $99
db "I MUST KNOW"
db $F6
db "   NEGATIVE"
db $FE, $68

; shop_fortune_teller_lw_post_hint
db $FB, $FE, $6D, $01
db "FOR "
db $FE, $6C, $00, $FE, $6C, $01
db " RUPEES"
db $F8
db "IT IS DONE."
db $F9
db "BE GONE!"

; shop_fortune_teller_lw_no
db $FB, $FE, $6D, $01
db "WELL THEN, WHY"
db $F8
db "DID YOU EVEN"
db $F9
db "COME IN HERE?"

; shop_fortune_teller_lw_hint_8
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, WHY YOU"
db $F9
db "DO?"

; shop_fortune_teller_lw_hint_9
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, PANDA"
db $F9
db "CRACKERS"

; shop_fortune_teller_lw_hint_10
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, THE"
db $F9
db "MISSING"
db $FA, $F6
db "BLACKSMITH IS"
db $F6
db "SOUTH OF THE"
db $F6
db "VILLAGE OF"
db $FA, $F6
db "OUTCASTS"

; shop_fortune_teller_lw_hint_11
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, OPEN"
db $F9
db "CHESTS TO GET"
db $FA, $F6
db "STUFF"

; shop_fortune_teller_lw_hint_12
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, YOU CAN"
db $F9
db "BUY A NEW BOMB"
db $FA, $F6
db "AT THE BOMB"
db $F6
db "SHOPPE"

; shop_fortune_teller_lw_hint_13
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, BIG"
db $F9
db "BOMBS BLOW UP"
db $FA, $F6
db "CRACKED WALLS"
db $F6
db "IN PYRAMIDS"

; shop_fortune_teller_lw_hint_14
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, YOU NEED"
db $F9
db "ALL THE"
db $FA, $F6
db "CRYSTALS TO"
db $F6
db "OPEN GANON'S"
db $F6
db "TOWER"

; shop_fortune_teller_lw_hint_15
db $FB, $FE, $6D, $01
db "BY THE BLACK"
db $F8
db "CATS, SILVER"
db $F9
db "ARROWS WILL"
db $FA, $F6
db "DEFEAT GANON"
db $F6
db "IN HIS FINAL"
db $F6
db "PHASE"

; dark_sanctuary
db $FB
db "FOR 20 RUPEES"
db $F8
db "I'LL TELL YOU"
db $F9
db "SOMETHING?"
db $FA, $F6
db "HOW ABOUT IT?"
db $F6
db "  "
db $99
db " YES"
db $F6
db "    NO"
db $FE, $68

; dark_sanctuary_hint_0
db $FB
db "I ONCE WAS A"
db $F8
db "TEA KETTLE,"
db $F9
db "BUT THEN I"
db $FA, $F6
db "MOVED UP IN"
db $F6
db "THE WORLD, AND"
db $F6
db "NOW YOU CAN"
db $FA, $F6
db "SEE ME AS"
db $F6
db "THIS. MAKES"
db $F6
db "YOU WONDER."
db $FA, $F6
db "WHAT I COULD"
db $F6
db "BE NEXT TIME."

; 0x100 - dark_sanctuary_no
db $FB
db "THEN GO AWAY!"

; dark_sanctuary_hint_1
db $FB
db "THERE IS A"
db $F8
db "THIEF IN THE"
db $F9
db "DESERT, HE CAN"
db $FA, $F6
db "OPEN CREEPY"
db $F6
db "CHESTS THAT"
db $F6
db "FOLLOW YOU."
db $FA, $F6
db "BUT NOW THAT"
db $F6
db "WE HAVE THAT"
db $F6
db "OUT OF THE"
db $FA, $F6
db "WAY, DO YOU"
db $F6
db "LIKE MY HAIR?"
db $F6
db "I'VE SPENT"
db $FA, $F6
db "EONS GETTING"
db $F6
db "IT THIS WAY."

; dark_sanctuary_yes
db $FB
db "WITH CRYSTALS"
db $F8
db "5 6, YOU CAN"
db $F9
db "FIND A GREAT"
db $FA, $F6
db "FAIRY IN THE"
db $F6
db "PYRAMID."
db $F6, $FA, $F6
db "FLOMP FLOMP,"
db $F6
db "WHIZZLE WHOMP"

; dark_sanctuary_hint_2
db $FB
db "ALL I CAN SAY"
db $F8
db "IS THAT MY"
db $F9
db "LIFE IS PRETTY"
db $FA, $F6
db "PLAIN,"
db $F6
db "I LIKE"
db $F6
db "WATCHIN' THE"
db $FA, $F6
db "PUDDLES GATHER"
db $F6
db "RAIN,"
db $F6
db "AND ALL I CAN"
db $FA, $F6
db "DO IS JUST"
db $F6
db "POUR SOME TEA"
db $F6
db "FOR TWO,"
db $FA, $F6
db "AND SPEAK MY"
db $F6
db "POINT OF VIEW"
db $F6
db "BUT IT'S NOT"
db $FA, $F6
db "SANE,"
db $F6
db "IT'S NOT SANE"

; sick_kid_no_bottle
db $FB, $FE, $6D, $01
db "I'm sick! Show"
db $F8
db "me a bottle to"
db $F9
db "get something!"

; sick_kid_trade
%NoText()

; sick_kid_post_trade
db $FB, $FE, $6D, $01
db "Leave me alone!"
db $F8
db "I'm sick. You"
db $F9
db "have my item."

; desert_thief_sitting
%NoText()

; desert_thief_following
%NoText()

; desert_thief_question
%NoText()

; desert_thief_question_yes
%NoText()

; desert_thief_after_item_get
%NoText()

; desert_thief_reassure
%NoText()

; hylian_text_3
db $FB
db $FD, $11, $FD, $11 " "
db $FD, $11, $FD, $10, $FD, $12, $FD, $10, $FD, $12, " "
db $FD, $12, $FD, $10, $FD, $12
db $F8
db $FD, $12, $FD, $10, $FD, $10, " "
db $FD, $12, $FD, $10, $FD, $10, $FD, $12, $FD, $11
db $F9
db $FD, $12, $FD, $12, $FD, $10, $FD, $11, $FD, $12, " "
db $FD, $10, $FD, $12, $FD, $11, $FD, $11, $FD, $10

; tablet_ether_book
db $FB
db "CAN YOU MAKE"
db $F8
db "THINGS FALL"
db $F9
db "OUT OF THE"
db $FA, $F6
db "SKY? WITH THE"
db $F6
db "MASTER SWORD,"
db $F6
db "YOU CAN!"

; tablet_bombos_book
db $FB
db "CAN YOU MAKE"
db $F8
db "THINGS FALL"
db $F9
db "OUT OF THE"
db $FA, $F6
db "SKY? WITH THE"
db $F6
db "MASTER SWORD,"
db $F6
db "YOU CAN!"

; 0x110 - magic_bat_wake
%NoText()

; magic_bat_give_half_magic
%NoText()

; intro_main
db $FB, $FE, $6E, $00, $FE, $77, $07, $FC, $03, $FE, $6B, $02, $FE, $67
db "   Episode  III   "
db $FE, $78, $03, $F8
db "   A Link To      "
db $F9
db "     The Past     "
db $FE, $78, $03, $F6
db "    Randomizer    "
db $FE, $78, $03, $F6
db "After mostly"
db $F6
db "disregarding"
db $F6
db "what happened"
db $F6
db "in the first"
db $F6
db "two games,"
db $FE, $78, $03, $F6
db "Link awakens"
db $F6
db "to his uncle"
db $F6
db "leaving the"
db $F6
db "house."
db $FE, $78, $03, $F6
db "He just runs"
db $F6
db "out the door,"
db $FE, $78, $03, $F6
db "into the rainy"
db $F6
db "night."
db $FE, $78, $03, $FE, $67, $FE, $67, $F6
db "Ganon has"
db $F6
db "moved around"
db $F6
db "all the items"
db $F6
db "in Hyrule."
db $FE, $78, $07, $F6
db "You will have"
db $F6
db "to find all"
db $F6
db "the items"
db $F6
db "necessary to"
db $F6
db "beat Ganon."
db $FE, $78, $07, $F6
db "This is your"
db $F6
db "chance to be a"
db $F6
db "hero."
db $FE, $78, $03, $FE, $67, $FE, $67, $F6
db "You must get"
db $F6
db "enough"
db $F6
db "crystals to"
db $F6
db "beat Ganon."
db $FE, $78, $09, $FE, $67, $FE, $67

; intro_throne_room
db $FB, $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7
db "Look at this"
db $F8
db "Stalfos on the"
db $F9
db "throne."

; intro_zelda_cell
db $FB, $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7
db "It is your"
db $F8
db "time to shine!"

; intro_agahnim
db $FB, $FE, $6B, $02, $FE, $77, $07, $FC, $03, $F7
db "Also, you need"
db $F8
db "to defeat this"
db $F9
db "guy!"

; pickup_purple_chest
%NoText()

; bomb_shop
db $FB
db "30 bombs for"
db $F8
db "100 rupees."
db $F9
db "Good deals all day!"

; bomb_shop_big_bomb
db $FB
db "30 bombs for"
db $F8
db "100 rupees."
db $F9
db "100 rupees 1"
db $FA, $F6
db "BIG bomb. Good"
db $F6
db "deals all day!"

; bomb_shop_big_bomb_buy
%NoText()

; item_get_big_bomb
%NoText()

; kiki_second_extortion
%NoText()

; kiki_second_extortion_no
db $FB
db "Heh, good luck"
db $F8
db "getting in."

; kiki_section_extortion_yes
%NoText()

; kiki_first_extortion
%NoText()

; kiki_first_extortion_yes
%NoText()

; 0x120 - kiki_first_extortion_no
db $FB
db "PFFT. I HAVE"
db $F8
db "NO REASON TO"
db $F9
db "HANG. SEE YA!"

; kiki_leaving_screen
db $FB
db "No no no no no!"
db $F8
db "We should play"
db $F9
db "by my rules!"
db $FA, $F6
db "Goodbye!"
db $9F

; blind_in_the_cell
%NoText()

; blink_by_the_light
db $FB
db "AAAAHHHH~!"
db $F8
db "S-so bright~!"

; blind_not_that_way
%NoText()

; aginah_l1sword_no_book
db $FB
db "I ONCE HAD A"
db $F8
db "FISH DINNER. I"
db $F9
db "STILL REMEMBER"
db $FA, $F6
db "IT TO THIS"
db $F6
db "DAY."

; aginah_l1sword_with_pendants
db $FB
db "DO YOU"
db $F8
db "REMEMBER WHEN"
db $F9
db "I WAS YOUNG?"
db $FA, $F6, $F6
db "I SURE DON'T."

; aginah
db $FB
db "SO, I'VE BEEN"
db $F8
db "LIVING IN THIS"
db $F9
db "CAVE FOR"
db $FA, $F6
db "YEARS, AND YOU"
db $F6
db "THINK YOU CAN"
db $F6
db "JUST COME"
db $FA, $F6
db "ALONG AND BOMB"
db $F6
db "OPEN WALLS?"

; aginah_need_better_sword
db $FB
db "ONCE, I FARTED"
db $F8
db "IN THIS CAVE"
db $F9
db "SO BAD ALL THE"
db $FA, $F6
db "JAZZ HANDS"
db $F6
db "GUYS RAN AWAY"
db $F6
db "AND HID IN THE"
db $FA, $F6
db "SAND."

; aginah_have_better_sword
db $FB
db "PANDAS ARE"
db $F8
db "VERY VICIOUS"
db $F9
db "ANIMALS. NEVER"
db $FA, $F6
db "FORGET"
db $9F, $F6, $F6, $FA, $F6, $F6, $F6
db "I NEVER WILL"
db $9F

; catfish
%NoText()

; catfish_after_item
%NoText()

; lumberjack_right
db $FB
db "ONE OF US"
db $F8
db "ALWAYS LIES."

; lumberjack_left
db $FB
db "ONE OF US"
db $F8
db "ALWAYS TELLS"
db $F9
db "THE TRUTH."

; lumberjack_left_post_master_sword
db $FB
db "ONE OF US"
db $F8
db "LIKES PEANUT"
db $F9
db "BUTTER."

; fighting_brothers_right
db $FB
db "I WALLED OFF"
db $F8
db "MY BROTHER LEO"
db $F9, $FA, $F6
db "WHAT A DINGUS."

; 0x130 - fighting_brothers_right_opened
db $FB
db "NOW I SHOULD"
db $F8
db "PROBABLY TALK"
db $F9
db "TO HIM"
db $9F

; fighting_brothers_left
db $FB
db "DID YOU COME"
db $F8
db "FROM MY"
db $F9
db "BROTHERS ROOM?"
db $FA, $F6, $F6
db "ARE WE COOL?"

; maiden_crystal_1
%NoText()

; maiden_crystal_2
%NoText()

; maiden_crystal_3
%NoText()

; maiden_crystal_4
%NoText()

; maiden_crystal_5
%NoText()

; maiden_crystal_6
%NoText()

; maiden_crystal_7
%NoText()

; maiden_ending
%NoText()

; maiden_confirm_understood
%NoText()

; barrier_breaking
%NoText()

; maiden_crystal_7_again
%NoText()

; agahnim_zelda_teleport
%NoText()

; agahnim_magic_running_away
%NoText()

; agahnim_hide_and_seek_found
%NoText()

; 0x140 - agahnim_defeated
%NoText()

; agahnim_final_meeting
%NoText()

; zora_meeting
%NoText()

; zora_tells_cost
%NoText()

; zora_get_flippers
%NoText()

; zora_no_cash
db $FB
db "Fine!"
db $F8
db "Go get some"
db $F9
db "more money first!"

; zora_no_buy_item
%NoText()

; kakariko_sahasrahla_grandson
db $FB
db "MY GRANDPA IS"
db $F8
db "OVER IN THE"
db $F9
db "EAST. I'M BAD"
db $FA, $F6
db "WITH"
db $F6
db "DIRECTIONS."
db $F6
db "I'LL MARK YOUR"
db $FA, $F6
db "MAP. BEST OF"
db $F6
db "LUCK!"
db $FE, $79, $2D

; kakariko_sahasrahla_grandson_next
db $FB
db "SOMEDAY I'LL"
db $F8
db "BE IN A HIGH"
db $F9
db "SCHOOL BAND!"

; dark_palace_tree_dude
db $FB
db "DID YOU KNOW"
db $9F, $F8, $F9, $FA, $F6
db "A TREE"
db $F6
db "TYPICALLY HAS"
db $F6
db "MANY SECONDARY"
db $FA, $F6
db "BRANCHES"
db $F6
db "SUPPORTED"
db $F6
db "CLEAR OF THE"
db $FA, $F6
db "GROUND BY THE"
db $F6
db "TRUNK. THIS"
db $F6
db "TRUNK"
db $FA, $F6
db "TYPICALLY"
db $F6
db "CONTAINS WOODY"
db $F6
db "TISSUE FOR"
db $FA, $F6
db "STRENGTH, AND"
db $F6
db "VASCULAR"
db $F6
db "TISSUE TO"
db $FA, $F6
db "CARRY"
db $F6
db "MATERIALS FROM"
db $F6
db "ONE PART OF"
db $FA, $F6
db "THE TREE TO"
db $F6
db "ANOTHER."

; fairy_wishing_ponds
db $FB, $F8
db "-WISHING POND-"
db $F9, $FA, $F6
db "THROW ITEM IN?"
db $F6
db "  "
db $99
db " YESH"
db $F6
db "    NO"
db $FE, $68

; fairy_wishing_ponds_no
db $FB, $F8
db "   STOP IT!"

; pond_of_wishing_no
db $FB, $F8
db "  FINE THEN!"

; pond_of_wishing_return_item
db $FB
db "OKAY. HERE'S"
db $F8
db "YOUR ITEM"
db $F9
db "BACK, CAUSE I"
db $FA, $F6
db "CAN'T USE IT."
db $F6
db "I'M STUCK IN"
db $F6
db "THIS FOUNTAIN."

; pond_of_wishing_throw
db $FB
db "HOW MANY?"
db $F8
db "  "
db $99, $FE, $6C, $01, $FE, $6C, $00
db " RUPEES"
db $F9
db "   "
db $FE, $6C, $03, $FE, $6C, $02
db " RUPEES"
db $FE, $68

; pond_pre_item_silvers
db $FB
db "I LIKE YOU, SO"
db $F8
db "HERE'S A THING"
db $F9
db "YOU CAN USE TO"
db $FA, $F6
db "BEAT UP GANON."

; pond_of_wishing_great_luck
db $FB, $F8
db "IS GREAT LUCK"

; pond_of_wishing_good_luck
db $FB, $F8
db " IS GOOD LUCK"

; pond_of_wishing_meh_luck
db $FB, $F8
db " IS MEH LUCK"

; pond_of_wishing_bad_luck (repurposed)
db $FB
db "Why you come in"
db $F8
db "here and pretend"
db $F9
db "like you have"
db $FA, $F6
db "something this"
db $F6
db "fountain waints?"
db $F6
db "Come back with"
db $FA, $F6
db "bottles!"

; pond_of_wishing_fortune
db $FB
db "BY THE WAY,"
db $F8
db "YOUR FORTUNE,"

; item_get_14_heart
%NoText()

; item_get_24_heart
%NoText()

; item_get_34_heart
%NoText()

; item_get_whole_heart
%NoText()

; item_get_sanc_heart
%NoText()

; fairy_fountain_refill
db $FB
db "Well done."
db $F8
db "Lettuce have a"
db $F9
db "cup of tea."
db $9F

; death_mountain_bullied_no_pearl
db $FB
db "I WROTE A"
db $F8
db "WORD. JUST"
db $F9
db "ONE. ON A"
db $FA, $F6
db "STONE AND"
db $F6
db "THREW IT INTO"
db $F6
db "THE OCEAN. IT"
db $FA, $F6
db "WAS MY WORD."
db $F6
db "IT WAS WHAT"
db $F6
db "WOULD SAVE ME."
db $FA, $F6
db "I HOPE SOMEDAY"
db $F6
db "SOMEONE FINDS"
db $F6
db "THAT WORD AND"
db $FA, $F6
db "BRINGS IT TO"
db $F6
db "ME. THE WORD"
db $F6
db "IS THE"
db $FA, $F6
db "BEGINNING OF"
db $F6
db "MY SONG."

; death_mountain_bullied_with_pearl
db $FB
db "I WROTE A"
db $F8
db "SONG. JUST"
db $F9
db "ONE. ON A"
db $FA, $F6
db "GUITAR AND"
db $F6
db "THREW IT INTO"
db $F6
db "THE SKY. IT"
db $FA, $F6
db "WAS MY SONG."
db $F6
db "IT COULD TAME"
db $F6
db "BEASTS AND"
db $FA, $F6
db "FREE MINDS. IT"
db $F6
db "FLITTERS ON"
db $F6
db "THE WIND AND"
db $FA, $F6
db "LURKS IN OUR"
db $F6
db "MINDS. IT IS"
db $F6
db "THE SONG OF"
db $FA, $F6
db "NATURE, OF"
db $F6
db "HUMANITY, OF"
db $F6
db "DREAMS AND"
db $FA, $F6
db "DREAMERS."

; death_mountain_bully_no_pearl
db $FB
db "ADD GARLIC,"
db $F8
db "GINGER AND"
db $F9
db "APPLE AND COOK"
db $FA, $F6
db "FOR 2 MINUTES."
db $F6
db "ADD CARROTS,"
db $F6
db "POTATOES,"
db $FA, $F6
db "GARAM MASALA"
db $F6
db "AND CURRY"
db $F6
db "POWDER AND"
db $FA, $F6
db "STIR WELL. ADD"
db $F6
db "TOMATO PASTE,"
db $F6
db "STIR WELL AND"
db $FA, $F6
db "SLOWLY ADD RED"
db $F6
db "WINE AND BRING"
db $F6
db "TO A BOIL. ADD"
db $FA, $F6
db "SUGAR, SOY"
db $F6
db "SAUCE AND"
db $F6
db "WATER, STIR"
db $FA, $F6
db "AND BRING TO A"
db $F6
db "BOIL AGAIN."

; death_mountain_bully_with_pearl
db $FB
db "I THINK I"
db $F8
db "FORGOT HOW TO"
db $F9
db "SMILE"
db $9F

; shop_darkworld_enter
%NoText()

; 0x160 - game_chest_village_of_outcasts
%NoText()

; game_chest_no_catch
db $FB
db "So, like, you"
db $F8
db "need 30 rupees."
db $F9
db "Silly!"

; game_chest_not_played
db $FB
db "You want to"
db $F8
db "play a game?"
db $F9
db "talk to me."

; game_chest_played
db $FB
db "You've opened"
db $F8
db "the chests!"
db $F9
db "Time to go."

; game_chest_village_of_outcasts_play
%NoText()

; shop_first_time
%NoText()

; shop_already_have
db $FB
db "So, like, you"
db $F8
db "already have"
db $F9
db "one of those."

; shop_buy_shield
%NoText()

; shop_buy_red_potion
%NoText()

; shop_buy_arrows
%NoText()

; shop_buy_bombs
%NoText()

; shop_buy_bee
%NoText()

; shop_buy_heart
%NoText()

; shop_first_no_bottle_buy
db $FB
db "Why does no own"
db $F8
db "own bottles? Go"
db $F9
db "find one first!"

; shop_buy_no_space
db $FB
db "You are carrying"
db $F8
db "too much crap. Go"
db $F9
db "use some of it"
db $FA, $F6
db "first!"

; ganon_fill_in
db $FB
db "You drove"
db $F8
db "away my other"
db $F9
db "self, Agahnim,"
db $FA, $F6
db "two times,"
db $9F, $F6
db "but, I won't"
db $F6
db "give you the"
db $FA, $F6
db "triforce."
db $F6
db "I'll defeat"
db $F6
db "you!"

; 0x170 - ganon_phase_3
db $FB
db "Can you beat"
db $F8
db "my darkness"
db $F9
db "technique?"

; lost_woods_thief
db $FB
db "HAVE YOU SEEN"
db $F8
db "ANDY?"
db $F9, $FA, $F6
db "HE WAS OUT"
db $F6
db "LOOKING FOR"
db $F6
db "OUR PRIZED"
db $FA, $F6
db "ETHER"
db $F6
db "MEDALLION."
db $F6
db "I WONDER WHEN"
db $FA, $F6
db "HE WILL BE"
db $F6
db "BACK?"

; blinds_hut_dude
db $FB
db "I'M JUST SOME"
db $F8
db "DUDE. THIS IS"
db $F9
db "BLIND'S HUT."

; end_triforce
db $FB, $FC, $02, $FE, $6D, $00, $FE, $6B, $02
db "     G G"

; toppi_fallen
db $FB
db "Ouch!"
db $F8, $F9
db "You jerk!"

; kakariko_tavern_fisherman
db $FB
db "DON'T ARGUE"
db $F8
db "WITH A FROZEN"
db $F9
db "DEADROCK."
db $FA, $F6
db "HE'LL NEVER"
db $F6
db "CHANGE HIS"
db $F6
db "POSITION!"

; thief_money
%NoText()

; thief_desert_rupee_cave
db $FB
db "SO YOU, LIKE,"
db $F8
db "BUSTED DOWN MY"
db $F9
db "DOOR, AND ARE"
db $FA, $F6
db "BEING A JERK"
db $F6
db "BY TALKING TO"
db $F6
db "ME? NORMALLY I"
db $FA, $F6
db "WOULD BE ANGRY"
db $F6
db "AND MAKE YOU"
db $F6
db "PAY FOR IT,"
db $FA, $F6
db "BUT I BET"
db $F6
db "YOU'RE JUST"
db $F6
db "GOING TO BREAK"
db $FA, $F6
db "ALL MY POTS"
db $F6
db "AND STEAL MY"
db $F6
db "50 RUPEES."

; thief_ice_rupee_cave
db $FB
db "I'M A RUPEE"
db $F8
db "POT FARMER."
db $F9
db "ONE DAY I WILL"
db $FA, $F6
db "TAKE OVER THE"
db $F6
db "WORLD WITH MY"
db $F6
db "SKILLZ. HAVE"
db $FA, $F6
db "YOU MET MY"
db $F6
db "BROTHER IN THE"
db $F6
db "DESERT? HE'S"
db $FA, $F6
db "WAY RICHER"
db $F6
db "THAN I AM."

; telepathic_tile_south_east_darkworld_cave
db $FB
db "~~ DEV CAVE ~~"
db $F8
db "  NO FARMING"
db $F9
db "   REQUIRED"

; cukeman
db $FB
db "Trans rights!"

; cudeman_2
db $FB
db "You found"
db $F8
db "Shabadoo, huh?"
db $F9
db "Niiiiice."

; potion_shop_no_cash
db $FB
db "Yo! I'm not"
db $F8
db "running a"
db $F9
db "charity here."

; kakariko_powdered_chicken
db $FB
db "SMALLHACKER"
db $9F, $F8, $F9, $FA, $F6
db "WAS HIDING,"
db $F6
db "YOU FOUND ME!"
db $F6, $FA, $F6, $F6
db "OKAY, YOU CAN"
db $F6
db "LEAVE NOW."

; game_chest_south_of_kakariko
db $FB
db "PAY 20 RUPEES,"
db $F8
db "OPEN 1 CHEST."
db $F9
db "ARE YOU LUCKY?"
db $FA, $F6
db "SO, PLAY GAME?"
db $F6
db "  "
db $99
db " PLAY"
db $F6
db "    NEVER!"
db $FE, $68

; game_chest_play_yes
db $FB
db "GOOD LUCK THEN"

; 0x180 - game_chest_play_no
db $FB
db "WELL FINE, I"
db $F8
db "DIDN'T WANT"
db $F9
db "YOUR RUPEES."

; game_chest_lost_woods
db $FB
db "PAY 100 RUPEES"
db $F8
db "OPEN 1 CHEST."
db $F9
db "ARE YOU LUCKY?"
db $FA, $F6
db "SO, PLAY GAME?"
db $F6
db "  "
db $99
db " PLAY"
db $F6
db "    NEVER!"
db $FE, $68

; kakariko_flophouse_man_no_flippers
db $FB
db "I SURE DO HAVE"
db $F8
db "A LOT OF BEDS."
db $F9, $FA, $F6
db "ZORA IS A"
db $F6
db "CHEAPSKATE AND"
db $F6
db "WILL TRY TO"
db $FA, $F6
db "SELL YOU HIS"
db $F6
db "TRASH FOR 500"
db $F6
db "RUPEES"
db $9F

; kakariko_flophouse_man
db $FB
db "I SURE DO HAVE"
db $F8
db "A LOT OF BEDS."
db $F9, $FA, $F6
db "DID YOU KNOW"
db $F6
db "IF YOU PLAYED"
db $F6
db "THE FLUTE IN"
db $FA, $F6
db "THE CENTER OF"
db $F6
db "TOWN THINGS"
db $F6
db "COULD HAPPEN?"

; menu_start_2
db $FB, $FE, $6D, $00, $FC, $00, $99, $FE, $6A
db "'s House"
db $F8
db " Sanctuary"
db $FE, $72

; menu_start_3
db $FB, $FE, $6D, $00, $FC, $00, $99, $FE, $6A
db "'s House"
db $F8
db " Sanctuary"
db $F9
db " Mountain Cave"
db $FE, $71

; menu_pause
db $FB, $FC, $00, $99
db "Continue"
db $F8
db " Save and Quit"
db $FE, $72

; game_digging_choice
%NoText()

; game_digging_start
%NoText()

; game_digging_no_cash
db $FB
db "Shovel rental"
db $F8
db "is 80 rupees."
db $F9
db "I have all day"

; game_digging_end_time
db $FB
db "Time's up!"
db $F8
db "Time for you"
db $F9
db "to go."

; game_digging_come_back_later
db $FB
db "COME BACK"
db $F8
db "LATER, I HAVE"
db $F9
db "TO BURY"
db $FA, $F6
db "THINGS."

; game_digging_no_follower
db $FB
db "Something is"
db $F8
db "following you."
db $F9
db "I don't like."

; menu_start_4
db $FB, $FE, $6D, $00, $FC, $00, $99, $FE, $6A
db "'s House"
db $F8
db " Mountain Cave"
db $FE, $72

; ganon_fall_in_alt
db $FB
db "You think you"
db $F8
db "are ready to"
db $F9
db "face me?"
db $FA, $F6, $F6
db "I will not die"
db $F6, $FA, $F6
db "unless you"
db $F6
db "complete your"
db $F6
db "goals. Dingus!"

; ganon_phase_3_alt
db $FB
db "Got wax in"
db $F8
db "your ears? I"
db $F9
db "cannot die!"

; 0x190 - sign_east_death_mountain_bridge
db $FB
db "HOW DID YOU"
db $F8
db "GET UP HERE?"

; fish_money
db $FB
db "It's a secret"
db $F8
db "to everyone."

; sign_ganons_tower
db $FB
db "You need all 7"
db $F8
db "crystals to"
db $F9
db "enter."

; sign_ganon
db $FB
db "You need all 7"
db $F8
db "crystals to"
db $F9
db "beat ganon."

; ganon_phase_3_no_bow
db $FB
db "You have no bow."
db $F8
db "Dingus!"

; ganon_phase_3_no_silvers_alt
db $FB
db "You can't best"
db $F8
db "me without"
db $F9
db "silver arrows!"

; ganon_phase_3_no_silvers
db $FB
db "You can't best"
db $F8
db "me without"
db $F9
db "silver arrows!"

; ganon_phase_3_silvers
db $FB
db "Oh no! Silver!"
db $F8
db "My one true"
db $F9
db "weakness!"

; murahdahla
db $FB
db "HELLO "
db $FE, $6A
db ". I"
db $F8
db "AM MURAHDAHLA,"
db $F9
db "BROTHER OF"
db $FA, $F6
db "SAHASRAHLA AND"
db $F6
db "AGINAH. BEHOLD"
db $F6
db "THE POWER OF"
db $FA, $F6
db "INVISIBILITY."
db $FE, $78, $03, $F6, $9F
db " "
db $9F
db " "
db $9F, $F6
db "WAIT! YOU CAN"
db $FA, $F6
db "SEE ME? I KNEW"
db $F6
db "I SHOULD HAVE"
db $F6
db "HIDDEN IN  A"
db $FA, $F6
db "HOLLOW TREE."

db $FB

db $FF, $FF

