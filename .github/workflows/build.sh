#!/bin/zsh
echo 'step 1:'
export DIR=$(pwd) SR=/usr/local/SYSROOT HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_MAKE_JOBS=16 export BASE=/Users/runner/work/futurerestore/futurerestore/.github/workflows HB=/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include'
brew install --force make cmake autoconf automake
sudo mkdir $SR
sudo mv $BASE/MacOSX10.13.sdk $SR/
echo 'step 2:'
cd $BASE/../..
git fetch origin test2
git reset --hard FETCH_HEAD
echo 'step 3:'
git submodule init; git submodule update --recursive
cd external/tsschecker
git submodule init; git submodule update --recursive
cd ../../
find /usr/local/Cellar -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
find /usr/local/opt -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
find /usr/local/lib -type f \( -iname "*.a" ! -iname  "libcrypto.a" ! -iname "libssl.a" ! -iname "libzstd.a" ! -iname "liblzma.a" ! -iname "liblzma.a" ! -iname "libzip.a" ! -iname "libusb-1.0.a" ! -iname "libplist-2.0.a" ! -iname "libplist++-2.0.a" ! -iname "libusbmuxd-2.0.a" ! -iname "libimobiledevice-1.0.a" ! -iname "libirecovery-1.0.a" ! -iname "libgeneral.a" ! -iname "libinsn.a" ! -iname "liboffsetfinder64.a" ! -iname "libfragmentzip.a" ! -iname "libimg4tool.a" ! -iname "libjssy.a" ! -iname "libiBoot32Patcher.a" ! -iname "libipatcher.a" ! -iname "libcommon.a" ! -iname "libxpwn.a" ! -iname "libpng16.*a" \)
sudo find /usr/local/lib -name 'libzstd*.dylib' -delete
sudo find /usr/local/lib -iname 'libzip*.dylib' -delete
sudo find /usr/local/lib -iname 'liblzma*.dylib' -delete
sudo find /usr/local/lib -iname 'libusb-1.0*.dylib' -delete
sudo find /usr/local/lib -iname 'libpng*.dylib' -delete
DEPSDIR=/usr/local
LIBSSL=$DEPSDIR/lib/libssl.35.tbd
LIBCRYPTO=$DEPSDIR/lib/libcrypto.35.tbd
LIBRESSL_VER=2.2.7
LIBRESSL_CFLAGS="-I$DEPSDIR/libressl-$LIBRESSL_VER/include"
LIBRESSL_LIBS="-Xlinker $LIBSSL -Xlinker $LIBCRYPTO"
LIMD_CFLAGS="$LIBRESSL_CFLAGS -I$DEPSDIR/include"
LIMD_LIBS="$LIBRESSL_CFLAGS -L$DEPSDIR/lib -limobiledevice-1.0 -lplist-2.0"
LIMD_VERSION=`cat /usr/local/libimobiledevice-1.0.pc |grep Version: | cut -d " " -f 2`
IRECV_CFLAGS="-I$DEPSDIR/include"
IRECV_LIBS="-L$DEPSDIR/lib -lirecovery-1.0"
IRECV_VERSION=`cat /usr/local/libirecovery-1.0.pc |grep Version: | cut -d " " -f 2`
IMG4TOOL_CFLAGS="$LIMD_CFLAGS"
IMG4TOOL_LIBS="$LIBRESSL_LIBS -L$DEPSDIR/lib -limg4tool"
IMG4TOOL_VERSION=`cat /usr/local/libimg4tool.pc |grep Version: | cut -d " " -f 2`
./autogen.sh --disable-dependency-tracking --disable-silent-rules --prefix=/usr/local --disable-debug \
  openssl_CFLAGS="$LIBRESSL_CFLAGS" openssl_LIBS="$LIBRESSL_LIBS" openssl_VERSION="$LIBRESSL_VER" \
  libimobiledevice_CFLAGS="$LIMD_CFLAGS" libimobiledevice_LIBS="$LIMD_LIBS" libimobiledevice_VERSION="$LIMD_VERSION" \
  libirecovery_CFLAGS="$IRECV_CFLAGS" libirecovery_LIBS="$IRECV_LIBS" libirecovery_VERSION="$IRECV_VERSION" \
  libimg4tool_CFLAGS="$IMG4TOOL_CFLAGS" libimg4tool_LIBS="$IMG4TOOL_LIBS" libimg4tool_VERSION="$IMG4TOOL_VERSION" \
  CC='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang' CXX='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++' LD='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld' RANLIB='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib' AR='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar' CFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include -DTSSCHECKER_NOMAIN=1 -DIDEVICERESTORE_NOMAIN=1' CXXFLAGS='-isysroot /usr/local/SYSROOT/MacOSX10.13.sdk -isystem=/usr/local/SYSROOT/MacOSX10.13.sdk/usr/include -DTSSCHECKER_NOMAIN=1 -DIDEVICERESTORE_NOMAIN=1' LDFLAGS='-L/usr/local/SYSROOT/MacOSX10.13.sdk/usr/lib -lbz2 -llzma -lcompression -L/usr/local/lib -lusbmuxd-2.0 -framework CoreFoundation -framework IOKit'
cat config.log
echo 'step 4:'
gmake -j16
echo 'step 5:'
gmake -j16 install
echo 'step 6:'
/usr/local/bin/futurerestore || true
echo 'step 7:'
otool -L /usr/local/bin/futurerestore
echo 'step 8:'
mv /usr/local/bin/futurerestore $BASE/futurerestore
echo 'End'
