#!/usr/bin/env bash
set -euo pipefail

function mk_usrsys_home {
    local dir="$1"
    local owner="${2:-}"

    mkdir -p "$dir"

    cd "$dir"
    mkdir -p .config bak data doc down mix proj repo sort sys tmp tpl

    cd "$dir/.config"
    mkdir -p secret

    cd "$dir/mix"
    mkdir -p calc img mdl snd txt vid web

    cd "$dir/sys"
    mkdir -p adhoc cache data local mnt of secret state srv sync

    cd "$dir/sys/secret"
    mkdir -p cache data state

    cd "$dir/sys/local"
    mkdir -p bin doc etc lib opt share src var

    cd "$dir/sys/sync"
    mkdir -p as at me

    cd "$dir/sys/adhoc"
    mkdir -p asset cfg data doc exe lib pkg src
    
    if [ -n "$owner" ]; then
        cd "$dir"
        chmod -R go-rwx .
        chown -R $owner .
    fi
}

function mk_pwrusr {
    local dir="$1"
    local owner="${2:-}"

    mk_usrsys_home "$dir" "$owner"

    cd "$dir/sys/data"
    mkdir -p desktop

    cd "$dir/sys/srv"
    mkdir -p git

    cd "$dir/sys/of"
    mkdir -p cargo nu
    
    cd "$dir/sys/of/cargo"
    mkdir -p bin

    cd "$dir/sys/of/nu"
    mkdir -p mod plugins

    cd "$dir/.config"
    mkdir -p nushell

    cd "$dir/.config/nushell"
    if [ -e scripts ] || [ -L scripts ]; then
        mkdir -p "$dir/tmp/retire"
        retire_dir=$(mktemp -dp "$dir/tmp/retire" mkpwrhome.XXXXXX)
        mkdir -p "$retire_dir/.config/nushell"
        mv scripts "$retire_dir/.config/nushell"
    fi
    ln -s ../../sys/of/nu/mod scripts

    cd "$dir/sys/cache"
    mkdir -p cargo
    
    cd "$dir/sys/cache/cargo"
    mkdir -p target

    cd "$dir"
    mkdir -p .ssh

    cd "$dir/.ssh"
    mkdir -p key

    cd "$dir/.ssh/key"
    mkdir -p as at me

    cd "$dir/.ssh"
    if [ ! -f config ]; then
        touch config
    fi
    if [ ! -f authorized_keys ]; then
        touch authorized_keys
    fi

    if [ -n "$owner" ]; then
        cd "$dir"
        chmod -R go-rwx .
        chown -R $owner .
    fi
}

if [ "$#" -ne 2 ]; then
    echo "usage: mkpwrhome DIR USR:GRP"
fi

mk_pwrusr "$(realpath "$1")" "$2"
