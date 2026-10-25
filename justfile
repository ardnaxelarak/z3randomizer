[private]
@list:
  just --list

build *ARGS:
  cp alttp_jp.sfc alttp_rando.sfc
  bin/windows/asar.exe --symbols=wla {{ ARGS }} LTTP_RND_GeneralBugfixes.asm alttp_rando.sfc

testbuild: (build "-DFEATURE_FIX_BASEROM=1")

grep PATTERN:
  grep -Ri --include=*.asm "{{PATTERN}}" .

lgrep PATTERN:
  grep -Rli --include=*.asm "{{PATTERN}}" .

gfx:
  bin/windows/compress.exe data/c2e3e.bin data/c2e3e.gfx
  bin/windows/compress.exe menu/map_icons.3bpp menu/map_icons_1.3bppc 0x000 0x600
  bin/windows/compress.exe menu/map_icons.3bpp menu/map_icons_2.3bppc 0x600 0x600
  bin/windows/compress.exe menu/map_icons.3bpp menu/map_icons_3.3bppc 0xC00 0x600
  bin/windows/compress.exe menu/map_icons_b.3bpp menu/map_icons_4.3bppc 0x000 0x600
  bin/windows/compress.exe menu/map_icons_b.3bpp menu/map_icons_5.3bppc 0x600 0x600
  bin/windows/compress.exe menu/map_icons_b.3bpp menu/map_icons_6.3bppc 0xC00 0x600
  bin/windows/compress.exe menu/map_sheet_d4.3bpp menu/map_sheet_d4.3bppc
  bin/windows/compress.exe menu/dr_sheet_dc.2bpp menu/dr_sheet_dc.2bppc
  bin/windows/compress.exe menu/door_connectors.3bpp menu/door_connectors.3bppc
  -bin/windows/compress.exe menu/dr_sheet_14.3bpp menu/dr_sheet_14.3bppc

prep: (testbuild)
  cp alttp_rando.sfc alttp_rando_test.sfc
  cp alttp_rando_fixed.sym alttp_rando_test.sym
  bin/windows/asar.exe testing/testing.asm alttp_rando_test.sfc
