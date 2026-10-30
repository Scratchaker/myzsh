# Distrobox enter functions
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

# Check if in box
if [[ -n "$CONTAINER_ID" ]]; then
    # Add/Remove Items from menu
    menuadd() {
        distrobox-export --app "$@"
    }
    menurm() {
        distrobox-export --delete --app "$@"
    }
    binadd() {
        distrobox-export --bin "$@"
    }

    binrm() {
        distrobox-export --delete --bin "$@"
    }
    # Open in host
    alias open='distrobox-host-exec xdg-open'
    alias xdg-open='distrobox-host-exec xdg-open'
    alias host='distrobox-host-exec'
fi
