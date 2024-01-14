#!/bin/zsh
echo 'step 1:'
export DIR=$(pwd) SR=/usr/local/SYSROOT HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_MAKE_JOBS=16 export BASE=/Users/runner/work/futurerestore/futurerestore/.github/workflows HB=/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
ssh-keyscan github.com >> ~/.ssh/known_hosts
if [ ! -f "/usr/local/lib/.DEP-CACHED" ]; then
    sudo mkdir $SR
    echo 'step 2:'
    cd $BASE
    sudo mv $BASE/MacOSX10.13.sdk $SR/
    echo 'step 4:'
    sudo find /usr/local/opt -name '*.a' -delete
    sudo find /usr/local/opt -name '*.la' -delete
    echo 'step 5:'
    sudo find /usr/local/lib -name '*.a' -delete
    sudo find /usr/local/lib -name '*.la' -delete
    echo 'step 6:'
    cp -v openssl@1.1.rb $HB
    cp -v zstd.rb $HB
    cp -v xz.rb $HB
    cp -v libusb.rb $HB
    echo 'step 7:'
    brew link --overwrite --force openssl@1.1 zstd xz libzip libusb
    echo 'step 8:'
    brew unlink openssl@1.1 zstd xz libzip libusb curl
    echo 'step 8:'
    brew install --force make cmake autoconf automake
    echo 'step 9:'
    brew reinstall --force -s openssl@1.1 zstd xz libusb
    echo 'step 10:'
    sudo find /usr/local/lib -name 'libzstd*.dylib' -delete
    sudo find /usr/local/lib -iname 'libzip*.dylib' -delete
    sudo find /usr/local/lib -iname 'liblzma*.dylib' -delete
    sudo find /usr/local/lib -iname 'libusb-1.0*.dylib' -delete
    sudo find /usr/local/lib -iname 'libpng*.dylib' -delete
    find /usr/local/Cellar -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
    find /usr/local/opt -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
    find /usr/local/lib -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
    echo 'step 10:'
    git clone https://github.com/nih-at/libzip.git
    cd libzip
    git reset 2d75609 --hard
    git clean -fxd
    echo 'step 11:'
    git apply $BASE/libzip.patch
    echo 'step 12:'
    CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' cmake .
    echo 'step 13:'
    CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' gmake -j16
    echo 'step 14:'
    find /usr/local/lib -iname 'libzip.*' -delete
    gmake -j16 install
    echo 'step 15:'
    cd $BASE
    git clone --recursive https://github.com/libimobiledevice/libplist.git
    cd libplist
    git reset ebf2fdb --hard
    git clean -fxd
    echo 'step 16:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --without-cython --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 16:'
    gmake -j16
    echo 'step 17:'
    gmake -j16 install
    echo 'step 18:'
    cd $BASE
    git clone --recursive https://github.com/libimobiledevice/libusbmuxd.git
    cd libusbmuxd
    git reset 3eb50a0 --hard
    git clean -fxd
    echo 'step 19:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 20:'
    gmake -j16
    echo 'step 21:'
    gmake -j16 install
    echo 'step 22:'
    cd $BASE
    git clone --recursive https://github.com/libimobiledevice/libimobiledevice.git
    cd libimobiledevice
    git reset 25059d4 --hard
    git clean -fxd
    echo 'step 23:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug --without-cython CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 24:'
    gmake -j16
    echo 'step 25:'
    gmake -j16 install
    echo 'step 26:'
    cd $BASE
    git clone --recursive https://github.com/libimobiledevice/libirecovery.git
    cd libirecovery
    git reset 1132470 --hard
    git clean -fxd
    echo 'step 27:'
    git apply $BASE/libirecovery.patch
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 28:'
    gmake -j16
    echo 'step 29:'
    gmake -j16 install
    echo 'step 30:'
    cd $BASE
    git clone --recursive https://github.com/tihmstar/libgeneral.git
    cd libgeneral
    git reset b04a27d --hard
    git clean -fxd
    echo 'step 31:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 32:'
    gmake -j16
    echo 'step 33:'
    gmake -j16 install
    echo 'step 42:'
    cd $BASE
    git clone --recursive https://github.com/tihmstar/libfragmentzip.git
    cd libfragmentzip
    git reset aaf6fae --hard
    git clean -fxd
    echo 'step 43:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 44:'
    gmake -j16
    echo 'step 45:'
    gmake -j16 install
    echo 'step 46:'
    cd $BASE
    git clone --recursive https://github.com/tihmstar/img4tool.git
    cd img4tool
    git reset aca6cf0 --hard
    git clean -fxd
    echo 'step 47:'
    ./autogen.sh --disable-dependency-tracking --disable-silent-rules --disable-shared --prefix=/usr/local --disable-debug CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
    echo 'step 48:'
    gmake -j16
    echo 'step 49:'
    gmake -j16 install
    echo 'step 50:'
    cd $BASE
    echo 'step 51:'
    unzip libpng.zip
    rm -rv /usr/local/lib/libpng16.*
    cp -v $BASE/libpng16.a /usr/local/lib/
    echo 'step 55:'
    touch /usr/local/lib/.DEP-CACHED
    echo 'End'
else
    echo 'End'
fi
