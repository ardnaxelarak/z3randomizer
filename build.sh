#!/bin/bash

rm ../alttp.sfc
cp ~/dev/kwyn/orig/z3.sfc ../alttp.sfc
asar --symbols=wla LTTP_RND_GeneralBugfixes.asm ../alttp.sfc
flips ~/dev/kwyn/orig/z3.sfc ../alttp.sfc  ../base2current.bps
md5sum ../alttp.sfc | tee /dev/tty  | cut -d ' ' -f 1 | xargs -I '{}' sed -i "s/RANDOMIZERBASEHASH = '.\+'/RANDOMIZERBASEHASH = '{}'/g" ~/dev/kwyn/doors/Rom.py
cp ../base2current.bps ~/dev/kwyn/doors/data
