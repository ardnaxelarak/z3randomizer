;===================================================================================================
; Vanilla Labels
;===================================================================================================
; EVERY LABEL SHOULD BE IN A FAST ROM BANK
;===================================================================================================
; Labels for routines in the vanilla portion of the ROM. More or less in sequential
; order. Most of these names came from the MoN US disassembly. But we should
; refer to the JP 1.0 disassembly as that's what the randomizer is based on.
;===================================================================================================
;---------------------------------------------------------------------------------------------------
;===================================================================================================
; Long routines (use JSL)
;===================================================================================================
Vram_EraseTilemaps_triforce                                = $808333
JumpTableLocal                                             = $808781
JumpTableLong                                              = $80879C
Sound_LoadLightWorldSongBank                               = $808913
Sound_LoadLightWorldSongBank_do_load                       = $80891D
EnableForceBlank                                           = $80893D
DungeonMask                                                = $8098C0
DecompSwordGfx                                             = $80D308
DecompShieldGfx                                            = $80D348
Tagalong_LoadGfx                                           = $80D463
GetAnimatedSpriteTile                                      = $80D51B
GetAnimatedSpriteTile_variable                             = $80D52D
Attract_DecompressStoryGfx                                 = $80D84E
LoadSelectScreenGfx                                        = $80E529
PrepDungeonExit                                            = $80F945
Mirror_InitHdmaSettings                                    = $80FDEE
Dungeon_LoadRoom                                           = $81873A
Module_PreDungeon                                          = $82821E
Module_PreDungeon_setAmbientSfx                            = $828296
Dungeon_SaveRoomData                                       = $82A0A8
Dungeon_SaveRoomData_justKeys                              = $82A0BE
Dungeon_SaveRoomQuadrantData                               = $82B861
LoadGearPalettes_bunny                                     = $82FD8A
LoadGearPalettes_variable                                  = $82FD95
Filter_Majorly_Whiten_Color                                = $82FEAB
Sprite_SpawnFallingItem                                    = $85A51D
Sprite_DrawMultiple                                        = $85DF6C
Sprite_DrawMultiple_quantity_preset                        = $85DF70
Sprite_DrawMultiple_player_deferred                        = $85DF75
Sprite_ShowSolicitedMessageIfPlayerFacing                  = $85E1A7
Sprite_ShowMessageFromPlayerContact                        = $85E1F0
Sprite_ShowMessageUnconditional                            = $85E219
Sprite_ZeldaLong                                           = $85EC96
Sprite_EB_HeartPiece_handle_flags                          = $85F0C0
Player_ApplyRumbleToSprites                                = $8680FA
Utility_CheckIfHitBoxesOverlapLong                         = $8683E6
Sprite_PrepAndDrawSingleLargeLong                          = $86DBF8
Sprite_PrepAndDrawSingleSmallLong                          = $86DC00
Sprite_DrawShadowLong                                      = $86DC5C
DashKey_Draw                                               = $86DD40
Sprite_ApplySpeedTowardsPlayerLong                         = $86EA18
Sprite_DirectionToFacePlayerLong                           = $86EAA6
Sprite_CheckDamageToPlayerSameLayerLong                    = $86F12F
OAM_AllocateDeferToPlayerLong                              = $86F86A
Player_HaltDashAttackLong                                  = $8791B3
Link_ReceiveItem                                           = $87999D
Sprite_CheckIfPlayerPreoccupied                            = $87F4AA
Ancilla_ReceiveItem                                        = $88C3AE
Ancilla_BreakTowerSeal_draw_single_crystal                 = $88CE93
Ancilla_BreakTowerSeal_stop_spawning_sparkles              = $88CEC3
BreakTowerSeal_ExecuteSparkles                             = $88CF59
Ancilla_SetOam_XY_Long                                     = $88F710
AddReceivedItem                                            = $8985E2
AddPendantOrCrystal                                        = $898BAD
AddWeathervaneExplosion                                    = $898CFD
AddDashTremor                                              = $8993DF
AddAncillaLong                                             = $899D04
Ancilla_CheckIfAlreadyExistsLong                           = $899D1A
GiveRupeeGift                                              = $89AD58
Sprite_SetSpawnedCoords                                    = $89AE64
OverworldMap_InitGfx                                       = $8ABA4F
OverworldMap_DarkWorldTilemap                              = $8ABA99
OverworldMap_LoadSprGfx                                    = $8ABAB9
NameFile_MakeScreenVisible                                 = $8CD7D1
InitializeSaveFile                                         = $8CDB3E
InitializeSaveFile_build_checksum                          = $8CDBC0
GetRandomInt                                               = $8DBA71
OAM_AllocateFromRegionA                                    = $8DBA80
OAM_AllocateFromRegionB                                    = $8DBA84
OAM_AllocateFromRegionC                                    = $8DBA88
OAM_AllocateFromRegionD                                    = $8DBA8C
OAM_AllocateFromRegionE                                    = $8DBA90
OAM_AllocateFromRegionF                                    = $8DBA94
Sound_SetSfxPanWithPlayerCoords                            = $8DBB67
Sound_SetSfx1PanLong                                       = $8DBB6E
Sound_SetSfx2PanLong                                       = $8DBB7C
Sound_SetSfx3PanLong                                       = $8DBB8A
HUD_RefreshIconLong                                        = $8DDB7F
Equipment_UpdateEquippedItemLong                           = $8DDD32
BottleMenu_movingOn                                        = $8DE01E
RestoreNormalMenu                                          = $8DE346
Equipment_SearchForEquippedItemLong                        = $8DE395
HUD_RebuildLong                                            = $8DFA78
HUD_RebuildIndoor_Palace                                   = $8DFA88
HUD_RebuildLong2                                           = $8DFA88
Messaging_Text                                             = $8EEE10
Overworld_TileAttr                                         = $8FFD94
Overworld_DrawPersistentMap16                              = $9BC97C
Palette_Sword                                              = $9BED03
Palette_Shield                                             = $9BED29
Palette_ArmorAndGloves                                     = $9BEDF9
Palette_Hud                                                = $9BEE52
Palette_SelectScreen                                       = $9BEF96
Sprite_NullifyHookshotDrag                                 = $9CF500
Ancilla_CheckForAvailableSlot                              = $9CF537
ShopKeeper_RapidTerminateReceiveItem                       = $9CFAAA
Filter_MajorWhitenMain                                     = $9DE9B6
Sprite_SpawnDynamically                                    = $9DF65D
Sprite_SpawnDynamically_arbitrary                          = $9DF65F
DiggingGameGuy_AttemptPrizeSpawn                           = $9DFD4B
Sprite_GetEmptyBottleIndex                                 = $9EDE28
Sprite_PlayerCantPassThrough                               = $9EF4E7

;===================================================================================================
;---------------------------------------------------------------------------------------------------
;===================================================================================================
; Local routines (use JSR)
;===================================================================================================
;---------------------------------------------------------------------------------------------------
;===================================================================================================
Chicken_SpawnAvengerChicken                                = $86A7DB
DrawProgressIcons                                          = $8DE9C8
DrawEquipment                                              = $8DED29

;===================================================================================================
