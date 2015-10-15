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
# 1.3 (07/10/2014): Xcode 6 removed 10.8 SDK, grab it from Xcode 5.1.1
# 1.4 (21/08/2015): Xcode 7 removed 10.9 and 10.10 SDKs, grab them from Xcode 6.4


if [ $# != 1 ]; then
    echo "Usage: $0 buildpackages|install|installbeta|cleanpackages|uninstall|uninstallbeta"
    echo "Description: Extracts / installs / cleans / uninstalls the following components from Xcode 3.2.6, Xcode 4.6.3, Xcode 5.1.1 and Xcode 6.4,"
    echo "which are not available in Xcode >= 4.2:"
    echo "- GCC 4.0 Xcode plugin"
    echo "- PPC assembler and linker"
    echo "- GCC 4.0 and 4.2"
    echo "- Mac OS X SDK 10.4u, 10.5, 10.6, 10.7, 10.8, 10.9, 10.10"
    echo ""
    echo "Typically, you will want to run this script with the buildpackages argument first, then the install argument, "
    echo "and lastly the cleanpackages argument, in order to properly install the legacy Xcode files."
    echo "The install and uninstall phases have to be run with administrative rights, as in:"
    echo " $ sudo $0 install"
    echo "installbeta and uninstallbeta work on the beta versions of Xcode"
    exit
fi

XCODEDIR="/Developer"
PLUGINDIR="$XCODEDIR/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
GCCDIR="$XCODEDIR"
SDKDIR="$XCODEDIR"
if [ -d "$PLUGINDIR" ]; then
    echo "*** Info: found Xcode <= 4.2.1"
else
    PLUGINDIR="/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
    if [ ! -d "$PLUGINDIR" ]; then
        echo "Info: could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app"
    fi
    echo "*** Info: found Xcode >= 4.3"
    GCCDIR="/Applications/Xcode.app/Contents/Developer"
    SDKDIR="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer"
fi

if [ "$1" = "installbeta" -o "$1" = "uninstallbeta" ]; then
    PLUGINDIR="/Applications/Xcode-beta.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"
    if [ ! -d "$PLUGINDIR" ]; then
        echo "*** Info: could not find Xcode beta in /Applications/Xcode-beta.app"
    fi
    echo "*** Info: found Xcode beta"
    GCCDIR="/Applications/Xcode-beta.app/Contents/Developer"
    SDKDIR="/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer"
fi
SANDBOX=0
GCCINSTALLDIR="$GCCDIR/Toolchains/XcodeDefault.xctoolchain"
GCCLINKDIR=/usr
if [ `uname -r | awk -F. '{print $1}'` -gt 14 ]; then
    # on OSX 10.11 El Capitan, nothing can be installed in /usr because of the Sandbox
    # install in Xcode instead, and put links in /usr/local
    SANDBOX=1
    GCCLINKDIR=/usr/local
fi

GCCFILES="usr/share/man/man7/fsf-funding.7 usr/share/man/man7/gfdl.7 usr/share/man/man7/gpl.7 usr/share/man/man1/*-4.0.1 usr/share/man/man1/*-4.0.1.1 usr/libexec/gcc/*-apple-darwin10/4.0.1 usr/lib/gcc/*-apple-darwin10/4.0.1 usr/include/gcc/darwin/4.0 usr/bin/*-4.0 usr/bin/*-4.0.1 usr/share/man/man1/*-4.2.1 usr/libexec/gcc/*-apple-darwin10/4.2.1 usr/lib/gcc/*-apple-darwin10/4.2.1 usr/include/gcc/darwin/4.2 usr/bin/*-4.2 usr/bin/*-4.2.1 usr/llvm-gcc-4.2 usr/share/man/man1/llvm-g*.1.gz usr/libexec/gcc/*-apple-darwin10/4.2.1 usr/lib/gcc/*-apple-darwin10/4.2.1 usr/include/gcc/darwin/4.2 usr/bin/*-4.2 usr/bin/*-4.2.1"

case $1 in
    buildpackages)
        #######################
        # PHASE 1: PACKAGING
        #
        if [ ! -f xcode_3.2.6_and_ios_sdk_4.3.dmg ]; then
            echo "*** you should download Xcode 3.2.6 from:"
            echo " http://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=20792"
            echo "or"
            echo " http://adcdownload.apple.com/Developer_Tools/xcode_3.2.6_and_ios_sdk_4.3__final/xcode_3.2.6_and_ios_sdk_4.3.dmg"
            echo "and then run this script from within the same directory as the downloaded file"
            exit
        fi
        if [ ! -f xcode4630916281a.dmg ]; then
            echo "*** you should download Xcode 4.6.3 from:"
            echo " http://adcdownload.apple.com/Developer_Tools/xcode_4.6.3/xcode4630916281a.dmg"
            echo "or"
            echo " https://developer.apple.com/downloads/"
            echo "and then run this script from within the same directory as the downloaded file"
            exit
        fi
        if [ ! -f xcode_5.1.1.dmg ]; then
            echo "*** you should download Xcode 5.1.1 from:"
            echo " http://adcdownload.apple.com/Developer_Tools/xcode_5.1.1/xcode_5.1.1.dmg"
            echo "or"
            echo " https://developer.apple.com/downloads/"
            echo "and then run this script from within the same directory as the downloaded file"
            exit
        fi
        if [ ! -f Xcode_6.4.dmg ]; then
            echo "*** you should download Xcode 6.4 from:"
            echo " http://adcdownload.apple.com/Developer_Tools/Xcode_6.4/Xcode_6.4.dmg"
            echo "or"
            echo " https://developer.apple.com/downloads/"
            echo "and then run this script from within the same directory as the downloaded file"
            exit
        fi

        MNTDIR=`mktemp -d mount.XXX`
        ATTACH_OPTS="-nobrowse -mountroot $MNTDIR"
        # you should download Xcode 3.2.6 from:
        # http://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=20792
        hdiutil attach xcode_3.2.6_and_ios_sdk_4.3.dmg $ATTACH_OPTS
        if [ ! -d $MNTDIR/Xcode\ and\ iOS\ SDK ]; then
            echo "*** Error while trying to attach disk image xcode_3.2.6_and_ios_sdk_4.3.dmg"
            echo "Aborting"
            exit
        fi
        rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/DeveloperTools.pkg /tmp/XC3
        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet Library/Xcode/Plug-ins) #we only need these, see https://github.com/devernay/xcodelegacy/issues/8
        ((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "GCC 4.0.xcplugin") |gzip -c > XcodePluginGCC40.tar.gz) && echo "*** Created XcodePluginGCC40.tar.gz in directory "`pwd`
        ((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "GCC 4.2.xcplugin") |gzip -c > XcodePluginGCC42.tar.gz) && echo "*** Created XcodePluginGCC42.tar.gz in directory "`pwd`
        ((cd /tmp/XC3/Library/Xcode/Plug-ins; tar cf - "LLVM GCC 4.2.xcplugin") |gzip -c > XcodePluginLLVMGCC42.tar.gz) && echo "*** Created XcodePluginLLVMGCC42.tar.gz in directory "`pwd`
        # should be untarred in /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins
        # gzip -dc XcodePluginGCC40.tar.gz | (cd /Developer/Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; sudo tar xvf -)

        rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/DeveloperToolsCLI.pkg /tmp/XC3

        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet usr/bin usr/libexec) #we only need these, see https://github.com/devernay/xcodelegacy/issues/8
        ((cd /tmp/XC3; tar cf - usr/libexec/gcc/darwin/ppc usr/libexec/gcc/darwin/ppc64) |gzip -c > XcodePPCas.tar.gz) && echo "*** Created XcodePPCas.tar.gz in directory "`pwd`
        ((cd /tmp/XC3; tar cf - usr/bin/ld) |gzip -c > Xcode3ld.tar.gz) && echo "*** Created Xcode3ld.tar.gz in directory "`pwd`

        #(cp $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/gcc4.0.pkg  xcode_3.2.6_gcc4.0.pkg) && echo "*** Created xcode_3.2.6_gcc4.0.pkg in directory "`pwd`
        rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/gcc4.0.pkg /tmp/XC3

        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet usr) #we only need these, see https://github.com/devernay/xcodelegacy/issues/8
        ((cd /tmp/XC3; tar cf - usr) |gzip -c > Xcode3gcc40.tar.gz) && echo "*** Created Xcode3gcc40.tar.gz in directory "`pwd`

        #(cp $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/gcc4.2.pkg  xcode_3.2.6_gcc4.2.pkg) && echo "*** Created xcode_3.2.6_gcc4.2.pkg in directory "`pwd`
        rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/gcc4.2.pkg /tmp/XC3

        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet usr) #we only need these, see https://github.com/devernay/xcodelegacy/issues/8
        ((cd /tmp/XC3; tar cf - usr) |gzip -c > Xcode3gcc42.tar.gz) && echo "*** Created Xcode3gcc42.tar.gz in directory "`pwd`

        #(cp $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/llvm-gcc4.2.pkg  xcode_3.2.6_llvm-gcc4.2.pkg) && echo "*** Created xcode_3.2.6_llvm-gcc4.2.pkg in directory "`pwd`
        rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/llvm-gcc4.2.pkg /tmp/XC3

        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet usr) #we only need these, see https://github.com/devernay/xcodelegacy/issues/8
        ((cd /tmp/XC3; tar cf - usr) |gzip -c > Xcode3llvmgcc42.tar.gz) && echo "*** Created Xcode3llvmgcc42.tar.gz in directory "`pwd`

        rm -rf /tmp/XC3

        cat > /tmp/hashtable.patch <<EOF
--- hashtable.orig      2015-09-01 14:43:32.000000000 +0200
+++ hashtable   2010-09-03 22:41:42.000000000 +0200
@@ -860,7 +860,7 @@
   typedef typename Internal::IF<unique_keys, std::pair<iterator, bool>, iterator>::type
           Insert_Return_Type;
 
-  node* find_node (node* p, const key_type& k, typename hashtable::hash_code_t c);
+  node* find_node (node* p, const key_type& k, typename hashtable::hash_code_t c) const;
 
   std::pair<iterator, bool> insert (const value_type&, std::tr1::true_type);
   iterator insert (const value_type&, std::tr1::false_type);
@@ -1042,8 +1042,9 @@
       node* n = ht.m_buckets[i];
       node** tail = m_buckets + i;
       while (n) {
-       *tail = m_allocate_node (n);
-       (*tail).copy_code_from (n);
+       //      *tail = m_allocate_node (n);
+       //      (*tail).copy_code_from (n);
+       *tail = m_allocate_node (n->m_v);
        tail = &((*tail)->m_next);
        n = n->m_next;
       }
@@ -1216,7 +1217,7 @@
          bool c, bool m, bool u>
 typename hashtable<K,V,A,Ex,Eq,H1,H2,H,RP,c,m,u>::node* 
 hashtable<K,V,A,Ex,Eq,H1,H2,H,RP,c,m,u>
-::find_node (node* p, const key_type& k, typename hashtable::hash_code_t code)
+::find_node (node* p, const key_type& k, typename hashtable::hash_code_t code) const
 {
   for ( ; p ; p = p->m_next)
     if (this->compare (k, code, p))
EOF
        test -d /tmp/XC3-10.4 && rm -rf /tmp/XC3-10.4
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.4.Universal.pkg /tmp/XC3-10.4
        (cd /tmp/XC3-10.4;gzip -dc Payload  |cpio -id --quiet SDKs/MacOSX10.4u.sdk)
        # should we install more than these? (fixed includes?)
        # Add links to libstdc++ so that "g++-4.0 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4" works
        ln -s ../../../i686-apple-darwin10/4.0.1/libstdc++.dylib /tmp/XC3-10.4/SDKs/MacOSX10.4u.sdk/usr/lib/gcc/i686-apple-darwin10/4.0.1/libstdc++.dylib
        # Add links to libstdc++ so that "clang++ -stdlib=libstdc++ -isysroot /Developer/SDKs/MacOSX10.4u.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4" works
        ln -s libstdc++.6.dylib /tmp/XC3-10.4/SDKs/MacOSX10.4u.sdk/usr/lib/libstdc++.dylib
        # Fix tr1/hashtable
        # see http://www.openfst.org/twiki/bin/view/FST/CompilingOnMacOSX https://gcc.gnu.org/ml/libstdc++/2005-08/msg00017.html https://gcc.gnu.org/bugzilla/show_bug.cgi?id=23053
        # in SDKs/MacOSX10.4u.sdk/usr/include/c++/4.0.0/tr1/hashtable
        (cd /tmp/XC3-10.4/SDKs/MacOSX10.4u.sdk/usr/include/c++/4.0.0/tr1; patch -p0 -d. < /tmp/hashtable.patch)
        ((cd /tmp/XC3-10.4; tar cf - SDKs/MacOSX10.4u.sdk) |gzip -c > Xcode104SDK.tar.gz) && echo "*** Created Xcode104SDK.tar.gz in directory "`pwd`
        rm -rf /tmp/XC3-10.4
        
        test -d /tmp/XC3-10.5 && rm -rf /tmp/XC3-10.5
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.5.pkg /tmp/XC3-10.5
        (cd /tmp/XC3-10.5;gzip -dc Payload  |cpio -id --quiet SDKs/MacOSX10.5.sdk)
        # should we install more than these? (fixed includes?)
        # Add links to libstdc++ so that "g++-4.0 -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5" works
        ln -s ../../../i686-apple-darwin10/4.0.1/libstdc++.dylib /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/gcc/i686-apple-darwin10/4.0.1/libstdc++.dylib
        ln -s ../../../i686-apple-darwin10/4.2.1/libstdc++.dylib /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/gcc/i686-apple-darwin10/4.2.1/libstdc++.dylib
        # Add links to libstdc++ so that "clang++ -stdlib=libstdc++ -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5" works
        ln -s libstdc++.6.dylib /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/libstdc++.dylib
        # fix AvailabilityInternal.h (see https://trac.macports.org/wiki/LeopardSDKFixes)
        sed -i.orig -e 's/define __MAC_OS_X_VERSION_MAX_ALLOWED __MAC_10_6/define __MAC_OS_X_VERSION_MAX_ALLOWED 1058/' /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/include/AvailabilityInternal.h
        # Fix tr1/hashtable
        # see http://www.openfst.org/twiki/bin/view/FST/CompilingOnMacOSX https://gcc.gnu.org/ml/libstdc++/2005-08/msg00017.html https://gcc.gnu.org/bugzilla/show_bug.cgi?id=23053
        # in SDKs/MacOSX10.5.sdk/usr/include/c++/4.0.0/tr1/hashtable
        # this also affects g++-4.2, since usr/include/c++/4.2.1 links to usr/include/c++/4.0.0
        (cd /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/include/c++/4.0.0/tr1; patch -p0 -d. < /tmp/hashtable.patch)
        rm /tmp/hashtable.patch
        
        test -d /tmp/XC3 && rm -rf /tmp/XC3
        pkgutil --expand $MNTDIR/Xcode\ and\ iOS\ SDK/Packages/MacOSX10.6.pkg /tmp/XC3
        (cd /tmp/XC3;gzip -dc Payload  |cpio -id --quiet SDKs/MacOSX10.6.sdk)
        # should we install more than these? (fixed includes?)
        # Add links to libstdc++ so that "clang++ -stdlib=libstdc++ -isysroot /Developer/SDKs/MacOSX10.6.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.6.sdk -mmacosx-version-min=10.6" works
        ln -s libstdc++.6.dylib /tmp/XC3/SDKs/MacOSX10.6.sdk/usr/lib/libstdc++.dylib

        # we also need to copy /usr/lib/libgcc_s.10.5.dylib from 10.6 SDK to 10.5SDK, see https://trac.macports.org/wiki/LeopardSDKFixes
        # This should fix compiling the following:
        # int main() { __uint128_t a = 100; __uint128_t b = 200; __uint128_t c = a / b; return 0; }
        # with clang -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-syslibroot,/Developer/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5 conftest1.c
        cp /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/libgcc_s.10.5.dylib /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/libgcc_s.10.5.dylib.bak
        cp /tmp/XC3/SDKs/MacOSX10.6.sdk/usr/lib/libgcc_s.10.5.dylib /tmp/XC3-10.5/SDKs/MacOSX10.5.sdk/usr/lib/libgcc_s.10.5.dylib

        ((cd /tmp/XC3-10.5; tar cf - SDKs/MacOSX10.5.sdk) |gzip -c > Xcode105SDK.tar.gz) && echo "*** Created Xcode105SDK.tar.gz in directory "`pwd`
        ((cd /tmp/XC3; tar cf - SDKs/MacOSX10.6.sdk) |gzip -c > Xcode106SDK.tar.gz) && echo "*** Created Xcode106SDK.tar.gz in directory "`pwd`

        rm -rf /tmp/XC3-10.5 /tmp/XC3
        hdiutil detach $MNTDIR/Xcode\ and\ iOS\ SDK

        hdiutil attach xcode4630916281a.dmg $ATTACH_OPTS
        if [ ! -d $MNTDIR/Xcode ]; then
            echo "*** Error while trying to attach disk image xcode4630916281a.dmg"
            echo "Aborting"
            rmdir $MNTDIR
            exit
        fi
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.7.sdk) |gzip -c > Xcode107SDK.tar.gz) && echo "*** Created Xcode107SDK.tar.gz in directory "`pwd`
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; tar cf - "GCC 4.2.xcplugin") |gzip -c > XcodePluginGCC42-Xcode4.tar.gz) && echo "*** Created XcodePluginGCC42-Xcode4.tar.gz in directory "`pwd`
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins; tar cf - "LLVM GCC 4.2.xcplugin") |gzip -c > XcodePluginLLVMGCC42.tar.gz) && echo "*** Created XcodePluginLLVMGCC42.tar.gz in directory "`pwd`
        hdiutil detach $MNTDIR/Xcode

        hdiutil attach xcode_5.1.1.dmg $ATTACH_OPTS
        if [ ! -d $MNTDIR/Xcode ]; then
            echo "*** Error while trying to attach disk image xcode_5.1.1.dmg"
            echo "Aborting"
            rmdir $MNTDIR
            exit
        fi
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.8.sdk) |gzip -c > Xcode108SDK.tar.gz) && echo "*** Created Xcode108SDK.tar.gz in directory "`pwd`
        hdiutil detach $MNTDIR/Xcode

        hdiutil attach Xcode_6.4.dmg $ATTACH_OPTS
        if [ ! -d $MNTDIR/Xcode ]; then
            echo "*** Error while trying to attach disk image Xcode_6.4.dmg"
            echo "Aborting"
            rmdir $MNTDIR
            exit
        fi
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.9.sdk) |gzip -c > Xcode109SDK.tar.gz) && echo "*** Created Xcode109SDK.tar.gz in directory "`pwd`
        ((cd $MNTDIR/Xcode/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer; tar cf - SDKs/MacOSX10.10.sdk) |gzip -c > Xcode1010SDK.tar.gz) && echo "*** Created Xcode1010SDK.tar.gz in directory "`pwd`
        hdiutil detach $MNTDIR/Xcode
        rmdir $MNTDIR
        ;;

    install|installbeta)
        #######################
        # PHASE 2: INSTALLING
        #
        if [ ! -w / ]; then
            echo "*** The install phase requires administrative rights. Please run it as \"sudo $0 install\""
            exit 1
        fi
        if [ ! -d "$PLUGINDIR" ]; then
            echo "*** Error: could not find Xcode 4.2 in /Developer nor Xcode 4.3 in /Applications/Xcode.app, cannot install"
            exit 1
        fi
        if [ -d "$PLUGINDIR/GCC 4.0.xcplugin" ]; then
            echo "*** Not installing XcodePluginGCC40.tar.gz (found installed in $PLUGINDIR/GCC 4.0.xcplugin, uninstall first to force install)"
        else
            (gzip -dc XcodePluginGCC40.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "*** installed XcodePluginGCC40.tar.gz"
        fi
        if [ -d "$PLUGINDIR/GCC 4.2.xcplugin" ]; then
            echo "*** Not installing XcodePluginGCC42.tar.gz (found installed in $PLUGINDIR/GCC 4.2.xcplugin, uninstall first to force install)"
        else
            (gzip -dc XcodePluginGCC42.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "*** installed XcodePluginGCC42.tar.gz"
        fi
        if [ -d "$PLUGINDIR/LLVM GCC 4.2.xcplugin" ]; then
            echo "*** Not installing XcodePluginLLVMGCC42.tar.gz (found installed in $PLUGINDIR/LLVM GCC 4.2.xcplugin, uninstall first to force install)"
        else
            (gzip -dc XcodePluginLLVMGCC42.tar.gz | (cd "$PLUGINDIR"; tar xf -)) && echo "*** installed XcodePluginLLVMGCC42.tar.gz"
        fi

        if [ -f "$GCCDIR/usr/libexec/gcc/darwin/ppc/as" ]; then
            echo "*** Not installing XcodePPCas.tar.gz (found installed in $GCCDIR/usr/libexec/gcc/darwin/ppc/as, uninstall first to force install)"
        else
            (gzip -dc XcodePPCas.tar.gz | (cd "$GCCDIR"; tar xf -))
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc"
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/as" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc/as"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc64/as" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64/as"
            echo "*** installed XcodePPCas.tar.gz"
        fi

        if [ -f "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" ]; then
            echo "*** Not installing Xcode3ld.tar.gz (found installed in $GCCDIR/usr/libexec/gcc/darwin/ppc/ld, uninstall first to force install)"
        else
            mkdir -p "$GCCDIR/tmp"
            (gzip -dc Xcode3ld.tar.gz | (cd "$GCCDIR/tmp"; tar xf -))
            cp "$GCCDIR/tmp/usr/bin/ld" "$GCCDIR/usr/libexec/gcc/darwin/ppc/"
            cp "$GCCDIR/tmp/usr/bin/ld" "$GCCDIR/usr/libexec/gcc/darwin/ppc64/"
            rm -rf "$GCCDIR/tmp"
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc"
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc7400"
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc970"
            mkdir -p "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc/ld"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc7400/ld"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc970/ld"
            ln -sf "$GCCDIR/usr/libexec/gcc/darwin/ppc64/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64/ld"
            # prevent overwriting the original ld if the script is run twice
            if [ ! -f "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld-original" ]; then
                mv "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld-original"
            fi
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
if [ -f "\$LD_DIR/ld-original" ]; then
        LDORIGINAL="\$LD_DIR/ld-original"
elif [ -f "\$LD_DIR/../../../../bin/ld-original" ]; then
        LDORIGINAL="\$LD_DIR/../../../../bin/ld-original"
elif [ -f "\$LD_DIR/../../../../../bin/ld-original" ]; then
        LDORIGINAL="\$LD_DIR/../../../../../bin/ld-original"
else
        echo "Error: cannot find ld-original in \$LD_DIR or \$LD_DIR/../../../../bin"
        exit 1
fi
LD_RESULT=255
if [ "\$ARCH" = 'ppc' -o "\$ARCH" = 'ppc7400' -o "\$ARCH" = 'ppc970' -o "\$ARCH" = 'ppc64' ]; then
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
        if [ -f "\$LD_DIR/../libexec/ld/\$ARCH/ld" ]; then
                LD="\$LD_DIR/../libexec/ld/\$ARCH/ld"
        elif [ -f "\$LD_DIR/../../../libexec/ld/\$ARCH/ld" ]; then
                LD="\$LD_DIR/../../../libexec/ld/\$ARCH/ld"
        elif [ -f "\$LD_DIR/../../../../libexec/ld/\$ARCH/ld" ]; then
                LD="\$LD_DIR/../../../../libexec/ld/\$ARCH/ld"
        else
                echo "Error: cannot find ld for \$ARCH in \$LD_DIR/../libexec/ld/\$ARCH \$LD_DIR/../../../libexec/ld/\$ARCH or \$LD_DIR/../../../../libexec/ld/\$ARCH"
                exit 1
        fi
        
        \`\$LD "\${ARGS[@]}"\`
        LD_RESULT=\$?
else
        \`\$LDORIGINAL "\$@"\`
        LD_RESULT=\$?
fi

exit \$LD_RESULT
LD_EOF
            chmod +x "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld"
            echo "*** installed Xcode3ld.tar.gz"
        fi

        if [ -f "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec-original" ]; then
            echo "*** Not modifying MacOSX Architectures.xcspec (found original at $SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec-original, uninstall first to force install)"
        else
                mv "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec" "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec-original"
                { awk 'NR>1{print l}{l=$0}' "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec-original"; cat - <<SPEC_EOF; } > "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec"
        {
                Type = Architecture;
                Identifier = ppc;
                Name = "Minimal (32-bit PowerPC only)";
                Description = "32-bit PowerPC";
                "PerArchBuildSettingName" = PowerPC;
                ByteOrder = big;
                ListInEnum = YES;
                SortNumber = 201;
        },
        {
                Type = Architecture;
                Identifier = ppc7400;
                Name = "PowerPC G4";
                Description = "32-bit PowerPC for G4 processor";
                ByteOrder = big;
                ListInEnum = YES;
                SortNumber = 202;
        },
        {
                Type = Architecture;
                Identifier = ppc970;
                Name = "PowerPC G5 32-bit";
                Description = "32-bit PowerPC for G5 processor";
                ByteOrder = big;
                ListInEnum = YES;
                SortNumber = 203;
        },
        {
                Type = Architecture;
                Identifier = ppc64;
                Name = "PowerPC 64-bit";
                Description = "64-bit PowerPC";
                "PerArchBuildSettingName" = "PowerPC 64-bit";
                ByteOrder = big;
                ListInEnum = YES;
                SortNumber = 204;
        },
)
SPEC_EOF
            echo "*** modified MacOSX Architectures.xcspec"
        fi

        if [ -d "$SDKDIR/SDKs/MacOSX10.4u.sdk" ]; then
            echo "*** Not installing Xcode104SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.4u.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode104SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode104SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.4u.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.5.sdk" ]; then
            echo "*** Not installing Xcode105SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.5.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode105SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode105SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.5.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.6.sdk" ]; then
            echo "*** Not installing Xcode106SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.6.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode106SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode106SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.6.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.7.sdk" ]; then
            echo "*** Not installing Xcode107SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.7.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode107SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode107SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.7.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.8.sdk" ]; then
            echo "*** Not installing Xcode108SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.8.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode108SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode108SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.8.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.9.sdk" ]; then
            echo "*** Not installing Xcode109SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.9.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode109SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode109SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.9.sdk/legacy"
        fi
        if [ -d "$SDKDIR/SDKs/MacOSX10.10.sdk" ]; then
            echo "*** Not installing Xcode1010SDK.tar.gz (found installed in $SDKDIR/SDKs/MacOSX10.10.sdk, uninstall first to force install)"
        else
            (gzip -dc Xcode1010SDK.tar.gz | (cd "$SDKDIR"; tar xf -)) && echo "*** installed Xcode1010SDK.tar.gz"
            touch "$SDKDIR/SDKs/MacOSX10.10.sdk/legacy"
        fi

        if [ -f /usr/bin/gcc-4.0 ]; then
            #echo "*** Not installing xcode_3.2.6_gcc4.0.pkg (found installed in /usr/bin/gcc-4.0, uninstall first to force install)"
            echo "*** Not installing Xcode3gcc40.tar.gz (found installed in /usr/bin/gcc-4.0, uninstall first to force install)"
        elif [ -f "$GCCINSTALLDIR/usr/bin/gcc-4.0" ]; then
            echo "*** Not installing Xcode3gcc40.tar.gz (found installed in $GCCINSTALLDIR/usr/bin/gcc-4.0, uninstall first to force install)"
        else
            echo "*** Installing GCC 4.0"
            #installer -pkg xcode_3.2.6_gcc4.0.pkg -target /
            (gzip -dc Xcode3gcc40.tar.gz | (cd "$GCCINSTALLDIR"; tar xf -)) && echo "*** installed Xcode3gcc40.tar.gz"
        fi
        if [ -f /usr/bin/gcc-4.2 ]; then
            #echo "*** Not installing xcode_3.2.6_gcc4.2.pkg (found installed in /usr/bin/gcc-4.2, uninstall first to force install)"
            echo "*** Not installing Xcode3gcc42.tar.gz (found installed in /usr/bin/gcc-4.2, uninstall first to force install)"
        elif [ -f "$GCCINSTALLDIR/usr/bin/gcc-4.2" ]; then
            echo "*** Not installing Xcode3gcc42.tar.gz (found installed in $GCCINSTALLDIR/usr/bin/gcc-4.2, uninstall first to force install)"
        else
            echo "*** Installing GCC 4.2"
            #installer -pkg xcode_3.2.6_gcc4.2.pkg -target /
            (gzip -dc Xcode3gcc42.tar.gz | (cd "$GCCINSTALLDIR"; tar xf -)) && echo "*** installed Xcode3gcc42.tar.gz"
        fi
        if [ -f /usr/bin/llvm-gcc-4.2 ]; then
            #echo "*** Not installing xcode_3.2.6_llvm-gcc4.2.pkg (found installed in /usr/bin/llvm-gcc-4.2, uninstall first to force install)"
            echo "*** Not installing Xcode3llvmgcc42.tar.gz (found installed in /usr/bin/llvm-gcc-4.2, uninstall first to force install)"
        elif [ -f "$GCCINSTALLDIR/usr/bin/llvm-gcc-4.2" ]; then
            echo "*** Not installing Xcode3llvmgcc42.tar.gz (found installed in $GCCINSTALLDIR/usr/bin/llvm-gcc-4.2, uninstall first to force install)"
        else
            echo "*** Installing LLVM GCC 4.2"
            #installer -pkg xcode_3.2.6_llvm-gcc4.2.pkg -target /
            (gzip -dc Xcode3llvmgcc42.tar.gz | (cd "$GCCINSTALLDIR"; tar xf -)) && echo "*** installed Xcode3llvmgcc42.tar.gz"
        fi
        
        echo "*** Create symbolic links to compliers in $GCCDIR and $GCCLINKDIR:"
        if [ ! -d "$GCCDIR"/usr/bin ]; then
            mkdir -p "$GCCDIR"/usr/bin
        fi
        if [ ! -d "$GCCLINKDIR"/bin ]; then
            mkdir -p "$GCCLINKDIR"/bin
        fi
        for v in 4.0 4.2 4.0.1 4.2.1; do
            for i in c++ cpp g++ gcc gcov llvm-cpp llvm-g++ llvm-gcc; do
                for p in i686-apple-darwin10- powerpc-apple-darwin10- ""; do
                    if [ -f "$GCCINSTALLDIR"/usr/bin/${p}${i}-${v} ]; then
                        echo "$GCCINSTALLDIR"/usr/bin/${p}${i}-${v} exists
                        if [ ! -f "$GCCLINKDIR"/bin/${p}${i}-${v} ]; then
                            echo "* creating link $GCCLINKDIR/bin/${p}${i}-${v}"
                            ln -sf "$GCCINSTALLDIR"/usr/bin/${p}${i}-${v} "$GCCLINKDIR"/bin/${p}${i}-${v}
                        fi
                        if [ ! -f "$GCCDIR"/usr/bin/${p}${i}-${v} ]; then
                            echo "* creating link $GCCDIR/usr/bin/${i}-${v}"
                            ln -sf "$GCCINSTALLDIR"/usr/bin/${p}${i}-${v} "$GCCDIR"/usr/bin/${p}${i}-${v}
                        fi
                    fi
                done
            done
        done
        ;;

    cleanpackages)
        #######################
        # PHASE 3: CLEANING
        #

        rm XcodePluginGCC40.tar.gz XcodePPCas.tar.gz Xcode3ld.tar.gz xcode_3.2.6_gcc4.0.pkg xcode_3.2.6_gcc4.2.pkg xcode_3.2.6_llvm-gcc4.2.pkg Xcode104SDK.tar.gz Xcode105SDK.tar.gz Xcode106SDK.tar.gz Xcode107SDK.tar.gz Xcode108SDK.tar.gz Xcode109SDK.tar.gz Xcode1010SDK.tar.gz XcodePluginGCC42-Xcode4.tar.gz XcodePluginGCC42.tar.gz XcodePluginLLVMGCC42.tar.gz

        ;;

    uninstall|uninstallbeta)
        #######################
        # PHASE 4: UNINSTALLING
        #
        if [ ! -w / ]; then
            echo "*** The uninstall phase requires requires administrative rights. Please run it as \"sudo $0 uninstall\""
            exit 1
        fi

        rm -rf "$PLUGINDIR/GCC 4.0.xcplugin"
        rm -rf "$GCCDIR/usr/libexec/gcc/darwin/ppc" "$GCCDIR/usr/libexec/gcc/darwin/ppc64"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/as/ppc64"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc7400"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc970"
        rm -rf "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld/ppc64"
        mv -f "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld-original" "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld"
        (cd "$GCCDIR"; rm -rf $GCCFILES)
        (cd "$GCCINSTALLDIR"; rm -rf $GCCFILES)
        rmdir "$GCCDIR/Toolchains/XcodeDefault.xctoolchain/usr/libexec/ld" "$GCCDIR/usr/libexec/gcc/darwin" "$GCCDIR/usr/libexec/gcc" || :
        mv -f "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec-original" "$SDKDIR/Library/Xcode/Specifications/MacOSX Architectures.xcspec"
        for i in 10.4u 10.5 10.6 10.7 10.8 10.9 10.10; do
          [ -f "$SDKDIR/SDKs/MacOSX${i}.sdk/legacy" ] && rm -rf "$SDKDIR/SDKs/MacOSX${i}.sdk"
        done
        for b in gcc-4.0 g++-4.0 gcc-4.2 g++-4.2 llvm-cpp-4.2 llvm-g++-4.2 llvm-gcc-4.2; do
            if [ -L $GCCLINKDIR/bin/$b ]; then
                rm $GCCLINKDIR/bin/$b
            fi
        done
        for b in cpp-4.2.1 gcc-4.0.1 g++-4.0.1 gcc-4.2.1 g++-4.2.1 llvm-g++-4.2 llvm-gcc-4.2; do 
            if [ -L $GCCLINKDIR/bin/i686-apple-darwin10-$b ]; then
                rm $GCCLINKDIR/bin/i686-apple-darwin10-$b
            fi
        done
        for b in cpp-4.2.1 gcc-4.0.1 g++-4.0.1 gcc-4.2.1 g++-4.2.1 llvm-g++-4.2 llvm-gcc-4.2; do
            if [ -L $GCCLINKDIR/usr/bin/powerpc-apple-darwin10-$b ]; then
                rm $GCCLINKDIR/usr/bin/powerpc-apple-darwin10-$b
            fi
        done

        ;;

esac



# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
