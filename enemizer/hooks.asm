incsrc hooks/NMI_hook.asm

incsrc hooks/bushes_hooks.asm

incsrc hooks/bossdrop_hooks.asm

incsrc hooks/blinddoor_hooks.asm

incsrc hooks/bosses_hooks.asm

incsrc hooks/moldorm_hooks.asm

incsrc hooks/damage_hooks.asm

incsrc hooks/overworld_sprite_hooks.asm

incsrc hooks/underworld_sprite_hooks.asm

org $85B8BA
JSL GeldmanDrawOverride

org $9EAAAC
JSL StalfosKnightDrawOverride

org $9EB209
JSL BlobDrawOverride