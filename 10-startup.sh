# Define startup script
RUN_FASTFETCH=0
if [ -n "$SSH_TTY" ]; then
    # SSH Session
    RUN_FASTFETCH=0
    clear
fi
case "$(ps -o comm= -p $PPID 2>/dev/null)" in
    guake|yakuake|dolphin|kate|code|codium)
        # Running inside an application where fastfetch should not appear (You may need to add more)
        RUN_FASTFETCH=0
        ;;
esac

if [ "$RUN_FASTFETCH" -eq 1 ]; then
	if [ -f /usr/bin/fastfetch ]; then
        fastfetch --config neofetch
    fi
fi

# Disable zsh extended glob expansion
setopt NO_NOMATCH


# Use a separate history file per distrobox container
if [[ -n "$CONTAINER_ID" ]]; then
    export HISTFILE="$HOME/.zsh_history_${CONTAINER_ID}"
fi
# Use a separate history file in some applications (You may need to add more)
case "$(ps -o comm= -p $PPID 2>/dev/null)" in
    dolphin|kate|code|codium)
        HISTFILE="$HOME/.zsh_history_$(ps -o comm= -p $PPID 2>/dev/null)"
        ;;
esac

