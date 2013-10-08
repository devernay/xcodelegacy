cd /Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/
sudo tar zxvf /Users/devernay/Public/Xcode/XcodePluginGCC40.tar.gz 
cd /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/
sudo tar zxvf /Users/devernay/Public/Xcode/Xcode105SDK.tar.gz 
sudo tar zxvf /Users/devernay/Public/Xcode/Xcode106SDK.tar.gz
cd /Applications/Xcode.app/Contents/Developer/usr/bin
for i in g++ gcc cpp gcov; do
  for v in 4.0 4.2; do
    sudo ln -s /usr/bin/${i}-${v} .
  done
done
## gcc 4.2 plugin is still available, but disabled.
echo "install xcode_3.2.6_gcc4.0.pkg and xcode_4.1_gcc4.2.pkg"
echo 'edit "/Applications/Xcode.app/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/GCC 4.2.xcplugin/Contents/Resources/GCC 4.2.xcspec"'
echo 'and change ShowInCompilerSelectionPopup to "YES" and IsNoLongerSupported to "NO"'
