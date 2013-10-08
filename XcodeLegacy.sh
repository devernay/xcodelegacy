#!/bin/sh -x

if [ ! -f xcode_4.1_for_lion.dmg ]; then
  echo "you should download Xcode 4.1 from:"
  echo " http://adcdownload.apple.com/Developer_Tools/xcode_4.1_for_lion/xcode_4.1_for_lion.dmg"
  exit
fi

#######################
# PHASE 1: PACKAGING
#
hdiutil attach xcode_4.1_for_lion.dmg
pkgutil --expand /Volumes/Install\ Xcode/InstallXcodeLion.pkg /tmp/XC41
(cd /tmp/XC41/InstallXcodeLion.pkg;cpio -i< Payload )

pkgutil --expand /tmp/XC41/InstallXcodeLion.pkg/Applications/Install\ Xcode.app/Contents/Resources/Packages/XcodeTools.pkg /tmp/XC41tools
(cd /tmp/XC41tools; gzip -dc Payload |cpio -i)
echo "creating XcodePluginGCC42.tar.gz in directory "`pwd`
(cd /tmp/XC41tools/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; tar cvf - "GCC 4.2.xcplugin") |gzip -c > XcodePluginGCC42.tar.gz
# should be untarred in /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins
# gzip -dc XcodePluginGCC42.tar.gz | (cd "/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"; sudo tar xvf -)
rm -rf /tmp/XC41tools

pkgutil --expand /tmp/XC41/InstallXcodeLion.pkg/Applications/Install\ Xcode.app/Contents/Resources/Packages/gcc4.2.pkg /tmp/XC41gcc42
(cd /tmp/XC41gcc42; gzip -dc Payload |cpio -i)
echo "creating XcodeGCC42.tar.gz in directory "`pwd`
(cd /tmp/XC41gcc42; tar cvf - "usr") |gzip -c > XcodeGCC42.tar.gz
# should be untarred in /
rm -rf /tmp/XC41gcc42

rm -rf /tmp/XC41

exit

#######################
# PHASE 2: INSTALLING
#
XCODEDIR="/Developer"
PLUGINDIR="$XCODEDIR/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
GCCDIR="$XCODEDIR"
SDKDIR="$XCODEDIR"
if [ -d "$PLUGINDIR" ]; then
  echo "found Xcode <= 4.2.1"
else
  PLUGINDIR="/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
  if [ ! -d "$PLUGINDIR" ]; then
    echo "could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app"
  fi
  echo "found Xcode >= 4.3"
  GCCDIR="/Applications/Xcode.app/Contents/Developer"
  SDKDIR="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer"
fi
## gcc 4.2 plugin is still available, but disabled.
echo 'edit "/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/GCC 4.2.xcplugin/Contents/Resources/GCC 4.2.xcspec"'
echo 'and change ShowInCompilerSelectionPopup to "YES" and IsNoLongerSupported to "NO"'

#gzip -dc XcodePluginGCC42.tar.gz | (cd "$PLUGINDIR"; sudo tar xvf -)
gzip -dc XcodeGCC42.tar.gz | (cd "$GCCDIR"; sudo tar xvf -)

exit
#######################
# PHASE 3: CLEANING
#

rm XcodePluginGCC42.tar.gz  XcodeGCC42.tar.gz 

exit

#######################
# PHASE 4: UNINSTALLING
#

sudo rm -rf "$PLUGINDIR/GCC 4.0.xcplugin"
sudo rm -rf "$GCCDIR/usr/libexec/gcc/darwin/ppc" "$GCCDIR/usr/libexec/gcc/darwin/ppc64"
sudo rm -rf "$GCCDIR/usr/bin/*4.0" "$GCCDIR/usr/lib/gcc/i686-apple-darwin10" "$GCCDIR/usr/lib/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/i686-apple-darwin10"
sudo rm -rf "$SDKDIR/SDKs/MacOSX10.4u.sdk"
sudo rm -rf "$SDKDIR/SDKs/MacOSX10.5u.sdk"

# TODO: retrieve gcc 4.2 and GCC 4.2 plugin/usr/bin/i686-apple-darwin11-gcc-4.2.1 from Xcode 4.2.1