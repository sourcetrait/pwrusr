#!/usr/bin/bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
    echo "usage: mkpwrhome DIR USR GRP"
fi

DIR="$1"
USR="$2"
GRP="$3"

MK_DESKTOP=1
MK_GIT=1
MK_RUST=1
MK_NU=1
MK_SSH=1
MK_OWN=1

mkdir -p $DIR

cd $DIR
mkdir -p .config bak data doc down mix proj repo sort sys tmp tpl

cd $DIR/.config
mkdir -p secret

cd $DIR/mix
mkdir -p calc img mdl snd txt vid web

cd $DIR/sys
mkdir -p cache data local mnt of secret state srv sync use

cd $DIR/sys/secret
mkdir -p cache data state

cd $DIR/sys/local
mkdir -p bin doc etc lib opt share src var

cd $DIR/sys/sync
mkdir -p as at me

cd $DIR/sys/use
mkdir -p asset cfg data doc exe lib pkg src

if [ $MK_DESKTOP ]; then
    cd $DIR/sys/data
    mkdir -p desktop
fi

if [ $MK_GIT ]; then
    cd $DIR/sys/srv
    mkdir -p git
fi

if [ $MK_NU ]; then
    cd $DIR/sys/of
    mkdir -p nu

    cd $DIR/sys/of/nu
    mkdir -p exe mod

    cd $DIR/.config
    mkdir -p nushell

    cd $DIR/.config/nushell
    if [ -e scripts ] || [ -L scripts ]; then
        RETIRE_DIR=$(mktemp -d $DIR/tmp/retire/mkpwrhome.XXXXXX)
        mkdir -p $RETIRE_DIR/.config/nushell
        mv scripts $RETIRE_DIR/.config/nushell
    fi
    ln -s ../../sys/of/nu/mod scripts
fi

if [ $MK_RUST ]; then
    cd $DIR/sys/cache
    mkdir -p cargo
    
    cd $DIR/sys/cache/cargo
    mkdir -p target
fi

if [ $MK_SSH ]; then
    cd $DIR
    mkdir -p .ssh

    cd $DIR/.ssh
    mkdir -p key

    cd $DIR/.ssh/key
    mkdir -p as at me

    cd $DIR/.ssh
    if [ ! -f config ]; then
        touch config
    fi
    if [ ! -f authorized_keys ]; then
        touch authorized_keys
    fi
fi

if [ $MK_OWN ]; then
    cd $DIR
    chmod -R go-rwx .
    chown -R $USR:$GRP .
fi

