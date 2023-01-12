#!/bin/bash
# For compiling libimobiledevice, libirecovery, and idevicerestore for Linux/Windows

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig
export JNUM="-j$(nproc)"

rm -rf tmp
mkdir bin tmp 2>/dev/null
cd tmp

set -e

sslver="3.0.7"
if [[ $OSTYPE == "linux"* ]]; then
    platform="linux"
    echo "* Platform: Linux"
    if [[ ! -f "/etc/lsb-release" && ! -f "/etc/debian_version" ]]; then
        echo "[Error] Ubuntu/Debian only"
        exit 1
    fi

    # based on Cryptiiiic's futurerestore static linux compile script
    export DIR=$(pwd)
    export FR_BASE="$DIR"
    if [[ $(uname -m) == "a"* ]]; then
        export CC_ARGS="CC=/usr/bin/gcc CXX=/usr/bin/g++ LD=/usr/bin/ld RANLIB=/usr/bin/ranlib AR=/usr/bin/ar"
        export ALT_CC_ARGS="CC=/usr/bin/gcc CXX=/usr/bin/g++ LD=/usr/bin/ld RANLIB=/usr/bin/ranlib AR=/usr/bin/ar"
    else
        export CC_ARGS="CC=/usr/bin/clang-14 CXX=/usr/bin/clang++-14 LD=/usr/bin/ld64.lld-14 RANLIB=/usr/bin/ranlib AR=/usr/bin/ar"
        export ALT_CC_ARGS="CC=/usr/bin/clang-14 CXX=/usr/bin/clang++-14 LD=/usr/bin/ld.lld-14 RANLIB=/usr/bin/ranlib AR=/usr/bin/ar"
    fi
    export CONF_ARGS="--disable-dependency-tracking --disable-silent-rules --prefix=/usr/local --disable-shared --enable-debug --without-cython"
    export ALT_CONF_ARGS="--disable-dependency-tracking --disable-silent-rules --prefix=/usr/local"
    if [[ $(uname -m) == "a"* && $(getconf LONG_BIT) == 64 ]]; then
        export LD_ARGS="-Wl,--allow-multiple-definition -L/usr/lib/aarch64-linux-gnu -lzstd -llzma -lbz2"
    elif [[ $(uname -m) == "a"* ]]; then
        export LD_ARGS="-Wl,--allow-multiple-definition -L/usr/lib/arm-linux-gnueabihf -lzstd -llzma -lbz2"
    else
        export LD_ARGS="-Wl,--allow-multiple-definition -L/usr/lib/x86_64-linux-gnu -lzstd -llzma -lbz2"
    fi

    echo "If prompted, enter your password"
    sudo echo -n ""
    echo "Compiling..."

    echo "Setting up build location and permissions"
    sudo rm -rf $FR_BASE || true
    sudo mkdir $FR_BASE
    sudo chown -R $USER:$USER $FR_BASE
    sudo chown -R $USER:$USER /usr/local
    sudo chown -R $USER:$USER /lib/udev/rules.d
    cd $FR_BASE
    echo "Done"

    echo "Downloading apt deps"
    sudo apt update
    #sudo apt remove -y libssl-dev libssl3
    sudo apt install aria2 curl build-essential checkinstall git autoconf automake libtool-bin pkg-config cmake zlib1g-dev libbz2-dev libusb-1.0-0-dev libusb-dev libpng-dev libreadline-dev libcurl4-openssl-dev libzstd-dev liblzma-dev -y
    if [[ $(uname -m) != "a"* ]]; then
        curl -LO https://apt.llvm.org/llvm.sh
        chmod 0755 llvm.sh
        sudo ./llvm.sh 14
    fi
    echo "Done"

    echo "Cloning git repos and other deps"
    git clone https://github.com/lzfse/lzfse
    git clone https://github.com/libimobiledevice/libplist
    git clone https://github.com/libimobiledevice/libusbmuxd
    git clone https://github.com/libimobiledevice/libimobiledevice
    git clone https://github.com/libimobiledevice/libirecovery
    #git clone https://github.com/libimobiledevice/libideviceactivation
    #git clone https://github.com/libimobiledevice/libideviceinstaller
    #git clone https://github.com/libimobiledevice/ifuse
    git clone https://github.com/nih-at/libzip
    git clone https://github.com/tihmstar/libgeneral
    git clone https://github.com/tihmstar/libfragmentzip
    if [[ $1 == "old" ]]; then
        git clone --recursive https://github.com/LukeZGD/libipatcher
        git clone --recursive https://github.com/LukeZGD/futurerestore
        git clone https://github.com/LukeZGD/daibutsuCFW
    elif [[ $1 == "new" ]]; then
        git clone https://github.com/tihmstar/img4tool
        git clone --recursive https://github.com/LukeeGD/futurerestore
    fi
    aria2c https://www.openssl.org/source/openssl-$sslver.tar.gz
    aria2c https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
    aria2c https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz

    : '
    echo "Building openssl..."
    tar -zxvf openssl-$sslver.tar.gz
    cd openssl-$sslver
    if [[ $(uname -m) == "a"* && $(getconf LONG_BIT) == 64 ]]; then
        env $CC_ARGS ./Configure enable-ktls linux-aarch64 "-Wa,--noexecstack -fPIC"
    elif [[ $(uname -m) == "a"* ]]; then
        env $CC_ARGS ./Configure enable-ktls linux-generic32 "-Wa,--noexecstack -fPIC"
    else
        env $CC_ARGS ./Configure enable-ktls enable-ec_nistp_64_gcc_128 linux-x86_64 "-Wa,--noexecstack -fPIC"
    fi
    make $JNUM depend $CC_ARGS
    make $JNUM $CC_ARGS
    make install_sw install_ssldirs
    rm -rf /usr/local/lib/libcrypto.so* /usr/local/lib/libssl.so*
    cd ..
    '

    echo "Building lzfse..."
    cd $FR_BASE
    cd lzfse
    make $JNUM $ALT_CC_ARGS
    make $JNUM install

    echo "Building libplist..."
    cd $FR_BASE
    cd libplist
    if [[ $1 == "new" ]]; then
        git reset --hard 787a449
    else
        git reset --hard ec9ba8b
    fi
    git clean -fxd
    ./autogen.sh $CONF_ARGS $CC_ARGS
    make $JNUM
    make $JNUM install

    echo "Building libusbmuxd..."
    cd $FR_BASE
    cd libusbmuxd
    if [[ $1 == "new" ]]; then
        git reset --hard 3eb50a0
    else
        git reset --hard c724e70
    fi
    git reset --hard
    git clean -fxd
    ./autogen.sh $CONF_ARGS $CC_ARGS
    make $JNUM
    make $JNUM install

    echo "Building libimobiledevice..."
    cd $FR_BASE
    cd libimobiledevice
    if [[ $1 == "new" ]]; then
        git reset --hard ca32415
    else
        git reset --hard 3447295
    fi
    git clean -fxd
    ./autogen.sh $CONF_ARGS $CC_ARGS LIBS="-L/usr/local/lib -lz -ldl"
    make $JNUM
    make $JNUM install

    echo "Building libirecovery..."
    cd $FR_BASE
    cd libirecovery
    if [[ $1 == "new" ]]; then
        git reset --hard 4793494
    else
        git reset --hard f78fc4a
    fi
    git clean -fxd
    ./autogen.sh $CONF_ARGS $CC_ARGS
    make $JNUM
    make $JNUM install

    echo "Building libzip..."
    cd $FR_BASE
    cd libzip
    sed -i 's/\"Build shared libraries\" ON/\"Build shared libraries\" OFF/g' CMakeLists.txt
    cmake $CC_ARGS .
    make $JNUM
    make $JNUM install

    echo "Building libbz2..."
    cd $FR_BASE
    tar -zxvf bzip2-1.0.8.tar.gz
    cd bzip2-1.0.8
    make $JNUM
    make $JNUM install

    if [[ $1 == "old" ]]; then
        if [[ $(uname -m) == "x86_64" ]]; then
            curl -LO https://github.com/LukeZGD/daibutsuCFW/releases/download/latest/xpwn_linux.zip
            unzip xpwn_linux.zip -d .
            cp bin/libxpwn.a bin/libcommon.a /usr/local/lib
            cd $FR_BASE
            cd daibutsuCFW/src/xpwn/include
            cp -R * /usr/local/include
        fi

        cd $FR_BASE
        echo "Building libipatcher..."
        cd libipatcher
        ./autogen.sh --disable-shared
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ..
    fi

    compdir=$FR_BASE
    instdir=/usr/local
    echo "Building libgeneral..."
    cd $compdir/libgeneral
    ./autogen.sh --enable-static --disable-shared --prefix="$instdir"
    make
    make install
    make clean

    echo "Building libfragmentzip..."
    cd $compdir/libfragmentzip
    ./autogen.sh --enable-static --disable-shared --prefix="$instdir"
    make CFLAGS="-I$instdir/include"
    make install
    make clean

    if [[ $1 == "new" ]]; then
        echo "Building img4tool..."
        cd $compdir/img4tool
        env LDFLAGS="-L$instdir/lib" ./autogen.sh --enable-static --disable-shared --prefix="$instdir"
        make
        make install
        make clean
    fi

    if [[ $(uname -m) == "a"* ]]; then
        cd $FR_BASE
        curl -LO https://github.com/facebook/zstd/releases/download/v1.5.2/zstd-1.5.2.tar.gz
        tar -zxvf zstd-1.5.2.tar.gz
        cd zstd-1.5.2
        mkdir builddir
        cmake -B builddir \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DCMAKE_INSTALL_LIBDIR=lib \
            -DZSTD_BUILD_CONTRIB=ON \
            -DZSTD_BUILD_TESTS=ON \
            zstd-1.5.2/build/cmake
        cmake --build builddir
        cmake --install
    fi

    cd $FR_BASE
    echo "Building futurerestore!"
    cd futurerestore
    ./autogen.sh $ALT_CONF_ARGS $CC_ARGS LDFLAGS="$LD_ARGS" LIBS="-llzma -lbz2 -lzstd -lcrypto -lz -ldl"
    make $JNUM
    cp futurerestore/futurerestore ../../bin/futurerestore_$platform

elif [[ $OSTYPE == "msys" ]]; then
    platform="win"
    echo "* Platform: Windows MSYS2"

    STATIC=1
    # based on opa334's futurerestore compile script
    pacman -S --needed --noconfirm mingw-w64-x86_64-clang mingw-w64-x86_64-libzip mingw-w64-x86_64-brotli mingw-w64-x86_64-libpng mingw-w64-x86_64-python mingw-w64-x86_64-libunistring mingw-w64-x86_64-curl mingw-w64-x86_64-cython mingw-w64-x86_64-cmake
    pacman -S --needed --noconfirm make automake autoconf pkg-config openssl libtool m4 libidn2 git libunistring libunistring-devel python cython python-devel unzip zip
    export CC=gcc
    export CXX=g++
    export BEGIN_LDFLAGS="-Wl,--allow-multiple-definition"

    echo "Cloning git repos and other deps"
    git clone https://github.com/libimobiledevice/libplist
    git clone https://github.com/libimobiledevice/libusbmuxd
    git clone https://github.com/libimobiledevice/libimobiledevice
    git clone https://github.com/libimobiledevice/libirecovery
    git clone https://github.com/tihmstar/libgeneral
    git clone https://github.com/tihmstar/libfragmentzip
    git clone https://github.com/tihmstar/img4tool
    git clone --recursive https://github.com/LukeeGD/futurerestore
    git clone https://github.com/lzfse/lzfse
    git clone https://github.com/madler/zlib
    wget https://github.com/curl/curl/archive/refs/tags/curl-7_76_1.zip

    cd libgeneral
    git reset --hard b04a27d
    # libgeneral windows fix (allocate memory manually because windows does not support vasprintf)
    sed -i'' 's|vasprintf(&_err, err, ap);|_err=(char*)malloc(1024);vsprintf(_err, err, ap);|' ./libgeneral/exception.cpp
    cd ..
    sed -i'' 's|../include/img4tool/img4tool.hpp|#include "../include/img4tool/img4tool.hpp"|' ./img4tool/img4tool/img4tool.hpp
    sed -i'' 's|../include/img4tool/ASN1DERElement.hpp|#include "../include/img4tool/ASN1DERElement.hpp"|' ./img4tool/img4tool/ASN1DERElement.hpp
    # code borrowed from https://gist.github.com/foxik384/496928d2785e9007d2b838cfa6e019ee
    sed -i'' 's|#include <arpa/inet.h>|#include <winsock2.h>\nvoid* memmem(const void* haystack, size_t haystackLen, const void* needle, size_t needleLen) { if (needleLen == 0 \|\| haystack == needle) { return (void*)haystack; } if (haystack == NULL \|\| needle == NULL) { return NULL; } const unsigned char* haystackStart = (const unsigned char*)haystack; const unsigned char* needleStart = (const unsigned char*)needle; const unsigned char needleEndChr = *(needleStart + needleLen - 1); ++haystackLen; for (; --haystackLen >= needleLen; ++haystackStart) { size_t x = needleLen; const unsigned char* n = needleStart; const unsigned char* h = haystackStart; if (*haystackStart != *needleStart \|\| *(haystackStart + needleLen - 1) != needleEndChr) { continue; } while (--x > 0) { if (*h++ != *n++) { break; } } if (x == 0) { return (void*)haystackStart; } } return NULL; }|' ./img4tool/img4tool/lzssdec.c
    sed -i'' 's|#include <arpa/inet.h>|#include <winsock2.h>|' ./img4tool/img4tool/img4tool.cpp
    # libfragmentzip windows fix (fix file corruption)
    sed -i'' 's|fopen(savepath, \"w\")|fopen(savepath, \"wb\")|' ./libfragmentzip/libfragmentzip/libfragmentzip.c

    if [[ $STATIC == 1 ]]; then
        export STATIC_FLAG="--enable-static --disable-shared"
        export BEGIN_LDFLAGS="$BEGIN_LDFLAGS -all-static"

        git clone https://github.com/google/brotli
        wget https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.gz
        wget https://ftp.gnu.org/gnu/libidn/libidn2-2.3.0.tar.gz
        wget https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz
        wget https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
        wget https://tukaani.org/xz/xz-5.2.4.tar.gz
        wget https://libzip.org/download/libzip-1.5.1.tar.gz

        cd ./lzfse
        make install LDFLAGS="$BEGIN_LDFLAGS" INSTALL_PREFIX=/mingw64
        cd ..

        echo "Building brotli..."
        cd brotli
        git reset --hard 9801a2c
        git clean -fxd
        autoreconf -fi
        ./configure $STATIC_FLAG
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        sed -i'' 's|Requires.private: libbrotlicommon >= 1.0.2|Requires.private: libbrotlicommon >= 0.0.0|' /mingw64/lib/pkgconfig/libbrotlidec.pc
        sed -i'' 's|Requires.private: libbrotlicommon >= 1.0.2|Requires.private: libbrotlicommon >= 0.0.0|' /mingw64/lib/pkgconfig/libbrotlienc.pc
        cd ..

        echo "Building libunistring..."
        tar -zxvf ./libunistring-0.9.10.tar.gz
        cd libunistring-0.9.10
        autoreconf -fi
        ./configure $STATIC_FLAG
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ..

        echo "Building libidn2..."
        tar -zxvf ./libidn2-2.3.0.tar.gz
        cd libidn2-2.3.0
        ./configure $STATIC_FLAG
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ..

        echo "Building libpsl..."
        tar -zxvf libpsl-0.21.1.tar.gz
        cd libpsl-0.21.1
        ./configure $STATIC_FLAG
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ..

        echo "Building bzip2..."
        tar -zxvf bzip2-1.0.8.tar.gz
        cd bzip2-1.0.8
        make $JNUM install LDFLAGS="--static -Wl,--allow-multiple-definition"
        cd ..

        echo "Building zlib..."
        cd zlib
        ./configure --static
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ..

        echo "Building libzip..."
        tar -zxvf libzip-1.5.1.tar.gz
        cd libzip-1.5.1
        mkdir new
        cd new
        cmake .. -DBUILD_SHARED_LIBS=OFF -G"MSYS Makefiles" -DCMAKE_INSTALL_PREFIX="/mingw64" -DENABLE_COMMONCRYPTO=OFF -DENABLE_GNUTLS=OFF -DENABLE_OPENSSL=OFF -DENABLE_MBEDTLS=OFF
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
        cd ../..
    fi

    echo "Building curl..."
    unzip curl-7_76_1.zip -d .
    cd curl-curl-7_76_1
    autoreconf -fi
    ./configure $STATIC_FLAG --with-schannel --without-ssl
    cd lib
    make $JNUM install CFLAGS="-DCURL_STATICLIB -DNGHTTP2_STATICLIB" LDFLAGS="$BEGIN_LDFLAGS"
    cd ../..

    echo "Building libplist..."
    cd libplist
    git reset --hard 787a449
    git clean -fxd
    ./autogen.sh $STATIC_FLAG --without-cython
    make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
    cd ..

    echo "Building libusbmuxd..."
    cd libusbmuxd
    git reset --hard 3eb50a0
    git clean -fxd
    ./autogen.sh $STATIC_FLAG
    make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
    cd ..

    echo "Building libimobiledevice..."
    cd libimobiledevice
    git reset --hard ca32415
    git clean -fxd
    ./autogen.sh $STATIC_FLAG --without-cython
    make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
    cd ..

    echo "Building libirecovery..."
    cd libirecovery
    git reset --hard 4793494
    git clean -fxd
    sed -i'' 's|ret = DeviceIoControl(client->handle, 0x220195, data, length, data, length, (PDWORD) transferred, NULL);|ret = DeviceIoControl(client->handle, 0x2201B6, data, length, data, length, (PDWORD) transferred, NULL);|' src/libirecovery.c
    ./autogen.sh $STATIC_FLAG
    make $JNUM install LDFLAGS="$BEGIN_LDFLAGS -ltermcap"
    cd ..

    cd ./libgeneral
    ./autogen.sh $STATIC_FLAG
    make install LDFLAGS="$BEGIN_LDFLAGS"
    cd ..


    cd ./libfragmentzip
    if [ $IS_STATIC == 1 ]; then
        export curl_LIBS="$(curl-config --static-libs)"
    fi
    ./autogen.sh $STATIC_FLAG
    make install LDFLAGS="$BEGIN_LDFLAGS"
    cd ..

    cd ./img4tool
    ./autogen.sh $STATIC_FLAG
    make install LDFLAGS="$BEGIN_LDFLAGS -lws2_32"
    cd ..

    echo "Building futurerestore!"
    cd ./futurerestore
    # tsschecker windows fixes (fix file corruption)
    sed -i'' 's|fopen(dstPath, \"w\")|fopen(dstPath, \"wb\")|' external/tsschecker/tsschecker/download.c
    sed -i'' 's|fopen(fname, \"w\")|fopen(fname, \"wb\")|' external/tsschecker/tsschecker/tsschecker.c
    ./autogen.sh $STATIC_FLAG
    if [[ $STATIC == 1 ]]; then
        export curl_LIBS="$(curl-config --static-libs)"
        #make $JNUM install CFLAGS="-DCURL_STATICLIB" LDFLAGS="$BEGIN_LDFLAGS" LIBS="-llzma -lbz2 -lbcrypt"
        make CFLAGS="-DCURL_STATICLIB" LDFLAGS="$BEGIN_LDFLAGS" libgeneral_LIBS="-lbcrypt -lws2_32 -llzma -lbz2 -liconv -lunistring -lnghttp2"
    else
        make $JNUM install LDFLAGS="$BEGIN_LDFLAGS"
    fi
    cp futurerestore/futurerestore ../../bin/futurerestore_$platform
fi

echo "Done!"
