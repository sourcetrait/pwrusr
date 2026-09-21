#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(path=$(realpath -- "${BASH_SOURCE[0]}") && dirname -- "$path")

mk_home_pwrusr() {
    local dir="$1"
    local owner="${2:-}"

    "$SCRIPT_DIR/mkhome.dotsys.bash" "$dir" "$owner"

    cd "$dir"
    mkdir -p bak data doc down mix proj repo sort tmp tpl

    cd "$dir/mix"
    mkdir -p calc img mdl snd txt vid web

    cd "$dir/.sys/sync"
    mkdir -p as at me

    cd "$dir/.sys/data"
    mkdir -p desktop

    cd "$dir/.sys/srv"
    mkdir -p git

    cd "$dir/.sys/of"
    mkdir -p cargo

    cd "$dir/.sys/of/cargo"
    mkdir -p bin

    cd "$dir/.sys/local/libexec"
    mkdir -p nushell

    cd "$dir/.sys/adhoc/libexec"
    mkdir -p nushell

    cd "$dir/.config"
    mkdir -p nushell

    cd "$dir/.config/nushell"
    mkdir -p scripts

    cd "$dir/.sys/cache"
    mkdir -p cargo

    cd "$dir/.sys/cache/cargo"
    mkdir -p target

    cd "$dir"
    mkdir -p .ssh

    cd "$dir/.ssh"
    mkdir -p sync

    cd "$dir/.ssh/sync"
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

mk_home_pwrusr "$(realpath "$1")" "$2"
