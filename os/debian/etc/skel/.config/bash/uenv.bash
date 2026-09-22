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

if [[ -z ${XDG_CACHE_HOME:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) XDG_CACHE_HOME="$HOME/.sys/cache" ;;
        *) XDG_CACHE_HOME="$HOME/.cache" ;;
    esac
fi
if [[ -z ${XDG_CONFIG_HOME:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) XDG_CONFIG_HOME="$HOME/.config" ;;
        *) XDG_CONFIG_HOME="$HOME/.config" ;;
    esac
fi
if [[ -z ${XDG_DATA_HOME:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) XDG_DATA_HOME="$HOME/.sys/data" ;;
        *) XDG_DATA_HOME="$HOME/.local/share" ;;
    esac
fi
if [[ -z ${XDG_STATE_HOME:-} ]]; then
    case $UENV_USR_SPEC in
        dotsys) XDG_STATE_HOME="$HOME/.sys/state" ;;
        *) XDG_STATE_HOME="$HOME/.local/state" ;;
    esac
fi

UENV_USR_CACHE="$XDG_CACHE_HOME"
UENV_USR_CONFIG="$XDG_CONFIG_HOME"
UENV_USR_DATA="$XDG_DATA_HOME"
UENV_USR_STATE="$XDG_STATE_HOME"

if [ -d "$HOME/.sys/ptr/env/path" ] ; then
    for p in $(ls -r "$HOME/.sys/ptr/env/path"); do
        p="$(realpath "$HOME/.sys/ptr/env/path/$p")"
        if [ -d "$p" ]; then
            PATH="$p:$PATH"
        fi
    done
fi

export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME
export UENV_USR_CACHE UENV_USR_CONFIG UENV_USR_DATA UENV_USR_STATE
export UENV_USR_SPEC UENV_USR_SYS UENV_USR_SUBSYS
export UENV_USR_ADHOC UENV_USR_LOCAL