#!/bin/sh

if [ ! -d build ]; then
    mkdir build
fi

(
    cd build

    if [ ! -d ryzom-common ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-common.git
    else
        ( cd ryzom-common; git pull https://github.com/anishin-mmorpg/ryzom-common.git )
    fi

    if [ ! -d ryzom-nel ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-nel.git
    else
        ( cd ryzom-nel; git pull https://github.com/anishin-mmorpg/ryzom-nel.git )
    fi

    if [ ! -d ryzom-server ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-server.git
    else
        ( cd ryzom-server; git pull https://github.com/anishin-mmorpg/ryzom-server.git )
    fi

    if [ ! -d ryzom-tools ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-tools.git
    else
        ( cd ryzom-tools; git pull https://github.com/anishin-mmorpg/ryzom-tools.git )
    fi
)

if [ ! -d build/code ]; then
    mkdir build/code
fi

if [ ! -d build/code/ryzom ]; then
    mkdir build/code/ryzom
fi

(
    cd build/code

    if [ ! -L nel ]; then
        ln -s ../ryzom-nel nel
    fi
)

(
    cp CMakeLists-Ryzom.txt build/code/ryzom/CMakeLists.txt
    cd build/code/ryzom

    if [ ! -L common ]; then
        ln -s ../../ryzom-common common
    fi

    if [ ! -L server ]; then
        ln -s ../../ryzom-server server
    fi

    if [ ! -L tools ]; then
        ln -s ../../ryzom-tools tools
    fi
)

(
    cd build

    RYZOM_PATH="$(pwd)/code/ryzom"
    PATH=$PATH:$RYZOM_PATH/tools/scripts/linux

    cmake -DWITH_NEL=ON -DWITH_RYZOM_SERVER=ON -DWITH_STATIC=ON -DWITH_STATIC_DRIVERS=ON -DWITH_GUI=OFF \
          -DWITH_RYZOM_CLIENT=OFF -DWITH_DRIVER_OPENGL=OFF -DWITH_DRIVER_OPENAL=OFF -DWITH_SOUND=OFF \
          -DWITH_NEL_TOOLS=OFF -DWITH_RYZOM_TOOLS=OFF -DWITH_NEL_TESTS=OFF -DWITH_NEL_SAMPLES=OFF ..

    make
    make install
)
