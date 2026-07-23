# fzf config
eval "$(fzf --zsh)"

# zoxide config
eval "$(zoxide init zsh --cmd cd)"

# Prompt for installation when no packcage found
[[ -f /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

