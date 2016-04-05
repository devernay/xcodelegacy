XcodeLegacy [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/devernay/xcodelegacy/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
===========

Legacy components for XCode 4/5/6/7 (deprecated compilers and Mac OS X SDKs).

Home page: http://devernay.free.fr/hacks/xcodelegacy

Description
-----------

Many components were removed in recent versions of Xcode, the most notable being the Mac OS X 10.6 SDK, which is required to build software using the Carbon API (such as wxWidgets 2.8).

I made the script XcodeLegacy.sh to extract these components (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first) from [Xcode 3.2.6](http://adcdownload.apple.com/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) (10.4, 10.5 and 10.6 SDKs, PPC assembler, GCC 4.0 and 4.2, LLVM-GCC 4.2), [Xcode 4.6.3](http://adcdownload.apple.com/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg) (10.7 SDK), [Xcode 5.1.1](http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg) (10.8 SDK), [Xcode 6.4](http://adcdownload.apple.com/Developer_Tools/Xcode_6.4/Xcode_6.4.dmg) (10.9 and 10.10 SDKs) and install them in Xcode 4/5/6/7:

- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 compilers
- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 Xcode plugins
- PPC assembler
- Mac OS X SDK 10.4u, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10

In order to re-enable the GCC 4.2 plugin in Xcode 4, you may also want to edit "/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/GCC 4.2.xcplugin/Contents/Resources/GCC 4.2.xcspec" and change ShowInCompilerSelectionPopup to "YES" and IsNoLongerSupported to "NO".

Note: There may be similar tips to compile for older iOS (not Mac OS X) versions, but I don't develop for iOS. However, if you want to enhace the XcodeLegacy script to also include those components, I'll gladly integrate your modifications.

Download
--------
[XcodeLegacy.sh](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy.sh) (previous versions: [1.0](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.0.sh), [1.1](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.1.sh), [1.2](http://devernay.free.fr/hacks/xcodelegacy/XcodeLegacy-1.2.sh))

[GitHub repository](https://github.com/devernay/xcodelegacy)

Usage
-----
Execute the script in a terminal. The script takes one argument, which can be "buildpackages" (to extract components from the legacy Xcode downloads to the current directory), "install" (to install the components in Xcode 4/5/6), "cleanpackages" (to delete the extracted components from the current directory), "uninstall" (to uninstall the components from Xcode 4/5/6).

With the "install" or "uninstall" arguments, the script uses sudo to become root, and will thus ask for your password. Please check the script contents before executing it.

Using the older SDKs
--------------------

To use any of the older SDKs, you should:

- compile and link with the options `-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk`
- set the environment variable `MACOSX_DEPLOYMENT_TARGET` to the proper value (e.g. 10.5) - this should be redundant with the `-mmacosx-version-min`compiler option, but older compilers do not seem to pass this option to the linker.

For example:
```
env MACOSX_DEPLOYMENT_TARGET=10.6 clang -arch i386 -arch x86_64 -mmacosx-version-min=10.6 -isysroot /Developer/SDKs/MacOSX10.6.sdk main.c -o main
```

Using the older compilers 
-------------------------

Links to the compilers are installed in `/usr/bin` (or `/usr/local/bin` on OS X 10.11 El Capitan): `gcc-4.0` `g++-4.0` `gcc-4.2` `g++-4.2` `llvm-cpp-4.2` `llvm-g++-4.2` `llvm-gcc-4.2`.

GCC 4.0, GCC 4.2 and LLVM GCC 4.2 cannot compile for OS X 10.10 or newer.

PowerPC architectures (ppc, ppc7400, ppc970, ppc64) cannot be linked for OS X 10.7 or newer.

Note on Xcode versions
----------------------

Here are the latest versions of Xcode that are known to /run/ on each OS X version (the links work if you [sign in to Apple Developer](https://developer.apple.com/downloads/) first):

- [Xcode 3.1.4](http://adcdownload.apple.com/Developer_Tools/xcode_3.1.4_developer_tools/xcode314_2809_developerdvd.dmg) on Mac OS X 10.5 (Leopard)
- [Xcode 3.2.6](http://adcdownload.apple.com/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg) on Mac OS X 10.6 (Snow Leopard) - [Xcode 4.0.2](http://adcdownload.apple.com/Developer_Tools/xcode_4.0.2_and_ios_sdk_4.3/xcode_4.0.2_and_ios_sdk_4.3.dmg), [Xcode 4.1](http://adcdownload.apple.com/Developer_Tools/xcode_4.1_for_snow_leopard_21110/xcode_4.1_for_snow_leopard.dmg) and [Xcode 4.2](http://adcdownload.apple.com/Developer_Tools/xcode_4.2_with_ios_5_sdk/xcode_4.2_and_ios_5_sdk_for_snow_leopard.dmg) also run on Snow Leopard, but are only available to pay members 
- [Xcode 4.6.3](http://adcdownload.apple.com/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg) on OS X 10.7 (Lion)
- [Xcode 5.1.1](http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg) on OS X 10.8 (Mountain Lion)
- [Xcode 6.2](http://adcdownload.apple.com/Developer_Tools/Xcode_6.2/Xcode_6.2.dmg) on OS X 10.9 (Mavericks)
- [Xcode 7.2.1](http://adcdownload.apple.com/Developer_Tools/Xcode_7.2.1/Xcode_7.2.1.dmg) on OS X 10.10 (Yosemite) and OS X 10.11 (El Capitan)

More information about the compilers included in each version of Xcode can be found on the [MacPorts Wiki](https://trac.macports.org/wiki/XcodeVersionInfo).

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
