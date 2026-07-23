XcodeLegacy
===========

Legacy components for Xcode 4-16 (deprecated compilers and Mac OS X / macOS SDKs).

Home page: https://github.com/devernay/xcodelegacy

Description
-----------

Many components were removed in recent versions of Xcode, the most notable being the Mac OS X 10.6 SDK, which is required to build software using the Carbon API (such as wxWidgets 2.8).

I made the script XcodeLegacy.sh to extract these components (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first) from
[Xcode 3.2.6](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) (10.4, 10.5 and 10.6 SDKs, PPC assembler, GCC 4.0 and 4.2, LLVM-GCC 4.2),
[Xcode 4.6.3](https://download.developer.apple.com/Developer_Tools/xcode_4.6.3/Xcode_4.6.3.dmg) (10.7 SDK),
[Xcode 5.1.1](https://download.developer.apple.com/Developer_Tools/xcode_5.1.1/Xcode_5.1.1.dmg) (10.8 SDK),
[Xcode 6.4](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_6.4/Xcode_6.4.dmg) (10.9 and 10.10 SDKs),
[Xcode 7.3.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg) (10.11 SDK),
[Xcode 8.3.3](https://download.developer.apple.com/Developer_Tools/Xcode_8.3.3/Xcode8.3.3.xip) (10.12 SDK),
[Xcode 9.4.1](https://download.developer.apple.com/Developer_Tools/Xcode_9.4.1/Xcode_9.4.1.xip) (10.13 SDK),
[Xcode 10.3](https://download.developer.apple.com/Developer_Tools/Xcode_10.3/Xcode_10.3.xip) (10.14 SDK)
[Xcode 11.7](https://download.developer.apple.com/Developer_Tools/Xcode_11.7/Xcode_11.7.xip) (10.15 SDK),
[Xcode 12.5.1](https://download.developer.apple.com/Developer_Tools/Xcode_12.5.1/Xcode_12.5.1.xip) (macOS 11 SDK),
[Xcode 13.4.1](https://download.developer.apple.com/Developer_Tools/Xcode_13.4.1/Xcode_13.4.1.xip) (macOS 12 SDK),
[Xcode 14.3.1](https://download.developer.apple.com/Developer_Tools/Xcode_14.3.1/Xcode_14.3.1.xip) (macOS 13 SDK),
[Xcode 15.4](https://download.developer.apple.com/Developer_Tools/Xcode_15.4/Xcode_15.4.xip) (macOS 14 SDK) and
[Xcode 16.4](https://download.developer.apple.com/Developer_Tools/Xcode_16.4/Xcode_16.4.xip) (macOS 15 SDK)
and install them in Xcode 4-16:

- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 compilers
- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 Xcode plugins
- PPC assembler
- Mac OS X / macOS SDK 10.4u, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10, 10.11, 10.12, 10.13, 10.14, 10.15, 11, 12, 13, 14, 15

The script also fixes a few known bugs in the 10.4, 10.5 and 10.6 SDK.

Note: There may be similar tips to compile for older iOS (not Mac OS X) versions, but I don't develop for iOS. However, if you want to enhance the XcodeLegacy script to also include those components, I'll gladly integrate your modifications.

Download
--------
[XcodeLegacy.sh](https://raw.githubusercontent.com/devernay/xcodelegacy/master/XcodeLegacy.sh) (previous versions: [1.0](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.0.sh), [1.1](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.1.sh), [1.2](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.2.sh),  [1.3](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.3.sh), [1.4](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.4/XcodeLegacy.sh),  [1.5](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.5/XcodeLegacy.sh), [1.6](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.6/XcodeLegacy.sh),  [1.7](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.7/XcodeLegacy.sh), [1.8](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.8/XcodeLegacy.sh), [1.9](https://raw.githubusercontent.com/devernay/xcodelegacy/v1.9/XcodeLegacy.sh), [2.0](https://raw.githubusercontent.com/devernay/xcodelegacy/v2.0/XcodeLegacy.sh), [2.1](https://raw.githubusercontent.com/devernay/xcodelegacy/v2.1/XcodeLegacy.sh), [2.2](https://raw.githubusercontent.com/devernay/xcodelegacy/v2.2/XcodeLegacy.sh))

[GitHub repository](https://github.com/devernay/xcodelegacy)

Usage
-----

Open a Terminal application, change to the directory where `XcodeLegacy.sh`, and make it executable, as in:
```
cd path/to/xcodelegacy
chmod +x XcodeLegacy.sh
```
Execute the script by typing `./XcodeLegacy.sh <arg>`. The script takes one argument, which can be "buildpackages" (to extract components from the legacy Xcode downloads to the current directory), "install" (to install the components in Xcode 4-16), "cleanpackages" (to delete the extracted components from the current directory), "uninstall" (to uninstall the components from Xcode 4-16).

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
* `-osx1012` : only install OSX 10.12 SDK
* `-osx1013` : only install OSX 10.13 SDK
* `-osx1014` : only install OSX 10.14 SDK
* `-osx1015` : only install OSX 10.15 SDK
* `-osx11` : only install macOS 11 (Big Sur) SDK
* `-osx12` : only install macOS 12 (Monterey) SDK
* `-osx13` : only install macOS 13 (Ventura) SDK
* `-osx14` : only install macOS 14 (Sonoma) SDK
* `-osx15` : only install macOS 15 (Sequoia) SDK
* `-path=path` : install to custom Xcode at 'path'


Using the older SDKs
--------------------

To use any of the older SDKs, you should:

- compile and link with the options `-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk`
- set the environment variable `MACOSX_DEPLOYMENT_TARGET` to the proper value (e.g. 10.5) and also set `SDKROOT` to the location of the SDK - these should be redundant with the `-mmacosx-version-min` and `-isysroot` compiler options, but older compilers do not seem to pass this option to the linker.

For example:
```
env MACOSX_DEPLOYMENT_TARGET=10.6 SDKROOT=/Developer/SDKs/MacOSX10.6.sdk clang -arch i386 -arch x86_64 \
  -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk main.c -o main
```

When using a Makefile-based build, similarly set the environment variables and use the compilation flags both at compile-time and at link-time (these should typically be added to the `CFLAGS` and `LDFLAGS` in the Makefile).

When using a GNU configure-based project, pass these flags to the configure script, as in:
```
./configure CFLAGS="-g -O2 -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk" \
            CXXFLAGS="-g -O2 -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk" \
            LDFLAGS="-mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk"
```

When using Xcode, set the "Base SDK" and "macOS Deployment Target" build settings of the project to the right version. Perhaps a better option is to use the command-line utility `xcodebuild` to build using these values, rather than modifying the Xcode project file itself, as in:
```
xcodebuild MACOSX_DEPLOYMENT_TARGET=10.6 SDKROOT=macosx10.6 GCC_VERSION=4.2 CLANG_CXX_LIBRARY=libstdc++ \
 ARCHS="ppc7400 ppc64 i386 x86_64"
```
Useful values for `GCC_VERSION` are `4.0`, `4.2`, `com.apple.compilers.llvmgcc42`, `com.apple.compilers.llvm.clang.1_0`. You can use GCC 4.2 or LLVM GCC 4.2 with the 10.4 SDK by passing the `CC` and `CXX` options too, as in `GCC_VERSION=4.0 CC=gcc-4.2 CXX=g++-4.2`.

Valid archs are `ppc`, `ppc7400` (PowerPC G4, minimum CPU requirement to run 10.5), `ppc7450`, `ppc970` (PowerPC G5 32-bit), `ppc64`, `i386`, `x86_64` (minimum CPU requirement to run 10.7). The `dsymutil` utility provided with Xcode 7 and later does not work on PPC binaries, so if the `GenerateDSYMFile` phase fails, just pass the additional option `DEBUG_INFORMATION_FORMAT=dwarf` to `xcodebuild`.

Using the older compilers 
-------------------------

Links to the compilers are installed in `/usr/bin` (or `/usr/local/bin` on OS X 10.11 El Capitan and later): `gcc-4.0` `g++-4.0` `gcc-4.2` `g++-4.2` `llvm-cpp-4.2` `llvm-g++-4.2` `llvm-gcc-4.2`.

GCC 4.0, GCC 4.2 and LLVM GCC 4.2 cannot compile for OS X 10.10 or newer.

The script also fixes the Mac OS X 10.4 SDK so that it works with GCC 4.2 and LLVM GCC 4.2, and later compilers (officially, it only supports GCC 4.0).

PowerPC architectures (ppc, ppc7400, ppc970, ppc64) cannot be linked for OS X 10.7 or newer (they would be useless anyway, since PowerPC CPUs were only supported up to 10.5).


Note on Xcode versions
----------------------

Here are the latest versions of Xcode that are known to /run/ on each OS X version (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first):

- [Xcode 2.5](http://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_2.5_developer_tools/xcode25_8m2558_developerdvd.dmg) on Mac OS X 10.4 (Tiger) (\*)
- [Xcode 3.1.4](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.1.4_developer_tools/xcode314_2809_developerdvd.dmg) on Mac OS X 10.5 (Leopard) (\*)
- [Xcode 3.2.6](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) on Mac OS X 10.6 (Snow Leopard) - [Xcode 4.0.2](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.0.2_and_ios_sdk_4.3/xcode_4.0.2_and_ios_sdk_4.3.dmg), [Xcode 4.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/xcode_4.1_for_snow_leopard_21110/xcode_4.1_for_snow_leopard.dmg) and [Xcode 4.2](https://download.developer.apple.com/Developer_Tools/xcode_4.2_for_snow_leopard/xcode_4.2_for_snow_leopard.dmg) also run on Snow Leopard, but are only available to pay members (*)
- [Xcode 4.6.3](https://download.developer.apple.com/Developer_Tools/xcode_4.6.3/Xcode_4.6.3.dmg) on OS X 10.7 (Lion)
- [Xcode 5.1.1](https://download.developer.apple.com/Developer_Tools/xcode_5.1.1/Xcode_5.1.1.dmg) on OS X 10.8 (Mountain Lion)
- [Xcode 6.2](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_6.2/Xcode_6.2.dmg) on OS X 10.9 (Mavericks)
- [Xcode 7.2.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.2.1/Xcode_7.2.1.dmg) on OS X 10.10 (Yosemite)
- [Xcode 7.3.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg) on OS X 10.11 (El Capitan), please see note on linking below. [Xcode 8.2.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_8.2.1/Xcode_8.2.1.xip) (**) also runs on OS X 10.11, but can only compile for macOS 10.12.
- [Xcode 8.3.3](https://download.developer.apple.com/Developer_Tools/Xcode_8.3.3/Xcode_8.3.3.xip) on macOS 10.12 (Sierra), please see note on linking below. (\*\*)
- [Xcode 9.4.1](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_9.4.1/Xcode_9.4.1.xip) on macOS 10.13 (High Sierra), please see note on linking below. (\*\*)
- [Xcode 10.3](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_10.3/Xcode_10.3.xip) on macOS 10.14 (Mojave), please see note on linking below.
- [Xcode 11.7](https://developer.apple.com/devcenter/download.action?path=/Developer_Tools/Xcode_11.7/Xcode_11.7.xip) on macOS 10.15 (Catalina).
- [Xcode 12.5.1](https://download.developer.apple.com/Developer_Tools/Xcode_12.5.1/Xcode_12.5.1.xip) on macOS 11 (Big Sur) -- first Xcode line with native Apple Silicon (arm64) support (since Xcode 12.2).
- [Xcode 13.4.1](https://download.developer.apple.com/Developer_Tools/Xcode_13.4.1/Xcode_13.4.1.xip) on macOS 12 (Monterey).
- [Xcode 14.3.1](https://download.developer.apple.com/Developer_Tools/Xcode_14.3.1/Xcode_14.3.1.xip) on macOS 13 (Ventura).
- [Xcode 15.4](https://download.developer.apple.com/Developer_Tools/Xcode_15.4/Xcode_15.4.xip) on macOS 14 (Sonoma).
- [Xcode 16.4](https://download.developer.apple.com/Developer_Tools/Xcode_16.4/Xcode_16.4.xip) on macOS 15 (Sequoia).

Xcode 12.4 and earlier require macOS 10.15.4 or older and are `x86_64`-only, so they **cannot run on Apple Silicon** (which needs macOS 11+); see the Apple Silicon section below.

(\*) These Xcode versions were released before 26.03.2012 and may cause an "An unknown installation error" during installation, which is due to an expired certificate. Installing these may require disabling network time sync and setting the date to 01.01.2012 before installing. Network time sync may be re-enabled after install. See [this stackexchange question](https://apple.stackexchange.com/questions/45841/xcode-4-2-snow-leopard-doesnt-install) for more details.

(\*\*) If you downloaded these Xcode versions (8.2.1, 8.3.3, 9.4.1) before 24th October 2019 the certificate used to sign them has expired and Archive Utility will refuse to unpack them. See [this TidBITS article](https://tidbits.com/2019/10/28/redownload-archived-macos-installers-to-address-expired-certificates/) which describes the same problem in OS installers for more details. XcodeLagacy now checks for this problem and prompts you to re-download the archives which now have updated signatures.

More information about the compilers included in each version of Xcode can be found on the [MacPorts Wiki](https://trac.macports.org/wiki/XcodeVersionInfo) and on [Wikipedia](https://en.wikipedia.org/wiki/Xcode).

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


Apple Silicon (arm64) support and caveats
-----------------------------------------

The situation on Apple Silicon (M1/M2/M3/... Macs) is fundamentally different from Intel Macs. Read this before expecting the legacy compilers or the 10.x SDKs to work.

### Which Xcode runs on Apple Silicon

- Apple Silicon Macs can only boot **macOS 11 Big Sur or newer**. Any Xcode that requires macOS 10.15 or older (i.e. Xcode 3.x-12.4) therefore **cannot run at all** on an Apple Silicon Mac, regardless of Rosetta -- the operating system it needs will not run on the hardware.
- **Xcode 12.2 was the first version with native `arm64` (Apple Silicon) support**, shipping as a universal binary. Xcode 12.5.1 and later require macOS 11+. In practice, on Apple Silicon you run Xcode 12.2+ natively; there is no need (and no way) to run the very old IDEs.
- Rosetta 2 can translate `x86_64` code, so an `x86_64`-only tool can run translated -- but **Rosetta 2 does not translate `i386` (32-bit Intel) or PowerPC**. It also cannot help with a macOS version that will not boot.

### The legacy GCC/LLVM-GCC compilers and PPC assembler/linker do NOT work on Apple Silicon

The `-compilers` component extracts GCC 4.0/4.2, LLVM-GCC 4.2 and the PPC assembler/linker from Xcode 3.2.6 (2011). These binaries and the code they target are `i386`/`x86_64`/PPC only. Because Apple Silicon cannot run `i386` or PPC -- and cannot run the old macOS these tools were built for -- **these compilers are only useful on an Intel Mac** running a macOS old enough to also host an Xcode that supports them. Do not install `-compilers` on Apple Silicon.

### The 10.x SDKs are Intel/PPC-only

The Mac OS X 10.4u-10.15 SDKs contain only `ppc`/`i386`/`x86_64` slices (no `arm64`). You can still *extract* and *install* them on Apple Silicon (see below), but you can only *build* against them for Intel/PPC targets, and the resulting Intel binaries will run under Rosetta 2 only if they are `x86_64` (never `i386`/PPC). This was verified on macOS 26 / Apple Silicon: the current toolchain has no `i386` slice in `libSystem`, so linking `-arch i386` fails, and Rosetta 2 does not execute `i386` binaries.

### The macOS 11-15 SDKs (added in 2.7) ARE usable on Apple Silicon

The macOS 11, 12, 13, 14 and 15 SDKs extracted from Xcode 12.5.1/13.4.1/14.3.1/15.4/16.4 are **universal (`arm64` + `x86_64`)**. Installing one of these into a newer Xcode lets you build against an older macOS SDK/deployment target while still producing native Apple Silicon binaries. These are the components most likely to be useful on an Apple Silicon Mac.

### `buildpackages` itself works on Apple Silicon

Extraction is architecture-independent: `hdiutil` (for the old `.dmg`) and `xip`/Archive Utility (for the `.xip` archives) run fine on Apple Silicon, so `./XcodeLegacy.sh buildpackages` can produce every SDK tarball on an Apple Silicon Mac. It is the *install* and *use* of the Intel/PPC compilers and 10.x SDKs -- not their extraction -- that is limited.

### Note on legacy Xcode download links

All the download links in this document (and in `XcodeLegacy.sh`) point to `download.developer.apple.com` and still require you to [sign in to Apple Developer](https://developer.apple.com/downloads/) first. These are the canonical URLs, cross-checked against [xcodereleases.com](https://xcodereleases.com/).

**If a download link is rejected or a download fails, look up the current URL on [xcodereleases.com](https://xcodereleases.com/)** (also available in machine-readable form at [`https://xcodereleases.com/data.json`](https://xcodereleases.com/data.json), which lists, for every release, its exact `download` URL, its bundled `macOS` SDK, and the minimum macOS required to run it). Apple occasionally changes archive names -- for example, Xcode 26 and later ship as `Xcode_<ver>_Universal.xip` and `Xcode_<ver>_Apple_silicon.xip` rather than the older single `Xcode_<ver>.xip`.

Two known blockers when installing old Xcode:

- Xcode releases from before 26.03.2012 may fail to install with "An unknown installation error" because of an expired certificate (see the note at the end of "Note on Xcode versions").
- Xcode 8.2.1, 8.3.3 and 9.4.1 archives downloaded before 24.10.2019 have an expired signature and Archive Utility will refuse to unpack them; re-download the current archives (XcodeLegacy detects this and prompts you).


Upgrading XcodeLegacy for a new Xcode / SDK version
---------------------------------------------------

Each new major Xcode drops the oldest bundled macOS SDK. XcodeLegacy's job is to grab that dropped SDK from the last Xcode that shipped it. When a new Xcode removes an SDK you still need, add support like this. The naming convention below matches the existing code.

**0. Find the mapping.** Determine which macOS SDK the new Xcode removed and which older Xcode is the last one that still bundles it. [xcodereleases.com](https://xcodereleases.com/) (also available as `https://xcodereleases.com/data.json`) lists, for every release, its bundled `macOS` SDK, its exact `download` URL, and the minimum macOS required to run it. As of Xcode 16 the mapping is:

| Source Xcode | Bundled macOS SDK | Option added |
|--------------|-------------------|--------------|
| 11.7         | 10.15             | `-osx1015`   |
| 12.5.1       | 11 (Big Sur)      | `-osx11`     |
| 13.4.1       | 12 (Monterey)     | `-osx12`     |
| 14.3.1       | 13 (Ventura)      | `-osx13`     |
| 15.4         | 14 (Sonoma)       | `-osx14`     |
| 16.4         | 15 (Sequoia)      | `-osx15`     |

So, e.g., to add the macOS 16 SDK once a future Xcode drops it, you would extract it from Xcode 16.4 (or whichever release last bundles it).

**1. Add the option flag.** In `XcodeLegacy.sh`, near the top add an initializer `osxNN=0` (use `osx11`-style names for macOS 11+, `osx10NN` for 10.x). Add a matching `-osxNN)` case in the argument-parsing `while` loop (set `osxNN=1; gotoption=1; shift`), add `osxNN=1` to the "no option given -> do everything" block, and add the option to the two usage `echo` lines and the SDK list.

**2. Add the source-Xcode gate.** Add a gate variable next to the others:
```sh
xcNN="$(( osxMM != 0 ))"
```
where `xcNN` is the *source* Xcode major version and `osxMM` is the SDK option it provides (e.g. `xc16="$(( osx15 != 0 ))"`).

**3. Add the download check** (PHASE 1, `buildpackages`), mirroring the existing blocks:
```sh
if [ "$xcNN" = 1 ] && [ ! -f Xcode_X.Y.Z.xip ]; then
    echo "*** You should download Xcode X.Y.Z ..."
    ...
    missingdmg=1
fi
```
Also add `$xcNN` to the "stray Xcode.app" guard for `.xip`-based sources.

**4. Add the extraction** (still PHASE 1). Modern Xcode ships one universal SDK reachable via the `SDKs/MacOSX.sdk` symlink; rename it to a version-stamped directory and tar it:
```sh
if [ "$xcNN" = 1 ]; then
    if [ "$osxMM" = 1 ]; then
        open Xcode_X.Y.Z.xip
        while [ ! -d Xcode.app ]; do sleep 5; done
        sleep 5
        ( (cd "Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer" || exit; \
           rm -f SDKs/MacOSXNN.sdk; mv SDKs/MacOSX.sdk SDKs/MacOSXNN.sdk; \
           tar cf - SDKs/MacOSXNN.sdk) | gzip -c > XcodeNNSDK.tar.gz )
        rm -rf Xcode.app
    fi
fi
```
The tarball name `XcodeNNSDK.tar.gz` must match what `installSDK` expects (it derives it from the SDK version with the dot removed).

**5. Add the install call** (PHASE 2, `install`): `if [ "$osxMM" = 1 ]; then installSDK NN; fi`. The shared `installSDK` helper handles the rest (skips if already installed, drops a `legacy` marker file used by uninstall).

**6. Add cleanup** (PHASE 3, `cleanpackages`): `if [ "$osxMM" = 1 ]; then rm XcodeNNSDK.tar.gz 2>/dev/null; fi`.

**7. Add uninstall** (PHASE 4, `uninstall`):
```sh
if [ "$osxMM" = 1 ]; then
    i=NN
    [ -f "$SDKDIR/SDKs/MacOSX${i}.sdk/legacy" ] && rm -rf "$SDKDIR/SDKs/MacOSX${i}.sdk"
fi
```

**8. Update docs and validate.** Update this README (intro list, options, history) and run `shellcheck XcodeLegacy.sh` and `bash -n XcodeLegacy.sh`. You can smoke-test the plumbing without downloading multi-GB archives by running the script from an empty directory: `./XcodeLegacy.sh -osxMM buildpackages` should ask for exactly the right source Xcode and then exit.

Note: SDKs shipped by Xcode 12.2+ are universal (`arm64`+`x86_64`); the 10.x SDKs from the old `.dmg`/`.xip` archives are Intel/PPC-only (see the Apple Silicon section above).


Known bugs (and fixes) in OS X SDKs
-----------------------------------

### Recent GCC versions cannot build universal binaries

The GCC in Apple SDK is actually a small binary that lauches several compilers and merges the results (see [driverdriver.c](http://opensource.apple.com/source/gcc/gcc-5666.3/driverdriver.c)). The same executable can be compiled for recent GCC versions too, see [devernay/macportsGCCfixup](https://github.com/devernay/macportsGCCfixup) on github, resulting in a GCC executable that can be given several architectures on the same command-line.

### bad_typeid dyld Error when running executable on Leopard (10.5)

This bug happens when building with the 10.6 or 10.7 SDK, but targetting 10.5. The 10.5 SDK uses `libstdc++.6.0.4.dylib` whereas later SDKs use `libstdc++.6.0.9.dylib`.

It can be fixed by adding this snippet somewhere in your code:
```
#include <AvailibilityMacros.h>
#if defined(MAC_OS_X_VERSION_10_6) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
const char* ::std::bad_typeid::what() const throw() { return NULL; }
#endif
```

References:

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
- 2.1 (17/01/2017): Xcode 9 dropped 10.12 SDK, get it from Xcode 8.3.3; fix compiling with GNU Ada, and many other fixes
- 2.2 (10/01/2019): Xcode 10 dropped 10.13 SDK, get it from Xcode 9.4.1
- 2.3 (27/03/2019): Added an option to install in a custom Xcode path
- 2.4 (10/02/2020): Fix for buildpackages if Xcode 8 or Xcode 9 xip have expired signatures. Also now check for stray Xcode.app if extracting Xcode 9.4.1, Fixes for changed download paths and archive names.
- 2.5 (31/04/2021): Xcode 11 dropped 10.14 SDK, get it from Xcode 10.3
- 2.6 (01/05/2021): Xcode 12 dropped 10.15 SDK, get it from Xcode 11.7
- 2.7 (23/07/2026): Support macOS 11-15 SDKs (from Xcode 12.5.1, 13.4.1, 14.3.1, 15.4, 16.4); add `-osx11`/`-osx12`/`-osx13`/`-osx14`/`-osx15` options; document Apple Silicon (arm64) behavior and how to upgrade the script; fix shellcheck warnings and a bug where the Xcode 4.6.3 archive named `xcode4630916281a.dmg` was not detected during buildpackages
