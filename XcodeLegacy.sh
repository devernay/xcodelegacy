#!/bin/sh
# XCodeLegacy.sh
#
# Author: Frederic Devernay <frederic.devernay@m4x.org>
# License: Creative Commons BY-NC-SA 2.5 http://creativecommons.org/licenses/by-nc-sa/2.5/

if [ $# != 1 ]; then
    echo "Usage: $0 buildpackages|install|cleanpackages|uninstall"
    echo "Description: Extracts / installs / cleans / uninstalls the following components from Xcode 3.2.6,"
    echo "which are not available in Xcode >= 4.2:"
    echo "- GCC 4.0 Xcode plugin"
    echo "- PPC assembler"
    echo "- GCC 4.0 and 4.2"
    echo "- Mac OS X SDK 10.4u, 10.5 and 10.6"
    exit
fi

XCODEDIR="/Developer"
PLUGINDIR="$XCODEDIR/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
GCCDIR="$XCODEDIR"
SDKDIR="$XCODEDIR"
if [ -d "$PLUGINDIR" ]; then
    echo "Info: found Xcode <= 4.2.1"
else
    PLUGINDIR="/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
    if [ ! -d "$PLUGINDIR" ]; then
	echo "Info: could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app"
    fi
    echo "Info: found Xcode >= 4.3"
    GCCDIR="/Applications/Xcode.app/Contents/Developer"
    SDKDIR="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer"
fi

case $1 in
    buildpackages)
        #######################
        # PHASE 1: PACKAGING
        #
	if [ ! -f xcode_3.2.6_and_ios_sdk_4.3.dmg ]; then
	    echo "you should download Xcode 3.2.6 from:"
	    echo " http://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=20792"
	    echo "or"
	    echo " http://adcdownload.apple.com/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg"
	    exit
	fi
        # you should download Xcode 3.2.6 from:
        # http://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=20792
	hdiutil attach xcode_3.2.6_and_ios_sdk_4.3.dmg
	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/DeveloperTools.pkg /tmp/XC3
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i)
	((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "GCC 4.0.xcplugin") |gzip -c > XcodePluginGCC40.tar.gz) && echo "created XcodePluginGCC40.tar.gz in directory "`pwd`
        # should be untarred in /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins
        # gzip -dc XcodePluginGCC40.tar.gz | (cd /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; sudo tar xvf -)

	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/DeveloperToolsCLI.pkg /tmp/XC3
	
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i --quiet)
	((cd /tmp/XC3; tar cf - usr/libexec/gcc/darwin/ppc usr/libexec/gcc/darwin/ppc64) |gzip -c > XcodePPCas.tar.gz) ||  echo "created XcodePPCas.tar.gz in directory "`pwd`

	(cp /Volumes/Xcode\ and\ iOS\ SDK/Packages/gcc4.0.pkg  xcode_3.2.6_gcc4.0.pkg) && echo "created xcode_3.2.6_gcc4.0.pkg in directory "`pwd`
	(cp /Volumes/Xcode\ and\ iOS\ SDK/Packages/gcc4.2.pkg  xcode_3.2.6_gcc4.2.pkg) && echo "created xcode_3.2.6_gcc4.2.pkg in directory "`pwd`

	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.4.Universal.pkg /tmp/XC3
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i)
        # should we install more than these? (fixed includes?)
	((cd /tmp/XC3; tar cf - SDKs/MacOSX10.4u.sdk) |gzip -c > Xcode104SDK.tar.gz) && echo "created Xcode104SDK.tar.gz in directory "`pwd`

	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.5.pkg /tmp/XC3
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i)
        # should we install more than these? (fixed includes?)
	((cd /tmp/XC3; tar cf - SDKs/MacOSX10.5.sdk) |gzip -c > Xcode105SDK.tar.gz) && echo "created Xcode105SDK.tar.gz in directory "`pwd`

	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.6.pkg /tmp/XC3
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i)
        # should we install more than these? (fixed includes?)
	((cd /tmp/XC3; tar cf - SDKs/MacOSX10.6.sdk) |gzip -c > Xcode106SDK.tar.gz) && echo "created Xcode106SDK.tar.gz in directory "`pwd`

	rm -rf /tmp/XC3
	;;

    install)
        #######################
        # PHASE 2: INSTALLING
        #
	if [ ! -d "$PLUGINDIR" ]; then
	    echo "Error: could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app, cannot install"
	    exit
	fi
	if [ -d "$PLUGINDIR/GCC 4.0.xcplugin" ]; then
	    echo "not installing XcodePluginGCC40.tar.gz (found installed in $PLUGINDIR/GCC 4.0.xcplugin, uninstall first to force install)"
	else
	    (gzip -dc XcodePluginGCC40.tar.gz | (cd "$PLUGINDIR"; sudo tar xf -)) && echo "installed XcodePluginGCC40.tar.gz"
	fi

	if [ -f "$GCCDIR/usr/libexec/gcc/darwin/ppc/as" ]; then
	    echo "not installing XcodePPCas.tar.gz (found installed in $GCCDIR/usr/libexec/gcc/darwin/ppc/as, uninstall first to force install)"
	else
	    (gzip -dc XcodePPCas.tar.gz | (cd "$GCCDIR"; sudo tar xf -)) && echo "installed XcodePPCas.tar.gz"
	fi
	for v in 4.0 4.2; do
	    for i in c++ cpp g++ gcc gcov; do
		if [ ! -f "$GCCDIR"/usr/bin/${i}-${v} ]; then
		    sudo ln -sf /usr/bin/${i}-${v} "$GCCDIR"/usr/bin/${i}-${v}
		fi
	    done
	done

	if [ -d "$SDKDIR/SDKs/MacOSX10.4u.sdk" ]; then
	    echo "not installing Xcode104SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.4u.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode104SDK.tar.gz | (cd "$SDKDIR"; sudo tar xf -)) && echo "installed Xcode104SDK.tar.gz"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.5.sdk" ]; then
	    echo "not installing Xcode105SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.5.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode105SDK.tar.gz | (cd "$SDKDIR"; sudo tar xf -)) && echo "installed Xcode105SDK.tar.gz"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.6.sdk" ]; then
	    echo "not installing Xcode106SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.6.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode106SDK.tar.gz | (cd "$SDKDIR"; sudo tar xf -)) && echo "installed Xcode106SDK.tar.gz"
	fi

	if [ -f /usr/bin/gcc-4.0 ]; then
	    echo "not installing xcode_3.2.6_gcc4.0.pkg (found installed in /usr/bin/gcc-4.0, uninstall first to force install)"
	else
	    echo "Installing GCC 4.0"
	    sudo installer -pkg xcode_3.2.6_gcc4.0.pkg -target /
	fi
	if [ -f /usr/bin/gcc-4.2 ]; then
	    echo "not installing xcode_3.2.6_gcc4.2.pkg (found installed in /usr/bin/gcc-4.2, uninstall first to force install)"
	else
	    echo "Installing GCC 4.2"
	    sudo installer -pkg xcode_3.2.6_gcc4.2.pkg -target /
	fi
	;;

    cleanpackages)
        #######################
        # PHASE 3: CLEANING
        #

	rm XcodePluginGCC40.tar.gz XcodePPCas.tar.gz xcode_3.2.6_gcc4.0.pkg xcode_3.2.6_gcc4.2.pkg Xcode104SDK.tar.gz Xcode105SDK.tar.gz Xcode106SDK.tar.gz

	;;

    uninstall)
        #######################
        # PHASE 4: UNINSTALLING
        #

	sudo rm -rf "$PLUGINDIR/GCC 4.0.xcplugin"
	sudo rm -rf "$GCCDIR/usr/libexec/gcc/darwin/ppc" "$GCCDIR/usr/libexec/gcc/darwin/ppc64"
	sudo rm -rf "$GCCDIR/usr/bin/*4.0" "$GCCDIR/usr/lib/gcc/i686-apple-darwin10" "$GCCDIR/usr/lib/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/i686-apple-darwin10"
	sudo rm -rf "$SDKDIR/SDKs/MacOSX10.4u.sdk"
	sudo rm -rf "$SDKDIR/SDKs/MacOSX10.5u.sdk"
	;;

esac
