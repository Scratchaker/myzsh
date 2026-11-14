# fzf config
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# zoxide config
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

# Prompt for installation when no packcage found
# Debian/Ubuntu (apt)
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found
# Arch Linux (pacman)
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && . /usr/share/doc/pkgfile/command-not-found.zsh
# Fedora (PackageKit)
[[ -f /etc/profile.d/PackageKit.sh ]] && . /etc/profile.d/PackageKit.sh
