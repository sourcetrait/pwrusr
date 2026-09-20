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

if [ "$#" -ne 2 ]; then
    echo "usage: mkhome.dotsys DIR USR:GRP"
fi

mk_home_dotsys "$(realpath "$1")" "$2"
