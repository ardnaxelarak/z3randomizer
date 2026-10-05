# z3randomizer
Zelda 3 Randomizer Template ASM

How to create the bps patch:

* Save the JP 1.0 ALttP ROM at `alttp_jp.sfc`
* Assemble the ROM with futaba (recommend to use a copy of original rom)

`futaba build randomizer.futaba`

* Output is now at `alttp_rando.sfc`

* Use flips to create a bps file

`flips alttp_jp.sfc alttp_rando.sfc base2current.bps`
