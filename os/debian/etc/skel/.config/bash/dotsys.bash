# Expects UENV
: "${UENV_USR_SYS:?dotsys.bash requires uenv.bash}"

dotsys_env_path() {
    local -
    set -euo pipefail
    local dir="$UENV_USR_SYS/env/ptr/PATH"
    local link target
    
    [[ -d $dir ]] || return 0
    
    for link in "$dir"/*; do
        [[ -L $link ]] || continue

        if ! target=$(readlink -e -- "$link"); then
            printf 'dotsys.bash: dangling env PATH symlink: %s\n' "$link" >&2
            continue
        fi
        if [[ ! -d $target ]]; then
            printf 'dotsys.bash: env PATH target is not a directory: %s\n' "$target" >&2
            continue
        fi

        PATH="$target${PATH:+:$PATH}"
    done

    export PATH
}

dotsys_env() {
    local -
    set -euo pipefail
    local dir="$UENV_USR_SYS/env"
    local path name value

    [[ -d $dir ]] || return 0
    
    for path in "$dir"/*; do
        [[ -f $path ]] || continue
        
        name=${path##*/}
        if [[ ! $name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            printf 'dotsys.bash: invalid env var name: %s in %s\n' "$name" "$dir" >&2
            continue
        fi
        
        value=$(<"$path")
        declare -gx "$name=$value"
    done

    dotsys_env_path
}

dotsys_env
