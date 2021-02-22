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

if [ ! -d build/code ]; then
    mkdir build/code
fi

if [ ! -d build/code/ryzom ]; then
    mkdir build/code/ryzom
fi

(
    cd build/code

    if [ ! -d nel ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-nel.git nel
    else
        ( cd nel; git pull )
    fi

    if [ ! -d nelns ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-nelns.git nelns
    else
        ( cd nelns; git pull )
    fi

    if [ ! -d web ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-web.git web
    else
        ( cd web; git pull )
    fi
)

(
    cp CMakeLists-Ryzom.txt build/code/ryzom/CMakeLists.txt
    cd build/code/ryzom

    if [ ! -d common ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-common.git common
    else
        ( cd common; git pull )
    fi

    if [ ! -d server ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-server.git server
    else
        ( cd server; git pull )
    fi

    if [ ! -d tools ]; then
        git clone https://github.com/anishin-mmorpg/ryzom-tools.git tools
    else
        ( cd tools; git pull )
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
    cp -r /var/www/html /var/www/html-backup
fi

if [ -f /var/www/html/config.php ]; then
    cp /var/www/html/config.php build/code/web/public_php/config.php
fi

rm -rf /var/www/html
cp -r build/code/web/public_php /var/www/html

rm -rf /var/www/private_php
cp -r build/code/web/private_php /var/www/private_php

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

chmod a+w build/code/ryzom/server
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

    exec su --session-command bash $(logname)
fi
