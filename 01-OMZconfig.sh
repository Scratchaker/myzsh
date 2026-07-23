# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins
ZSH_DISABLE_COMPFIX=true
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Theme
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode disabled  # disable automatic updates

# Disable underline in zsh-syntax-highlighting
ZSH_HIGHLIGHT_STYLES[path]=fg=cyan
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green

# Disable history recommendations
ZSH_AUTOSUGGEST_STRATEGY=(completion)
