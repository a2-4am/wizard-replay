#
# Wizard Replay makefile
# assembles source code, optionally builds a disk image and mounts it
#
# original by Quinn Dunki on 2014-08-15
# One Girl, One Laptop Productions
# http://www.quinndunki.com/blondihacks
#
# adapted by 4am on 2023-10-11
#

# third-party tools required to build

# https://sourceforge.net/projects/acme-crossass/
ACME=acme

# https://github.com/mach-kernel/cadius
CADIUS=cadius

# https://www.gnu.org/software/parallel/
PARALLEL=parallel

# VOLUME must match volume name in res/blank.hdv
VOLUME=WIZARD.REPLAY
BUILDDISK=build/wizard-replay.hdv

dsk: preconditions asm extract
	cp res/blank.hdv "$(BUILDDISK)" >>build/log
	$(CADIUS) ADDFILE "${BUILDDISK}" "/WIZARD.REPLAY/" "build/WZREPLAY.SYSTEM#FF2000" >>build/log
	$(CADIUS) CREATEFOLDER "$(BUILDDISK)" "/$(VOLUME)/X/" -C >>build/log
	$(CADIUS) CREATEFOLDER "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" -C >>build/log
#
# add loader and disk images for Wizardry I: Proving Grounds of the Mad Overlord
#
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/LOADERS/WIZ1V30/WIZARDRY1#060800" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/WIZARDRY.PG/WIZARDRY1.A#000000" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/WIZARDRY.PG/WIZARDRY1.A.BAK#000000" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/WIZARDRY.PG/WIZARDRY1.B#000000" -C >>build/log
#
# add loader and disk images for Wizardry II: Knight of Diamonds
#
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/LOADERS/WIZ2/WIZARDRY2#060800" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/KOD/WIZARDRY2.A#000000" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/KOD/WIZARDRY2.B#000000" -C >>build/log
#
# add loader and disk images for Wizardry III: Legacy of Llylgamyn
#
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/LOADERS/WIZ3/WIZARDRY3#060800" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/WIZARDRY3/WIZARDRY3.A#000000" -C >>build/log
	$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/WIZ123/" "build/X/WIZARDRY3/WIZARDRY3.B#000000" -C >>build/log
#
# add loader and disk images for third-party Wizardry scenarios (all based on Proving Grounds v2.1, so same loader)
#
	for f in CAT.OF.VLAD EMPERORS.SEAL NIHONBASHI OCONNORS.MINE SCARLET.BROTHER; do \
		$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(VOLUME)/X/$$f" "build/X/$$f" -C >>build/log; \
		$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/$$f" "build/LOADERS/WIZ1V21/WIZARDRY1#060800" -C >>build/log; \
	done

dirs:
	mkdir -p build/X
	mkdir -p build/LOADERS/WIZ1V30
	mkdir -p build/LOADERS/WIZ1V21
	mkdir -p build/LOADERS/WIZ2
	mkdir -p build/LOADERS/WIZ3
	touch build/log

asm: preconditions dirs
	$(ACME) -r build/loader.wizardry1.v21.lst src/loader.wizardry1.v21.a 2>>build/log
	$(ACME) -r build/loader.wizardry1.v30.lst src/loader.wizardry1.v30.a 2>>build/log
	$(ACME) -r build/loader.wizardry2.lst src/loader.wizardry2.a 2>>build/log
	$(ACME) -r build/loader.wizardry3.lst src/loader.wizardry3.a 2>>build/log
	$(ACME) -r build/wizard.replay.lst src/wizard.replay.a 2>>build/log
#	$(ACME) -r build/graphics.explorer.lst src/Attic/graphics.explorer.a 2>>build/log

extract: preconditions dirs
	$(PARALLEL) '$(CADIUS) EXTRACTVOLUME {} build/X/ >>build/log' ::: res/dsk/*.po
#
# remove files we don't use (allows using ADDFOLDER later)
#
	rm -f build/X/**/.DS_Store build/X/**/PRODOS* build/X/**/LOADER.SYSTEM*
#
# remove loaders because we will assemble fresh versions of them from source
#
	rm build/X/**/"WIZARDRY1#060800"
	rm build/X/**/"WIZARDRY2#060800"
	rm build/X/**/"WIZARDRY3#060800"
#
# create backups
#
	rsync -a "build/X/WIZARDRY.PG/WIZARDRY1.A#000000" "build/X/WIZARDRY.PG/WIZARDRY1.A.BAK#000000"

clean:
	rm -rf build/

mount: dsk
	osascript bin/V2Make.scpt "`pwd`" bin/wiz.vii "$(BUILDDISK)"

preconditions:
	@$(ACME) --version | grep -q "ACME, release" || (echo "ACME is not installed" && exit 1)
	@$(CADIUS) | grep -q "cadius v" || (echo "Cadius is not installed" && exit 1)
	@$(PARALLEL) --version | grep -q "GNU" || (echo "GNU Parallel is not installed" && exit 1)

all: clean dsk mount

al: all
