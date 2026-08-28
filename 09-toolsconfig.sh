# fzf config
eval "$(fzf --zsh)"

# zoxide config
eval "$(zoxide init zsh --cmd cd)"

# Prompt for installation when no packcage found
# Debian/Ubuntu (apt)
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found
# Arch Linux (pacman)
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && . /usr/share/doc/pkgfile/command-not-found.zsh
# Fedora/RHEL (dnf)
[[ -f /usr/libexec/pk-command-not-found ]] && . /usr/libexec/pk-command-not-found
