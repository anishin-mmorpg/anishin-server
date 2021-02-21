#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "The build script must be run as root (or sudo)"
    exit
fi

if [ "$1" = "clean" ]; then
    rm -Rf build/build
    rm -Rf build/lib
    exit
fi

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

    if [ ! -d ryzom-nelns ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-nelns.git
    else
        ( cd ryzom-nelns; git pull https://github.com/anishin-mmorpg/ryzom-nelns.git )
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

    if [ ! -d ryzom-web ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-web.git
    else
        ( cd ryzom-web; git pull https://github.com/anishin-mmorpg/ryzom-web.git )
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

    if [ ! -L nelns ]; then
        ln -s ../ryzom-nelns nelns
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

    cmake -DWITH_NEL=ON -DWITH_NELNS=ON -DWITH_RYZOM_SERVER=ON -DWITH_STATIC=ON -DWITH_STATIC_DRIVERS=ON \
          -DWITH_RYZOM_CLIENT=OFF -DWITH_DRIVER_OPENGL=OFF -DWITH_DRIVER_OPENAL=OFF -DWITH_SOUND=OFF \
          -DWITH_NEL_TOOLS=OFF -DWITH_RYZOM_TOOLS=OFF -DWITH_NEL_TESTS=OFF -DWITH_NEL_SAMPLES=OFF -DWITH_GUI=OFF ..

    make
    make install
)

if [ ! -d /var/www/html-backup ]; then
    mv /var/www/html /var/www/html-backup
fi

cp -R build/ryzom-web/public_php /var/www/html
cp -R build/ryzom-web/private_php /var/www/private_php

if [ ! -d /var/www/html/login/logs ]; then
    mkdir /var/www/html/login/logs
fi

chmod a+w /var/www/html/login/logs/
chmod a+w /var/www/html/admin/graphs_output/
chmod a+w /var/www/html/admin/templates/default_c/
chmod a+w /var/www/html/ams/cache/
chmod a+w /var/www/html/ams/templates_c/
chmod a+w /var/www/html/
chmod a+w /var/www/private_php/ams/tmp/

chmod a+x build/code/ryzom/tools/scripts/linux/*

if [ $(logname) = "root" ]; then
    HOME="/root"
else
    HOME="/home/$(logname)"
fi

if [ -z "$RYZOM_PATH" ]; then
    echo "" >> "$HOME/.bashrc"
    echo "export RYZOM_PATH=$(pwd)/build/code/ryzom" >> "$HOME/.bashrc"
    echo "export PATH=\$PATH:\$RYZOM_PATH/tools/scripts/linux" >> "$HOME/.bashrc"

    su --session-command "exec bash" $(logname)
fi
