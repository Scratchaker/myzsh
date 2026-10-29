# myzsh
<img src="assets/cover.png" width="800">

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
    - zsh-autosuggestions
    - zsh-syntax-highlighting
- powerlevel10k
- Zoxide
- eza
- fzf
- fastfetch
- Distrobox
- Any nerd font, see [here](https://www.nerdfonts.com/font-downloads).

## Installation
<details>
<summary><strong>Dependencies</strong></summary>

**Debian/Ubuntu:**
```
sudo apt install zsh zoxide eza fzf fastfetch distrobox
```

**Fedora:**
```
sudo dnf install zsh zoxide eza fzf fastfetch distrobox
```

**Arch Linux:**
```
sudo pacman -S zsh zoxide eza fzf fastfetch distrobox
```

</details>

<details>
<summary><strong>Oh My Zsh & plugins</strong></summary>

**Oh My Zsh:**
```
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**zsh-autosuggestions:**
```
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
```

**zsh-syntax-highlighting:**
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

</details>

<details>
<summary><strong>powerlevel10k</strong></summary>

Install powerlevel10k:

```
 git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
```
Install my config:

Copy the `.p10k.zsh` file in the repo to `~/.p10k.zsh`:

```
 [ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup"
 curl -Lf "https://raw.githubusercontent.com/Scratchaker/myzsh/main/.p10k.zsh" -o "$HOME/.p10k.zsh"
```

</details>

<details>
<summary><strong>Shell Profile</strong></summary>

Download the repo as a ZIP, extract every `.sh` file somewhere in your home folder, and append the following to your `~/.zshrc`, replacing `$HOME/path/to/extracted/files` with the path where you extracted the files.

```
SCRIPTS_PATH="$HOME/path/to/extracted/files"
for script in "$SCRIPTS_PATH"/*.sh; do
    [ -f "$script" ] && . "$script"
done
unset script
```
<details>
    <summary>Or automatically:</summary>

```
 [ -d "$HOME/.zshrc.d" ] && mv "$HOME/.zshrc.d" "$HOME/.zshrc.d.backup"
 mkdir -p "$HOME/.zshrc.d"
 for f in {01-OMZconfig,02-env,03-exports,04-evals,05-aliases,06-functions,07-path,08-prompt,09-toolsconfig,10-startup,11-distrobox,12-end}.sh; do
   curl -Lf "https://raw.githubusercontent.com/Scratchaker/myzsh/main/$f" -o "$HOME/.zshrc.d/$f"
 done
 cat << 'EOF' >> "$HOME/.zshrc"
# Scratchaker/myzsh
SCRIPTS_PATH="$HOME/.zshrc.d"
for script in "$SCRIPTS_PATH"/*.sh; do [ -f "$script" ] && . "$script"; done; unset script
EOF
```
    
</details>
</details>

<details>
<summary><strong>Fastfetch config</strong></summary>

Copy the `.config/fastfetch/config.jsonc` file in the repo to `~/.config/fastfetch/config.jsonc`:

```
 [ -f "$HOME/.config/fastfetch/config.jsonc" ] && mv "$HOME/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc.backup"
 mkdir -p "$HOME/.config/fastfetch"
 curl -Lf "https://raw.githubusercontent.com/Scratchaker/myzsh/main/.config/fastfetch/config.jsonc" -o "$HOME/.config/fastfetch/config.jsonc"
```

</details>

<details>
<summary><strong>Font</strong></summary>

Automatically download and install MesloLG Nerd Font (or another of your preference):

```
mkdir -p ~/.local/share/fonts/Meslo && curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip -o /tmp/Meslo.zip && unzip -o /tmp/Meslo.zip -d ~/.local/share/fonts/Meslo && fc-cache -fv
```

Then set `MesloLGS Nerd Font Mono` font in your terminal configuration.

</details>

<details>
<summary><strong>Change shell</strong></summary>

To change your default shell to zsh run:

```
chsh -s /usr/bin/zsh
```

This may break changes you made to `~/.profile`, write the following to `~/.zprofile` to load them:
```
# Load ~/.profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
```

Or run:

```
 cat << 'EOF' >> "$HOME/.zprofile"

# Load ~/.profile
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
EOF
```

</details>
