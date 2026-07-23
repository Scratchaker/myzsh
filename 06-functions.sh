# Other functions
pyvenv() {
    local venvDir="${1:-venv}"

    if [[ ! -d "$venvDir" ]]; then
        echo "Creating venv at '$venvDir'..."
        python3 -m venv "$venvDir" || return 1
    fi

    source "$venvDir/bin/activate"
}
detach() {
    (nohup "$@" &>/dev/null &)
}
extract() { # From: https://github.com/ChrisTitusTech/mybash
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "Don't know how to extract '$archive'..." >&2
			;;
			esac
		else
			echo "'$archive' is not a valid file!" >&2
		fi
	done
}
mkcd() {
    mkdir -p "$*"
    cd "$*"
}
cls() {
	clear
	if [ "$RUN_FASTFETCH" -eq 1 ]; then
		if [ -f /usr/bin/fastfetch ]; then
			fastfetch --config neofetch
		fi
	fi
}
cpp() {  # From: https://github.com/ChrisTitusTech/mybash
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpcd() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvcd() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}


# Temporary container for testing
container(){
    docker run --rm -it debian:latest bash -c "\
    echo 'Pulling package lists...' &&\
    apt update > /dev/null 2>&1 &&\
    echo 'Upgrading...' &&\
    apt upgrade -y > /dev/null 2>&1 &&\
    echo 'Installing packcages...' &&\
    apt install -y git nano curl wget vim > /dev/null 2>&1 &&\
    cd && exec bash"
}


# Packcage manager functions
_pkg_manager() { # Detect packcage manager
  if command -v yay &>/dev/null; then echo "yay"
  elif command -v paru &>/dev/null; then echo "paru"
  elif command -v pacman &>/dev/null; then echo "pacman"
  elif command -v apt &>/dev/null; then echo "apt"
  elif command -v dnf &>/dev/null; then echo "dnf"
  else echo ""
  fi
}

pkgif() { # PaKcaGe Install Fuzzyly
  local mgr
  mgr=$(_pkg_manager)
  case "$mgr" in
    yay|paru)
      "$mgr" -Slq | sort -u | fzf --multi --preview "$mgr -Sii {1}" --preview-window=down:75% | xargs -ro "$mgr" -S
      ;;
    pacman)
      pacman -Ssq | sort -u | fzf --multi --preview "pacman -Si {1} 2>/dev/null || pacman -Qi {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo pacman -S
      ;;
    apt)
      apt-cache pkgnames | fzf --multi --preview "apt-cache show {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo apt install
      ;;
    dnf)
      dnf repoquery --available -q 2>/dev/null | fzf --multi --preview "dnf info {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo dnf install
      ;;
    *)
      echo "No supported package manager found."
      return 1
      ;;
  esac
}

pkgrf() { # PaKcaGe Remove Fuzzyly
  local mgr
  mgr=$(_pkg_manager)
  case "$mgr" in
    yay|paru)
      "$mgr" -Qq | fzf --multi --preview "$mgr -Si {1} 2>/dev/null || $mgr -Qi {1} 2>/dev/null" --preview-window=down:75% | xargs -ro "$mgr" -R
      ;;
    pacman)
      pacman -Qq | fzf --multi --preview "pacman -Si {1} 2>/dev/null || pacman -Qi {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo pacman -R
      ;;
    apt)
      dpkg-query -W -f='${Package}\n' | fzf --multi --preview "apt-cache show {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo apt remove
      ;;
    dnf)
      dnf list installed 2>/dev/null | awk 'NR>1 {print $1}' | cut -d. -f1 | fzf --multi --preview "dnf info {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo dnf remove
      ;;
    *)
      echo "No supported package manager found."
      return 1
      ;;
  esac
}

pkgpf() { # PaKcaGe Purge Fuzzyly
  local mgr
  mgr=$(_pkg_manager)
  case "$mgr" in
    yay|paru)
      "$mgr" -Qq | fzf --multi --preview "$mgr -Si {1} 2>/dev/null || $mgr -Qi {1} 2>/dev/null" --preview-window=down:75% | xargs -ro "$mgr" -Rns
      ;;
    pacman)
      pacman -Qq | fzf --multi --preview "pacman -Si {1} 2>/dev/null || pacman -Qi {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo pacman -Rns
      ;;
    apt)
      dpkg-query -W -f='${Package}\n' | fzf --multi --preview "apt-cache show {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo apt purge
      ;;
    dnf)
      dnf list installed 2>/dev/null | awk 'NR>1 {print $1}' | cut -d. -f1 | fzf --multi --preview "dnf info {1} 2>/dev/null" --preview-window=down:75% | xargs -ro sudo dnf remove
      ;;
    *)
      echo "No supported package manager found."
      return 1
      ;;
  esac
}
