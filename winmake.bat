@echo off
rem
rem Wizard Replay Makefile for Windows
rem assembles source code, optionally builds a disk image
rem
rem a qkumba monstrosity from 2024-01-11
rem

rem VOLUME must match volume name in res\blank.hdv
set VOLUME=WIZARD.REPLAY
set BUILDDISK=build\wizard-replay.hdv

rem third-party tools required to build (must be in path)
rem https://sourceforge.net/projects/acme-crossass/
set ACME=acme
rem https://www.brutaldeluxe.fr/products/crossdevtools/cadius/
rem https://github.com/mach-kernel/cadius
set CADIUS=cadius

if "%1" equ "asm" (
:asm
2>nul md build
call :dirs
%ACME% -r build\loader.wizardry1.v30.lst src\loader.wizardry1.v30.a 2>>build\log
%ACME% -r build\loader.wizardry1.v31.lst src\loader.wizardry1.v31.a 2>>build\log
%ACME% -r build\loader.wizardry2.lst src\loader.wizardry2.a 2>>build\log
%ACME% -r build\loader.wizardry3.lst src\loader.wizardry3.a 2>>build\log
%ACME% -r build\loader.wizplus1.lst src\loader.wizplus1.a 2>>build\log
%ACME% -r build\loader.wizplus2.lst src\loader.wizplus2.a 2>>build\log
%ACME% -r build\loader.wizplus3.lst src\loader.wizplus3.a 2>>build\log
%ACME% -r build\wizard.replay.lst src\wizard.replay.a 2>>build\log
goto :EOF
)

if "%1" equ "dsk" (
:dsk
call :asm
call :extract
1>nul copy /y res\blank.hdv "%BUILDDISK%" >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/" "build\WZREPLAY.SYSTEM#FF2000" >>build\log
%CADIUS% CREATEFOLDER "%BUILDDISK%" "/%VOLUME%/X/" -C >>build\log
%CADIUS% CREATEFOLDER "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" -C >>build\log
rem add loaders and disk images for Wizardry I: Proving Grounds of the Mad Overlord
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZ1V31\WIZARDRY1#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY.PG\WIZARDRY1.A#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY.PG\WIZARDRY1.A.BAK#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY.PG\WIZARDRY1.B#000000" -C >>build\log
rem add loader and disk images for Wizardry II: Knight of Diamonds
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZ2\WIZARDRY2#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\KOD\WIZARDRY2.A#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\KOD\WIZARDRY2.A.BAK#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\KOD\WIZARDRY2.B#000000" -C >>build\log
rem add loader and disk images for Wizardry III: Legacy of Llylgamyn
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZ3\WIZARDRY3#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY3\WIZARDRY3.A#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY3\WIZARDRY3.A.BAK#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\X\WIZARDRY3\WIZARDRY3.B#000000" -C >>build\log
rem add loader and disk images for third-party Wizardry scenarios (all based on Proving Grounds v2.1, so same loader)
for %%q in (CAT.OF.VLAD EMPERORS.SEAL NIHONBASHI OCONNORS.MINE SCARLET.BROTHER DRAGON.QUEST) do (
%CADIUS% ADDFOLDER "%BUILDDISK%" "/%VOLUME%/X/%%q/" "build\X\%%q" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/%%q/" "build\LOADERS\WIZ1V30\WIZARDRY1#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/%%q/" "build\LOADERS\WIZPLUS\WIZPLUS1#060800" -C >>build\log
)
rem add loaders and disk images for WizPlus
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/" "build\X\WIZPLUS\WIZPLUS#000000" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZPLUS\WIZPLUS1#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZPLUS\WIZPLUS2#060800" -C >>build\log
%CADIUS% ADDFILE "%BUILDDISK%" "/%VOLUME%/X/WIZ123/" "build\LOADERS\WIZPLUS\WIZPLUS3#060800" -C >>build\log
goto :EOF
)

if "%1" equ "clean" (
:clean
echo y|1>nul 2>nul rd build /s
goto :EOF
)

if "%1" equ "all" (
call :clean
call :dsk
goto :EOF
)

echo usage: %0 clean / asm / dsk / all
goto :EOF

:dirs
2>nul md build\X
2>nul md build\LOADERS\WIZ1V30
2>nul md build\LOADERS\WIZ1V31
2>nul md build\LOADERS\WIZ2
2>nul md build\LOADERS\WIZ3
2>nul md build\LOADERS\WIZPLUS
goto :EOF

:extract
for %%q in (res\dsk\*.po) do %CADIUS% EXTRACTVOLUME "%%q" build\X\ >>build\log
rem remove files we don't use (allows using ADDFOLDER later)
1>nul 2>nul del /s build\X\.DS_Store build\X\PRODOS* build\X\LOADER.SYSTEM*
rem remove loaders because we will assemble fresh versions of them from source
1>nul 2>nul del build\X\WIZARDRY1#060800
1>nul 2>nul del build\X\WIZARDRY2#060800
1>nul 2>nul del build\X\WIZARDRY3#060800
rem create backups
cscript /nologo bin\rsync.js build\X\WIZARDRY.PG\WIZARDRY1.A#000000 build\X\WIZARDRY.PG\WIZARDRY1.A.BAK#000000
cscript /nologo bin\rsync.js build\X\KOD\WIZARDRY2.A#000000 build\X\KOD\WIZARDRY2.A.BAK#000000
cscript /nologo bin\rsync.js build\X\WIZARDRY3\WIZARDRY3.A#000000 build\X\WIZARDRY3\WIZARDRY3.A.BAK#000000
for %%q in (CAT.OF.VLAD EMPERORS.SEAL NIHONBASHI OCONNORS.MINE SCARLET.BROTHER DRAGON.QUEST) do cscript /nologo bin\rsync.js build\X\%%q\WIZARDRY1.A#000000 build\X\%%q\WIZARDRY1.A.BAK#000000
