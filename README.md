XcodeLegacy
===========

Legacy components for XCode 4-8 (deprecated compilers and Mac OS X SDKs).

Home page: https://github.com/devernay/xcodelegacy

Description
-----------

Many components were removed in recent versions of Xcode, the most notable being the Mac OS X 10.6 SDK, which is required to build software using the Carbon API (such as wxWidgets 2.8).

I made the script XcodeLegacy.sh to extract these components (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first) from [Xcode 3.2.6](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) (10.4, 10.5 and 10.6 SDKs, PPC assembler, GCC 4.0 and 4.2, LLVM-GCC 4.2), [Xcode 4.6.3](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg) (10.7 SDK), [Xcode 5.1.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg) (10.8 SDK), [Xcode 6.4](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_6.4/Xcode_6.4.dmg) (10.9 and 10.10 SDKs), [Xcode 7.3.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg) (10.11 SDK) and install them in Xcode 4-8:

- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 compilers
- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 Xcode plugins
- PPC assembler
- Mac OS X SDK 10.4u, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10, 10.11

The script also fixes a few known bugs in the 10.4 and 10.5 SDK.

Note: There may be similar tips to compile for older iOS (not Mac OS X) versions, but I don't develop for iOS. However, if you want to enhace the XcodeLegacy script to also include those components, I'll gladly integrate your modifications.

Download
--------
[XcodeLegacy.sh](https://raw.githubusercontent.com/devernay/xcodelegacy/master/XcodeLegacy.sh) (previous versions: [1.0](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.0.sh), [1.1](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.1.sh), [1.2](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.2.sh),  [1.3](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.3.sh), [1.4](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.4/XcodeLegacy.sh),  [1.5](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.5/XcodeLegacy.sh), [1.6](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.6/XcodeLegacy.sh),  [1.7](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.7/XcodeLegacy.sh), [1.8](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.8/XcodeLegacy.sh), [1.9](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.9/XcodeLegacy.sh), [2.0](https://raw.githubusercontent.com/devernay/xcodelegacy/v2.0/XcodeLegacy.sh))

[GitHub repository](https://github.com/devernay/xcodelegacy)

Usage
-----

Open a Terminal application, change to the directory where `XcodeLegacy.sh`, and make it executable, as in:
```
cd path/to/xcodelegacy
chmod +x XcodeLegacy.sh
```
Execute the script by typing `./XcodeLegacy.sh <arg>`. The script takes one argument, which can be "buildpackages" (to extract components from the legacy Xcode downloads to the current directory), "install" (to install the components in Xcode 4-8), "cleanpackages" (to delete the extracted components from the current directory), "uninstall" (to uninstall the components from Xcode 4-8).

With the "install" or "uninstall" arguments, the script uses sudo to become root, and will thus ask for your password. Please check the script contents before executing it.

Optionally, one of the following options can be passed as the *first* argument to `XcodeLegacy.sh`, to limit its operation:

* `-compilers` : only install the gcc and llvm-gcc compilers, as well as the corresponding Xcode plugins
* `-osx104` : only install Mac OSX 10.4 SDK
* `-osx105` : only install Mac OSX 10.5 SDK
* `-osx106` : only install Mac OSX 10.6 SDK
* `-osx107` : only install Mac OSX 10.7 SDK
* `-osx108` : only install OSX 10.8 SDK
* `-osx109` : only install OSX 10.9 SDK
* `-osx1010` : only install OSX 10.10 SDK
* `-osx1011` : only install OSX 10.11 SDK


Using the older SDKs
--------------------

To use any of the older SDKs, you should:

- compile and link with the options `-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk`
- set the environment variable `MACOSX_DEPLOYMENT_TARGET` to the proper value (e.g. 10.5) and also set `SDKROOT` to the location of the SDK - these should be redundant with the `-mmacosx-version-min` and `-isysroot` compiler options, but older compilers do not seem to pass this option to the linker.

For example:
```
env MACOSX_DEPLOYMENT_TARGET=10.6 SDKROOT=/Developer/SDKs/MacOSX10.6.sdk clang -arch i386 -arch x86_64 -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk main.c -o main
```

Using the older compilers 
-------------------------

Links to the compilers are installed in `/usr/bin` (or `/usr/local/bin` on OS X 10.11 El Capitan and later): `gcc-4.0` `g++-4.0` `gcc-4.2` `g++-4.2` `llvm-cpp-4.2` `llvm-g++-4.2` `llvm-gcc-4.2`.

GCC 4.0, GCC 4.2 and LLVM GCC 4.2 cannot compile for OS X 10.10 or newer.

The script also fixes the Mac OS X 10.4 SDK so that it works with GCC 4.2 and LLVM GCC 4.2, and later compilers (officially, it only supports GCC 4.0).

PowerPC architectures (ppc, ppc7400, ppc970, ppc64) cannot be linked for OS X 10.7 or newer (they would be useless anyway, since PowerPC CPUs were only supported up to 10.5).


Note on Xcode versions
----------------------

Here are the latest versions of Xcode that are known to /run/ on each OS X version (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first):

- [Xcode 2.5](http://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_2.5_developer_tools/xcode25_8m2558_developerdvd.dmg) on Mac OS X 10.4 (Tiger)
- [Xcode 3.1.4](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.1.4_developer_tools/xcode314_2809_developerdvd.dmg) on Mac OS X 10.5 (Leopard)
- [Xcode 3.2.6](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) on Mac OS X 10.6 (Snow Leopard) - [Xcode 4.0.2](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.0.2_and_ios_sdk_4.3/xcode_4.0.2_and_ios_sdk_4.3.dmg), [Xcode 4.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.1_for_snow_leopard_21110/xcode_4.1_for_snow_leopard.dmg) and [Xcode 4.2](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.2_with_ios_5_sdk/xcode_4.2_and_ios_5_sdk_for_snow_leopard.dmg) also run on Snow Leopard, but are only available to pay members 
- [Xcode 4.6.3](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg) on OS X 10.7 (Lion)
- [Xcode 5.1.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg) on OS X 10.8 (Mountain Lion)
- [Xcode 6.2](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_6.2/Xcode_6.2.dmg) on OS X 10.9 (Mavericks)
- [Xcode 7.2.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.2.1/Xcode_7.2.1.dmg) on OS X 10.10 (Yosemite)
- [Xcode 7.3.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg) on OS X 10.11 (El Capitan), please see note on linking below. [Xcode 8.2.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_8.2.1/Xcode_8.2.1.xip) also runs on OS X 10.11, but can only compile for macOS 10.12.
- [Xcode 8.3.3](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_8.3.3/Xcode8.3.3.xip) on macOS 10.12 (Sierra), please see note on linking below.

More information about the compilers included in each version of Xcode can be found on the [MacPorts Wiki](https://trac.macports.org/wiki/XcodeVersionInfo).

### Linking for x86_64 on Xcode 4.4 and later

If targetting 10.6, the following error may appear:
```
 For architecture x86_64: Undefinedsymbols

 "_objc_retain", from: referenced

     In libarclite_macosx.a ___ARCLite__load (arclite.o)

    (youmeant: _objc_retainedObject maybe)

Symbol not (s) found for architecture x86_64 ld:

Error: linker command failed with exit code use 1 (-v to seeinvocation clang:)
```

Solution: in the Build Setting of the Project (not for the Target), set the setting "Implicitly Link Objective-C Runtime Support" to NO.

### Linking for ppc on Xcode 7.3 and later

Recent versions of Xcode and ld added several options. These should already be taken care of by the stub ld script (notably `-object_path_lto xxx`, `-no_deduplicate`, `-dependency_info xxx`), but after an Xcode upgrade new errors may appear that are not yet handled by XcodeLegacy, like:

```
Running ld for ppc ...
ld: unknown option: -object_path_lto
```

There are two possible solutions:

- check in the file `/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/CoreBuildTasks.xcplugin/Contents/Resources/Ld.xcspec` if there is an Xcode setting to disable that option (`LD_LTO_OBJECT_FILE` in the above case)
- edit `/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld` to prune the culprid option (and its argument if there is one).


Known bugs (and fixes) in OS X SDKs
-----------------------------------

### Recent GCC versions cannot build universal binaries

The GCC in Apple SDK is actually a small binary that lauches several compilers and merges the results (see [driverdriver.c](http://opensource.apple.com/source/gcc/gcc-5666.3/driverdriver.c)). The same executable can be compiled for recent GCC versions too, see [devernay/macportsGCCfixup](https://github.com/devernay/macportsGCCfixup) on github, resulting in a GCC executable that can be given several architectures on the same command-line.

### bad_typeid dyld Error on Leopard (10.5)

This is a bug in the 10.6 (and later) SDKs, which can be easily fixed:

- http://lists.apple.com/archives/xcode-users/2010/May/msg00183.html
- http://stackoverflow.com/questions/12980931/how-to-ignore-out-of-line-definition-error-in-xcode-with-llvm-4-1

### code compiled with g++ > 4.2.1 crashes with "pointer being freed not allocated"

The problem comes from the fact that some system frameworks load the system libstdc++, which results in incompatible data structures.

After exploring various options (`install_name_tool`, rpath, etc.), the only solution is to set the environment variable `DYLD_LIBRARY_PATH` to the path of a directory where you *only* put a symbolic link to the newest libstdc++ from GCC (libstdc++ is guaranteed to be backward-compatible, not other libraries).

If you are building an application bundle, you should replace your executable by a small executable that sets the environment variable `DYLD_LIBRARY_PATH`. It can be a script (see below), or a binary (better, because it handles spaces in arguments correctly).

The [`setdyld_lib_path.c`](setdyld_lib_path.c) source code can be compiled to act as a "launcher" for your binary that correctly sets the `DYLD_LIBRARY_PATH` variable. See the full instructions at the top of the source file.

An alternate solution, using a shell-script (doesn't handle spaces in arguments): http://devblog.rarebyte.com/?p=157

Other references:

- http://stackoverflow.com/questions/6365772/unable-to-run-an-application-compiled-on-os-x-snow-leopard-10-6-7-on-another-m
- http://stackoverflow.com/questions/4697859/mac-os-x-and-static-boost-libs-stdstring-fail

License
-------
This script is distributed under the [Creative Commons BY-NC-SA 3.0 license](http://creativecommons.org/licenses/by-nc-sa/3.0/).

History
-------
- 1.0 (08/10/2012): First public version, supports Xcode up to version 4.6.3
- 1.1 (20/09/2013): Xcode 5 removed llvm-gcc and 10.7 SDK support, grab them from Xcode 3 and 4
- 1.2 (03/02/2014): Xcode 5 broke PPC assembly and linking; fix assembly and grab linker from Xcode 3
- 1.3 (07/10/2014): Xcode 6 removed 10.8 SDK, grab it from Xcode 5.1.1
- 1.4 (21/08/2015): Xcode 7 removed 10.9 and 10.10 SDKs, grab them from Xcode 6.4 
- 1.5 (15/10/2015): Fixes for OS X 10.11 El Capitan (nothing can be installed in /usr/bin because of the sandbox) 
- 1.6 (11/11/2015): Fix buildpackages, fix /usr/bin/gcc on recent OS X, fix download messages
- 1.7 (05/04/2016): Xcode 7.3 disables support for older SDKs, fix that
- 1.9 (16/09/2016): Xcode 8 dropped 10.11 SDK, get it from Xcode 7.3.1
- 2.0 (02/05/2017): Xcode 8 cannot always link i386 for OS X 10.5, use the Xcode 3 linker for this arch too. Force use of legacy assembler with GCC 4.x.
