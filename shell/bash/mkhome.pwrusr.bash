#!/usr/bin/env bash
set -euo pipefail

mk_home_dotsys() {
    local dir="$1"
    local owner="${2:-}"

    mkdir -p "$dir"

    cd "$dir"
    mkdir -p .config .sys

    cd "$dir/.config"
    mkdir -p secret

    cd "$dir/.sys"
    mkdir -p adhoc cache data local mnt of secret state srv sync

    cd "$dir/.sys/secret"
    mkdir -p cache data state

    cd "$dir/.sys/local"
    mkdir -p bin doc etc lib libexec opt share src var

    cd "$dir/.sys/adhoc"
    mkdir -p bin doc etc lib libexec opt share src var

    if [ -n "$owner" ]; then
        cd "$dir"
        chmod -R go-rwx .
        chown -R $owner .
    fi
}

mk_home_pwrusr() {
    local dir="$1"
    local owner="${2:-}"

    mk_home_dotsys "$dir" "$owner"

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
