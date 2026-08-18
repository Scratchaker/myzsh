# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable automatic updates
zstyle ':omz:update' mode disabled

# Plugins
ZSH_DISABLE_COMPFIX=true
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Disable underline in zsh-syntax-highlighting
ZSH_HIGHLIGHT_STYLES[path]=fg=cyan
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green

# Disable history recommendations
ZSH_AUTOSUGGEST_STRATEGY=(completion)

# Disable zsh extended glob expansion
setopt NO_NOMATCH
# Disable hystory save if command starts with space
setopt HIST_IGNORE_SPACE
