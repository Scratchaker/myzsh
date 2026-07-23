# myzsh
## Introduction
This repository contains my personal Zsh configuration.

It is heavily customized around my own workflow, preferences, aliases, functions, keybindings, and development environment. It was never designed to be a general-purpose configuration or a framework for others to use directly.

The main purpose of publishing it is to:
- Keep a version-controlled backup.
- Make it easy to synchronize across my machines.
- Share ideas that others may find useful.

If you decide to use parts of this configuration, expect to modify it to suit your own environment.

## Dependencies
Dependig on what features you decide to add you may need some of the following dependencies, for the full setup you will need:
- Zsh
- Oh My Zsh
    - git
    - zsh-autosuggestions
    - zsh-syntax-highlighting
- Zoxide
- fzf
- fastfetch
- Docker
- Distrobox

## Installation
Download all files in the repo, extract them somewere in your home folder and append the following to your `~/.zshrc` replacing `$HOME/path/to/extracted/files` with the path where you extracted the files.

```
SCRIPTS_PATH="$HOME/path/to/extracted/files"
for script in $SCRIPTS_PATH/*.sh; do
    [ -f "$script" ] && . "$script"
done
```
