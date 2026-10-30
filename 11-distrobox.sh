# Distrobox
if [[ -n "$CONTAINER_ID" ]]; then
    # In box
    # Add/Remove Items from menu
    menuadd() {
        [ $# -eq 0 ] && return 1
        distrobox-export --app "$@"
    }
    menurm() {
        [ $# -eq 0 ] && return 1
        distrobox-export --delete --app "$@"
    }
    binadd() {
        [ $# -eq 0 ] && return 1
        distrobox-export --bin "$@"
    }

    binrm() {
        [ $# -eq 0 ] && return 1
        distrobox-export --delete --bin "$@"
    }
    # Open in host
    alias open='distrobox-host-exec xdg-open'
    alias xdg-open='distrobox-host-exec xdg-open'
    alias host='distrobox-host-exec'
else
    # In host
    ubuntu-box() {
        if [ $# -eq 0 ]; then
            distrobox enter ubuntu
        else
            distrobox enter ubuntu -- "$SHELL" -l -c "$*"
        fi
    }
    debian-box() {
        if [ $# -eq 0 ]; then
            distrobox enter debian
        else
            distrobox enter debian -- "$SHELL" -l -c "$*"
        fi
    }
    fedora-box() {
        if [ $# -eq 0 ]; then
            distrobox enter fedora
        else
            distrobox enter fedora -- "$SHELL" -l -c "$*"
        fi
    }
    arch-box() {
        if [ $# -eq 0 ]; then
            distrobox enter arch
        else
            distrobox enter arch -- "$SHELL" -l -c "$*"
        fi
    }
fi
