XcodeLegacy [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/devernay/xcodelegacy/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
===========

Legacy components for XCode 4/5/6 (deprecated compilers and Mac OS X SDKs).

Home page: http://devernay.free.fr/hacks/xcodelegacy

Description
-----------

Many components were removed in recent versions of Xcode, the most notable being the Mac OS X 10.6 SDK, which is required to build software using the Carbon API (such as wxWidgets 2.8).

I made the script XcodeLegacy.sh to extract these components from [Xcode 3.2.6](http://adcdownload.apple.com/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg), [Xcode 4.6.3](http://adcdownload.apple.com/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg), [Xcode 5.1.1](http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg) and install them in Xcode 4/5/6:

- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 compilers
- GCC 4.0, GCC 4.2 and LLVM GCC 4.2 Xcode plugins
- PPC assembler
- Mac OS X SDK 10.4u, 10.5, 10.6, 10.7, 10.8

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

License
-------
This script is distributed under the [Creative Commons BY-NC-SA 3.0 license](http://creativecommons.org/licenses/by-nc-sa/3.0/).

History
-------
- 1.0 (08/10/2012): First public version, supports Xcode up to version 4.6.3
- 1.1 (20/09/2013): Xcode 5 removed llvm-gcc and 10.7 SDK support, grab them from Xcode 3.2.6 and 4.6.3
- 1.2 (07/10/2014): Xcode 6 removed 10.8 SDK, grab it from Xcode 5.1.1
