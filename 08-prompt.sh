# Adapted from: https://gist.github.com/loudambiance/a41b42a4295bce6e7304
# Original author: Daniel Baucom (https://gist.github.com/loudambiance)

case "$(ps -o comm= -p $PPID 2>/dev/null)" in
    dolphin|code|codium)
        # Reduce prompt if in dolphin or VSCode
        PROMPT='%~ %(#.#.$) '
        return
        ;;
    *)
        #return
        ;;
esac

unset PROMPT RPROMPT
##########################################################
# Please edit "User Configuration" section before using  #
##########################################################

#=========================================================
# Terminal Color Codes
# In zsh, use %F{color} / %f for prompt colors with %{ %} for non-printing sequences
# For PS1 with raw ANSI escapes (like bash), we use print -P or $'...' syntax.
# Here we use the same ANSI escape approach for compatibility.
#=========================================================
WHITE=$'%{\033[1;37m%}'
LIGHTGRAY=$'%{\033[0;37m%}'
GRAY=$'%{\033[1;30m%}'
BLACK=$'%{\033[0;30m%}'
RED=$'%{\033[0;31m%}'
LIGHTRED=$'%{\033[1;31m%}'
GREEN=$'%{\033[0;32m%}'
LIGHTGREEN=$'%{\033[1;32m%}'
BROWN=$'%{\033[0;33m%}'   # Orange
YELLOW=$'%{\033[1;33m%}'
BLUE=$'%{\033[0;34m%}'
LIGHTBLUE=$'%{\033[1;34m%}'
PURPLE=$'%{\033[0;35m%}'
PINK=$'%{\033[1;35m%}'    # Light Purple
CYAN=$'%{\033[0;36m%}'
LIGHTCYAN=$'%{\033[1;36m%}'
DEFAULT=$'%{\033[0m%}'

#=========================================================
# User Configuration
#=========================================================
# Colors
cLINES=$GRAY        # Lines and Arrow
cBRACKETS=$GRAY     # Brackets around each data item
cERROR=$LIGHTRED    # Error block when previous command did not return 0
cTIME=$LIGHTGRAY    # The current time
cMPX1=$YELLOW       # Color for terminal multiplexer threshold 1
cMPX2=$RED          # Color for terminal multiplexer threshold 2
cBGJ1=$YELLOW       # Color for background job threshold 1
cBGJ2=$RED          # Color for background job threshold 2
cSTJ1=$YELLOW       # Color for stopped job threshold 1
cSTJ2=$RED          # Color for stopped job threshold 2
cSSH=$PINK          # Color for brackets if session is an SSH session
cUSR=$LIGHTBLUE     # Color of user
cUHS=$GRAY          # Color of the user and hostname separator
cHST=$LIGHTGREEN    # Color of hostname
cRWN=$RED           # Color of root warning
cPWD=$BLUE          # Color of current directory
cCMD=$DEFAULT       # Color of the command you type

# Enable blocks
eNL=0   # Have a newline between previous command output and new prompt
eERR=1  # Previous command return status tracker
eMPX=1  # Terminal multiplexer tracker enabled
eSSH=1  # Track if session is SSH
eBGJ=1  # Track background jobs
eSTJ=0  # Track stopped jobs
eUSH=1  # Show user and host
ePWD=1  # Show current directory

# Block settings
MPXT1="0"  # Terminal multiplexer threshold 1 value
MPXT2="2"  # Terminal multiplexer threshold 2 value
BGJT1="0"  # Background job threshold 1 value
BGJT2="2"  # Background job threshold 2 value
STJT1="0"  # Stopped job threshold 1 value
STJT2="2"  # Stopped job threshold 2 value
UHS="@"

setopt PROMPT_SUBST  # Enable parameter/command substitution in PROMPT

function promptcmd() {
    PREVRET=$?
    PS1=""
    #=========================================================
    # Check if user is in SSH session
    #=========================================================
    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH2_CLIENT ]]; then
        lSSH_FLAG=1
    else
        lSSH_FLAG=0
    fi

    #=========================================================
    # Insert a new line to clear space from previous command
    #=========================================================
    #PS1=$'\n'

    #=========================================================
    # Beginning of first line (arrow wrap around and color setup)
    # zsh uses $'\xNN' for escape sequences; box-drawing chars same as bash
    #=========================================================
    PS1="${PS1}${cLINES}"$'\342\224\214\342\224\200'

    #=========================================================
    # Detached Screen / tmux Sessions
    #=========================================================
    local hTMUX=0 hSCREEN=0 MPXC=0

    [[ -n $commands[tmux] ]]   && hTMUX=1
    [[ -n $commands[screen] ]] && hSCREEN=1

    local screen_count=0 tmux_count=0
    if (( hSCREEN )); then
        screen_count=$(screen -ls 2>/dev/null | grep -c -i detach) || screen_count=0
    fi
    if (( hTMUX )); then
        tmux_count=$(tmux ls 2>/dev/null | grep -c -i -v attach) || tmux_count=0
    fi
    MPXC=$(( screen_count + tmux_count ))

    if (( MPXC > MPXT2 )); then
        PS1="${PS1}${cBRACKETS}[${cMPX2}"$'\342\230\220'":${MPXC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    elif (( MPXC > MPXT1 )); then
        PS1="${PS1}${cBRACKETS}[${cMPX1}"$'\342\230\220'":${MPXC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    fi

    #=========================================================
    # Backgrounded running jobs
    # zsh: use $jobstates or 'jobs -r'; jobs output differs slightly
    #=========================================================
    local BGJC
    BGJC=$(jobs -r 2>/dev/null | wc -l)
    BGJC=${BGJC// /}  # trim whitespace

    if (( BGJC > BGJT2 )); then
        PS1="${PS1}${cBRACKETS}[${cBGJ2}&:${BGJC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    elif (( BGJC > BGJT1 )); then
        PS1="${PS1}${cBRACKETS}[${cBGJ1}&:${BGJC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    fi

    #=========================================================
    # Stopped Jobs (disabled by default, same as original)
    #=========================================================
    # local STJC
    # STJC=$(jobs -s 2>/dev/null | wc -l)
    # STJC=${STJC// /}
    # if (( STJC > STJT2 )); then
    #     PS1="${PS1}${cBRACKETS}[${cSTJ2}"$'\342\234\227'":${STJC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    # elif (( STJC > STJT1 )); then
    #     PS1="${PS1}${cBRACKETS}[${cSTJ1}"$'\342\234\227'":${STJC}${cBRACKETS}]${cLINES}"$'\342\224\200'
    # fi

    #=========================================================
    # Distrobox container indicator
    #=========================================================
    if [[ -n "$CONTAINER_ID" ]]; then
        PS1="${PS1}${cBRACKETS}[${CYAN}box:${CONTAINER_ID}${cBRACKETS}]${cLINES}"$'\342\224\200'
    fi

    #=========================================================
    # Python virtual environment
    #=========================================================
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venvName=${VIRTUAL_ENV:t}  # zsh :t modifier = basename
        PS1="${PS1}${cBRACKETS}[${LIGHTGREEN}python-venv:${venvName}${cBRACKETS}]${cLINES}"$'\342\224\200'
    fi

    #=========================================================
    # Second Static block - User@host
    # zsh: $UID for numeric uid; use %n for username, %m for hostname in prompts
    # but since we're building PS1 manually, use $USER and $HOST
    #=========================================================
    local sesClr
    if (( lSSH_FLAG )); then
        sesClr="$cSSH"
    else
        sesClr="$cBRACKETS"
    fi

    if (( EUID == 0 )); then
        PS1="${PS1}${sesClr}[${cRWN}!"
    else
        PS1="${PS1}${sesClr}[${cUSR}${USER}${cUHS}${UHS}"
    fi
    PS1="${PS1}${cHST}${HOST}${sesClr}]${cLINES}"$'\342\224\200'

    #=========================================================
    # Third Static Block - Current Directory
    # zsh: $PWD works; use ${PWD/#$HOME/~} to show ~ for home
    #=========================================================
    local displayPWD="${PWD/#$HOME/~}"
    PS1="${PS1}[${cPWD}${displayPWD}${cBRACKETS}]"

    #=========================================================
    # Second Line
    # zsh: use %# for prompt character (# if root, $ otherwise)
    #=========================================================
    PS1="${PS1}"$'\n'"${cLINES}"$'\342\224\224\342\224\200\342\224\200'"${BLUE}\$ ${cCMD}"
}

function load_prompt() {
    local parent_process my_process
    parent_process=$(ps -p "$PPID" -o comm= 2>/dev/null)
    my_process=$(ps -p "$$" -o comm= 2>/dev/null)

    if [[ $parent_process == script* ]]; then
        unset PROMPT_COMMAND 2>/dev/null
        PS1="%* - %! - %n@%M { %~ }%# "
    elif [[ $parent_process == emacs* || $parent_process == xemacs* ]]; then
        unset PROMPT_COMMAND 2>/dev/null
        PS1="%n@%m { %~ }%# "
    else
        export DAY=$(date +%A)
        # zsh uses precmd hook instead of PROMPT_COMMAND
        precmd() { promptcmd; }
    fi

    export PS1
}

load_prompt
