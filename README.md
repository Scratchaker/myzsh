# myzsh
<img src="assets/prompt.svg" width="400">

## Introduction
This repository contains my personal Zsh configuration.

It is heavily customized around my own workflow, preferences, aliases, functions, keybindings, and development environment. It was never designed to be a general-purpose configuration or a framework for others to use directly.

The main purpose of publishing it is to:
- Keep a version-controlled backup.
- Make it easy to synchronize across my machines.
- Share ideas that others may find useful.

If you decide to use parts of this configuration, expect to modify it to suit your own environment.

## Dependencies
<details>
<summary>Dependig on what features you decide to add you may need some of the following dependencies, for the full setup you will need:</summary>
    
- Zsh
- Oh My Zsh
    - zsh-autosuggestions
    - zsh-syntax-highlighting
- Zoxide
- fzf
- fastfetch
- Distrobox

</details>


## Installation
<details>

<summary><strong>Oh My Zsh</strong></summary>

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

</details>

<details>

<summary><strong>zsh-autosuggestions</strong></summary>

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
```

</details>

<details>

<summary><strong>zsh-syntax-highlighting</strong></summary>

```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

</details>

<details>

<summary><strong>Profile</strong></summary>

Download the repo as a ZIP, extract everything somewhere in your home folder, and append the following to your `~/.zshrc`, replacing `$HOME/path/to/extracted/files` with the path where you extracted the files.

```sh
SCRIPTS_PATH="$HOME/path/to/extracted/files"
for script in "$SCRIPTS_PATH"/*.sh; do
    [ -f "$script" ] && . "$script"
done
unset script
```

</details>
