#!/usr/bin/env bash
set -euo pipefail

mk_home_dotsys() {
    local dir="$1"
    local owner="${2:-}"

    mkdir -p "$dir"

    cd "$dir"
    mkdir -p .config .sys

    cd "$dir/.sys"
    mkdir -p adhoc cache data env local mnt of ptr secret state srv sync

    cd "$dir/.sys/secret"
    mkdir -p config cache data state
    
    cd "$dir/.sys/local"
    mkdir -p bin doc etc lib libexec opt src

    cd "$dir/.sys/adhoc"
    mkdir -p bin doc etc lib libexec opt src

    cd "$dir/.sys/env"
    mkdir -p ptr/PATH
    
    cd "$dir/.sys/env/ptr/PATH"
    ln -s ../../../adhoc/bin 0.adhoc-bin
    ln -s ../../../local/bin 1.local-bin

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
