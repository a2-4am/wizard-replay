#!/bin/bash

# blindly replaces 512 bytes inside a file
# (used to patch a custom font into the SCENARIO.DATA file
# of a Wizardry 1 or 2 scenario disk image)
# usage:
#   $ ./changefont.sh <disk image> <font data file> <sector offset>
#   $ ./changefont.sh WizardryScenarioDisk.po wizfont.bin 0x122

dd bs=256 count="$3" < "$1"
dd bs=512 count=1 < "$2"
dd bs=256 skip="$((2+$3))" < "$1"
