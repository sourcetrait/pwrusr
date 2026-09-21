if [[ -z ${UENV_USR_SPEC:-} ]]; then
    UENV_USR_SPEC="xdg"
fi
if [[ -z ${UENV_USR_SYS:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) UENV_USR_SYS="$HOME/.sys" ;;
        *) UENV_USR_SYS="$HOME/.local" ;;
    esac
fi
if [[ -z ${UENV_USR_SUBSYS:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) UENV_USR_SUBSYS="$HOME/.sys/of" ;;
        *) UENV_USR_SUBSYS="$HOME" ;;
    esac
fi
if [[ -z ${UENV_USR_LOCAL:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) UENV_USR_LOCAL="$HOME/.sys/local" ;;
        *) UENV_USR_LOCAL="$HOME/.local" ;;
    esac
fi
if [[ -z ${UENV_USR_ADHOC:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) UENV_USR_ADHOC="$HOME/.sys/adhoc" ;;
        *) UENV_USR_ADHOC="$HOME/.local" ;;
    esac
fi


if [ -z "$XDG_CACHE_HOME" ] && [ "$UENV_USR_SPEC" = 'dotsys' ]; then
    export XDG_CACHE_HOME="$HOME/.sys/cache"
fi
if [ -z "$XDG_CONFIG_HOME" ] && [ "$UENV_USR_SPEC" = 'dotsys' ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ] && [ "$UENV_USR_SPEC" = 'dotsys' ]; then
    export XDG_DATA_HOME="$HOME/.sys/data"
fi
if [ -z "$XDG_STATE_HOME" ] && [ "$UENV_USR_SPEC" = 'dotsys' ]; then
    export XDG_STATE_HOME="$HOME/.sys/state"
fi

if [ -d "$HOME/.sys/paths" ] ; then
    for p in $(ls -r "$HOME/.sys/paths"); do
        p="$(realpath "$HOME/.sys/paths/$p")"
        if [ -d "$p" ]; then
            PATH="$p:$PATH"
        fi
    done
fi

export UENV_USR_SPEC UENV_USR_SYS UENV_USR_SUBSYS