# Is this page for you?

[Download the latest Wizard Replay disk image](https://archive.org/details/WizardReplay) at the archive.org home page if you just want to play Wizardry and other classic RPGs on your Apple II. The rest of this page is for developers who want to work with the source code and assemble it themselves.

# Building the code

Skip to [Mac OS X](#mac-os-x) / [Windows](#windows) / [Linux](#linux)

## Mac OS X

You will need
 - [Xcode command line tools](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)
 - [ACME](https://sourceforge.net/projects/acme-crossass/)
 - [Cadius](https://github.com/mach-kernel/cadius)

As of this writing, all of the non-Xcode programs are installable via [Homebrew](https://brew.sh/). Open `Terminal.app` and enter the following:

``` shell
$ brew tap lifepillar/appleii
$ brew install acme parallel mach-kernel-cadius exomizer
```

Now you're ready to build Wizard Replay:

``` shell
$ git clone https://github.com/a2-4am/wizard-replay.git
$ cd wizard-replay/
$ make
```

If all goes well, the `build/` subdirectory will contain a `wizard-replay.hdv` image which can be mounted in emulators like [OpenEmulator](https://archive.org/details/OpenEmulatorSnapshots), [Ample](https://github.com/ksherlock/ample), or [Virtual II](http://virtualii.com/).

If all does not go well, try doing a clean build (`make clean && make`)

If that fails, please [file a bug](https://github.com/a2-4am/wizard-replay/issues/new).

## Windows

You will need
 - [ACME](https://sourceforge.net/projects/acme-crossass/)
 - [Cadius for Windows](https://www.brutaldeluxe.fr/products/crossdevtools/cadius/)
 - [Exomizer](https://bitbucket.org/magli143/exomizer/wiki/Home)

(Those tools will need to be added to your command-line PATH.)

Now you're ready to build Wizard Replay. Open `CMD.EXE` and enter the following:

```
C:\> cd wizard-replay
C:\wizard-replay> winmake dsk
```
If all goes well, the `build\` subdirectory will contain a `wizard-replay.hdv` image which can be mounted in emulators like [AppleWin](https://github.com/AppleWin/AppleWin) or [MAME](http://www.mamedev.org).

If all does not go well, try doing a clean build (`winmake clean`, `winmake dsk`)

If that fails, please [file a bug](https://github.com/a2-4am/wizard-replay/issues/new).

## Linux

For Debian (or Ubuntu or other derivatives), you can install some of the prerequisties through `apt` by opening a terminal window and entering the following:

``` shell
$ sudo apt install acme git parallel build-essential
```

Other tools are installable via [Homebrew](https://brew.sh/). Open a terminal prompt and enter the following:

``` shell
$ brew tap lifepillar/appleii
$ brew install mach-kernel-cadius
```

Now you're ready to build Wizard Replay:

``` shell
$ git clone https://github.com/a2-4am/wizard-replay.git
$ cd wizard-replay/
$ make
```

If all goes well, the `build/` subdirectory will contain a `wizard-replay.hdv` image which can be mounted in emulators like [MAME](http://www.mamedev.org).

If all does not go well, try doing a clean build (`make clean && make`)

If that fails, please [file a bug](https://github.com/a2-4am/wizard-replay/issues/new).
