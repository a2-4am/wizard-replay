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
	cp res/_FileInformation.txt build/ >>build/log
	$(CADIUS) ADDFILE "${BUILDDISK}" "/WIZARD.REPLAY/" "build/WZREPLAY.SYSTEM" >>build/log
	$(CADIUS) CREATEFOLDER "$(BUILDDISK)" "/$(VOLUME)/X/" -C >>build/log
	for f in build/X/*; do \
		$(CADIUS) ADDFOLDER "$(BUILDDISK)" "/$(VOLUME)/X/$$(basename $$f)" "$$f" -C >>build/log; \
	done
#		$(CADIUS) ADDFILE "$(BUILDDISK)" "/$(VOLUME)/X/$$(basename $$f)/" build/"WIZARDRY1#060800" -C >>build/log;

dirs:
	mkdir -p build/X
	touch build/log

asm: preconditions dirs
	$(ACME) -r build/wizard.replay.lst src/wizard.replay.a 2>build/log
#	$(ACME) -r build/wizardry1.lst src/wizardry1.a 2>build/log

extract: preconditions dirs
	$(PARALLEL) '$(CADIUS) EXTRACTVOLUME {} build/X/ >>build/log' ::: res/dsk/*.po
	rm -f build/X/**/.DS_Store build/X/**/PRODOS* build/X/**/LOADER.SYSTEM*
#	rm build/X/**/"WIZARDRY1#060800"

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
