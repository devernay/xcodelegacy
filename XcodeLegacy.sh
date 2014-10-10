#!/bin/sh
# XCodeLegacy.sh
#
# Original author: Frederic Devernay <frederic.devernay@m4x.org>
# Contributor: Garrett Walbridge <gwalbridge+xcodelegacy@gmail.com>
# License: Creative Commons BY-NC-SA 3.0 http://creativecommons.org/licenses/by-nc-sa/3.0/
#
# History:
# 1.0 (08/10/2012): First public version, supports Xcode up to version 4.6.3
# 1.1 (20/09/2013): Xcode 5 removed llvm-gcc and 10.7 SDK support, grab them from Xcode 3 and 4
# 1.2 (03/02/2014): Xcode 5 broke PPC assembly and linking; fix assembly and grab linker from Xcode 3

if [ $# != 1 ]; then
    echo "Usage: $0 buildpackages|install|cleanpackages|uninstall"
    echo "Description: Extracts / installs / cleans / uninstalls the following components from Xcode 3.2.6, Xcode 4.6.3 and Xcode 5.1.1,"
    echo "which are not available in Xcode >= 4.2:"
    echo "- GCC 4.0 Xcode plugin"
    echo "- PPC assembler and linker"
    echo "- GCC 4.0 and 4.2"
    echo "- Mac OS X SDK 10.4u, 10.5, 10.6, 10.7 and 10.8"
    echo ""
    echo "Typically, you will want to run this script with the buildpackages argument first, then the install argument, "
    echo "and lastly the cleanpackages argument, in order to properly install the legacy Xcode files."
    echo "The install and uninstall phases have to be run with administrative rights, as in:"
    echo " $ sudo $0 install"
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
	    echo "and then run this script from within the same directory as the downloaded file"
	    exit
	fi
	if [ ! -f xcode4630916281a.dmg ]; then
	    echo "you should download Xcode 4.6.3 from:"
	    echo " http://adcdownload.apple.com/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg"
	    echo "or"
	    echo " https://developer.apple.com/downloads/"
	    echo "and then run this script from within the same directory as the downloaded file"
	    exit
	fi
	if [ ! -f xcode_5.1.1.dmg ]; then
	    echo "you should download Xcode 5.1.1 from:"
	    echo " http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg"
	    echo "or"
	    echo " https://developer.apple.com/downloads/"
	    echo "and then run this script from within the same directory as the downloaded file"
	    exit
	fi
        # you should download Xcode 3.2.6 from:
        # http://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=20792
	hdiutil attach xcode_3.2.6_and_ios_sdk_4.3.dmg
	if [ ! -d /Volumes/Xcode\ and\ iOS\ SDK ]; then
	    echo "Error while trying to attach disk image xcode_3.2.6_and_ios_sdk_4.3.dmg"
	    echo "Aborting"
	    exit
	fi
	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/DeveloperTools.pkg /tmp/XC3
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i)
	((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "GCC 4.0.xcplugin") |gzip -c > XcodePluginGCC40.tar.gz) && echo "created XcodePluginGCC40.tar.gz in directory "`pwd`
	((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "GCC 4.2.xcplugin") |gzip -c > XcodePluginGCC42.tar.gz) && echo "created XcodePluginGCC42.tar.gz in directory "`pwd`
	((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "LLVM GCC 4.2.xcplugin") |gzip -c > XcodePluginLLVMGCC42.tar.gz) && echo "created XcodePluginLLVMGCC42.tar.gz in directory "`pwd`
        # should be untarred in /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins
        # gzip -dc XcodePluginGCC40.tar.gz | (cd /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; sudo tar xvf -)

	rm -rf /tmp/XC3
	pkgutil --expand /Volumes/Xcode\ and\ iOS\ SDK/Packages/DeveloperToolsCLI.pkg /tmp/XC3
	
	(cd /tmp/XC3;gzip -dc Payload  |cpio -i --quiet)
	((cd /tmp/XC3; tar cf - usr/libexec/gcc/darwin/ppc usr/libexec/gcc/darwin/ppc64) |gzip -c > XcodePPCas.tar.gz) ||  echo "created XcodePPCas.tar.gz in directory "`pwd`
	((cd /tmp/XC3; tar cf - usr/bin/ld) |gzip -c > Xcode3ld.tar.gz) ||  echo "created Xcode3ld.tar.gz in directory "`pwd`

	(cp /Volumes/Xcode\ and\ iOS\ SDK/Packages/gcc4.0.pkg  xcode_3.2.6_gcc4.0.pkg) && echo "created xcode_3.2.6_gcc4.0.pkg in directory "`pwd`
	(cp /Volumes/Xcode\ and\ iOS\ SDK/Packages/gcc4.2.pkg  xcode_3.2.6_gcc4.2.pkg) && echo "created xcode_3.2.6_gcc4.2.pkg in directory "`pwd`
	(cp /Volumes/Xcode\ and\ iOS\ SDK/Packages/llvm-gcc4.2.pkg  xcode_3.2.6_llvm-gcc4.2.pkg) && echo "created xcode_3.2.6_llvm-gcc4.2.pkg in directory "`pwd`

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
	hdiutil detach /Volumes/Xcode\ and\ iOS\ SDK

	hdiutil attach xcode4630916281a.dmg
	if [ ! -d /Volumes/Xcode ]; then
	    echo "Error while trying to attach disk image xcode4630916281a.dmg"
	    echo "Aborting"
	    exit
	fi
	((cd /Volumes/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.7.sdk) |gzip -c > Xcode107SDK.tar.gz) && echo "created Xcode107SDK.tar.gz in directory "`pwd`
	((cd /Volumes/Xcode/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; tar cf - "GCC 4.2.xcplugin") |gzip -c > XcodePluginGCC42-Xcode4.tar.gz) && echo "created XcodePluginGCC42-Xcode4.tar.gz in directory "`pwd`
	((cd /Volumes/Xcode/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; tar cf - "LLVM GCC 4.2.xcplugin") |gzip -c > XcodePluginLLVMGCC42.tar.gz) && echo "created XcodePluginLLVMGCC42.tar.gz in directory "`pwd`
	hdiutil detach /Volumes/Xcode

	hdiutil attach xcode_5.1.1.dmg
	if [ ! -d /Volumes/Xcode ]; then
	    echo "Error while trying to attach disk image xcode_5.1.1.dmg"
	    echo "Aborting"
	    exit
	fi
	((cd /Volumes/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.8.sdk) |gzip -c > Xcode108SDK.tar.gz) && echo "created Xcode108SDK.tar.gz in directory "`pwd`
	hdiutil detach /Volumes/Xcode
	;;

    install)
        #######################
        # PHASE 2: INSTALLING
        #
        if [ ! -w / ]; then
	    echo "The install phase requires requires administrative rights. Please run it as \"sudo $0 install\""
	    exit 1
	fi
	if [ ! -d "$PLUGINDIR" ]; then
	    echo "Error: could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app, cannot install"
	    exit 1
	fi
	if [ -d "$PLUGINDIR/GCC 4.0.xcplugin" ]; then
	    echo "not installing XcodePluginGCC40.tar.gz (found installed in $PLUGINDIR/GCC 4.0.xcplugin, uninstall first to force install)"
	else
	    (gzip -dc XcodePluginGCC40.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "installed XcodePluginGCC40.tar.gz"
	fi
	if [ -d "$PLUGINDIR/GCC 4.2.xcplugin" ]; then
	    echo "not installing XcodePluginGCC42.tar.gz (found installed in $PLUGINDIR/GCC 4.2.xcplugin, uninstall first to force install)"
	else
	    (gzip -dc XcodePluginGCC42.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "installed XcodePluginGCC42.tar.gz"
	fi
	if [ -d "$PLUGINDIR/LLVM GCC 4.2.xcplugin" ]; then
	    echo "not installing XcodePluginLLVMGCC42.tar.gz (found installed in $PLUGINDIR/LLVM GCC 4.2.xcplugin, uninstall first to force install)"
	else
	    (gzip -dc XcodePluginLLVMGCC42.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "installed XcodePluginLLVMGCC42.tar.gz"
	fi

	if [ -f "$GCCDIR/usr/libexec/gcc/darwin/ppc/as" ]; then
	    echo "not installing XcodePPCas.tar.gz (found installed in $GCCDIR/usr/libexec/gcc/darwin/ppc/as, uninstall first to force install)"
	else
	    (gzip -dc XcodePPCas.tar.gz | (cd "$GCCDIR"; tar xf -))
	    mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc"
	    mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64"
	    ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/as" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc/as"
	    ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc64/as" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64/as"
	    echo "installed XcodePPCas.tar.gz"
	fi
	for v in 4.0 4.2; do
	    for i in c++ cpp g++ gcc gcov llvm-gcc llvm-g++; do
		if [ ! -f "$GCCDIR"/usr/bin/${i}-${v} ]; then
		    ln -sf /usr/bin/${i}-${v} "$GCCDIR"/usr/bin/${i}-${v}
		fi
	    done
	done

	if [ -f "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" ]; then
	    echo "not installing Xcode3ld.tar.gz (found installed in $GCCDIR/usr/libexec/gcc/darwin/ppc/ld, uninstall first to force install)"
	else
	    mkdir -p "$GCCDIR/tmp"
	    (gzip -dc Xcode3ld.tar.gz | (cd "$GCCDIR/tmp"; tar xf -))
	    cp "$GCCDIR/tmp/usr/bin/ld" "$GCCDIR/usr/libexec/gcc/darwin/ppc/"
	    cp "$GCCDIR/tmp/usr/bin/ld" "$GCCDIR/usr/libexec/gcc/darwin/ppc64/"
	    rm -rf "$GCCDIR/tmp"
	    mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc"
	    mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64"
	    ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc/ld"
	    ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc64/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64/ld"
	    mv "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld-original"
	    cat <<LD_EOF >> "$GCCDIR"/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
#!/bin/bash

ARCH=''
ARCH_FOUND=0
for var in "\$@"
do
	if [ "\$ARCH_FOUND" -eq '1' ]; then
		ARCH=\$var
		break
	elif [ "\$var" = '-arch' ]; then
		ARCH_FOUND=1
	fi
done

echo "Running ld for \$ARCH ..."

LD_DIR=\`dirname "\$0"\`
LD_RESULT=255
if [ "\$ARCH" = 'ppc' -o "\$ARCH" = 'ppc64' ]; then
	ARGS=()
	DEPINFO_FOUND=0
	for var in "\$@"; do
		if [ "\$DEPINFO_FOUND" -eq '1' ]; then
			DEPINFO_FOUND=0
			continue
		elif [ "\$var" = '-dependency_info' ]; then
			DEPINFO_FOUND=1
			continue
		fi

		ARGS+=("\$var")
	done

	\`\$LD_DIR/../libexec/ld/\$ARCH/ld "\${ARGS[@]}"\`
	LD_RESULT=\$?
else
	\`\$LD_DIR/ld-original "\$@"\`
	LD_RESULT=\$?
fi

exit \$LD_RESULT
LD_EOF
	    chmod +x "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld"
	    echo "installed Xcode3ld.tar.gz"
	fi

	if [ -d "$SDKDIR/SDKs/MacOSX10.4u.sdk" ]; then
	    echo "not installing Xcode104SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.4u.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode104SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "installed Xcode104SDK.tar.gz"
	    touch "$SDKDIR/SDKs/MacOSX10.4u.sdk/legacy"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.5.sdk" ]; then
	    echo "not installing Xcode105SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.5.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode105SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "installed Xcode105SDK.tar.gz"
	    touch "$SDKDIR/SDKs/MacOSX10.5.sdk/legacy"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.6.sdk" ]; then
	    echo "not installing Xcode106SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.6.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode106SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "installed Xcode106SDK.tar.gz"
	    touch "$SDKDIR/SDKs/MacOSX10.6.sdk/legacy"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.7.sdk" ]; then
	    echo "not installing Xcode107SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.7.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode107SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "installed Xcode107SDK.tar.gz"
	    touch "$SDKDIR/SDKs/MacOSX10.7.sdk/legacy"
	fi
	if [ -d "$SDKDIR/SDKs/MacOSX10.8.sdk" ]; then
	    echo "not installing Xcode108SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.8.sdk, uninstall first to force install)"
	else
	    (gzip -dc Xcode108SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "installed Xcode108SDK.tar.gz"
	    touch "$SDKDIR/SDKs/MacOSX10.8.sdk/legacy"
	fi

	if [ -f /usr/bin/gcc-4.0 ]; then
	    echo "not installing xcode_3.2.6_gcc4.0.pkg (found installed in /usr/bin/gcc-4.0, uninstall first to force install)"
	else
	    echo "Installing GCC 4.0"
	    installer -pkg xcode_3.2.6_gcc4.0.pkg -target /
	fi
	if [ -f /usr/bin/gcc-4.2 ]; then
	    echo "not installing xcode_3.2.6_gcc4.2.pkg (found installed in /usr/bin/gcc-4.2, uninstall first to force install)"
	else
	    echo "Installing GCC 4.2"
	    installer -pkg xcode_3.2.6_gcc4.2.pkg -target /
	fi
	if [ -f /usr/bin/llvm-gcc-4.2 ]; then
	    echo "not installing xcode_3.2.6_llvm-gcc4.2.pkg (found installed in /usr/bin/llvm-gcc-4.2, uninstall first to force install)"
	else
	    echo "Installing LLVM GCC 4.2"
	    installer -pkg xcode_3.2.6_llvm-gcc4.2.pkg -target /
	fi
	;;

    cleanpackages)
        #######################
        # PHASE 3: CLEANING
        #

	rm XcodePluginGCC40.tar.gz XcodePPCas.tar.gz Xcode3ld.tar.gz xcode_3.2.6_gcc4.0.pkg xcode_3.2.6_gcc4.2.pkg Xcode104SDK.tar.gz Xcode105SDK.tar.gz Xcode106SDK.tar.gz xcode_3.2.6_llvm-gcc4.2.pkg Xcode107SDK.tar.gz XcodePluginGCC42-Xcode4.tar.gz XcodePluginGCC42.tar.gz XcodePluginLLVMGCC42.tar.gz

	;;

    uninstall)
        #######################
        # PHASE 4: UNINSTALLING
        #
        if [ ! -w / ]; then
	    echo "The uninstall phase requires requires administrative rights. Please run it as \"sudo $0 uninstall\""
	    exit 1
	fi

	rm -rf "$PLUGINDIR/GCC 4.0.xcplugin"
	rm -rf "$GCCDIR/usr/libexec/gcc/darwin/ppc" "$GCCDIR/usr/libexec/gcc/darwin/ppc64"
	rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc"
	rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64"
	rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc"
	rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64"
	mv -f "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld-original" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld"
	rm -rf "$GCCDIR/usr/bin/*4.0" "$GCCDIR/usr/lib/gcc/i686-apple-darwin10" "$GCCDIR/usr/lib/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/powerpc-apple-darwin10" "$GCCDIR/usr/libexec/gcc/i686-apple-darwin10"
	for i in 10.4u 10.5 10.6 10.7 10.8; do
	  [ -f "$SDKDIR/SDKs/MacOSX${i}.sdk/legacy" ] && rm -rf "$SDKDIR/SDKs/MacOSX${i}.sdk"
	done
	;;

esac
