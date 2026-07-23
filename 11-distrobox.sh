# Distrobox functions
ubuntu() {
    if [ $# -eq 0 ]; then
        distrobox enter ubuntu
    else
        distrobox enter ubuntu -- zsh -l -i -c "$*"
    fi
}


# Check if in box
if [[ -n "$CONTAINER_ID" ]]; then
    # Add/Remove Items from menu
    menuadd() {
        distrobox-export -a "$@"
    }
    menurm() {
        local app_name="$*"
        local files
        files=(${(f)"$(find "$HOME/.local/share/applications/" -maxdepth 1 -iname "${CONTAINER_ID}-${app_name}.desktop" 2>/dev/null)"})

        if [[ ${#files[@]} -eq 0 ]]; then
            echo "No exported application found matching: ${app_name}"
            return 1
        fi

        rm -f "${files[@]}" && echo -e "Application ${app_name} successfully un-exported.\nOK!\n${app_name} will disappear from your applications list in a few seconds."
    }
    binadd() {
        local bin_path
        bin_path=$(which "$1" 2>/dev/null) || bin_path="$1"
        distrobox-export --bin "$bin_path" --export-path "${2:-$HOME/.local/bin}"
    }

    binrm() {
        local bin_name="${1:t}"  # basename in case full path given
        local export_path="${2:-$HOME/.local/bin}"
        local target="${export_path}/${bin_name}"

        if [[ ! -f "$target" ]]; then
            echo "No exported binary found: ${target}"
            return 1
        fi

        rm -f "$target" && echo -e "Binary ${bin_name} successfully un-exported.\nOK!\n${bin_name} removed from ${export_path}."
    }
    # Open in host
    alias open='xdg-open'
    alias xdg-open='distrobox-host-exec xdg-open'
    alias host='distrobox-host-exec'
fi
