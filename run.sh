#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "The run script must be run as root (or sudo)"
    exit
fi

(
    source ~/.anishin

    cd $RYZOM_PATH/server

    if [ "$1" = "clean" ]; then
        rm -f *.log
        rm -rf aes
    fi

    exec shard $1
)
