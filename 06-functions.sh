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


# Temporary container for testing with persistent home.
# DO NOT RUN DANGEROUS COMMANDS IN THE CONTAINER: They can reach the host. The container's purpose is to test stuff without dirtying the host.
test-container(){
  local CONTAINER_HOME="${CONTAINER_HOME:-$(pwd)/.containerhome}"
  local CONTAINER_IMAGE="${CONTAINER_IMAGE:-debian:latest}"
  local CONTAINER_SHELL="${CONTAINER_SHELL:-/bin/bash}"
  local CONTAINER_PKGS="${CONTAINER_PKGS:-nano vim}"

  SHELL="$CONTAINER_SHELL" distrobox-ephemeral --home "$CONTAINER_HOME" --image "$CONTAINER_IMAGE" --additional-packages "$CONTAINER_PKGS" "$@"
}

# Open a packcage's aur website for checkup
aurcheck() {
  xdg-open "https://aur.archlinux.org/packages/$1"
}

# Flatpak management functions
# Find flatpak appid
flatid() {
  flatpak list --app --columns=application | tail -n +1 | grep -i "$1" | head -1
}
# Run flatpak
flatrun() {
  [ -z "$1" ] && return 1
  local id="$(flatpak list --app --columns=application | tail -n +1 | grep -i "$1" | head -1)"
  shift 1
  flatpak run "$id" "$@"
}
# Detach flatpak
flatdetach() {
  [ -z "$1" ] && return 1
  local id="$(flatpak list --app --columns=application | tail -n +1 | grep -i "$1" | head -1)"
  shift 1
  (nohup flatpak run "$id" "$@" &>/dev/null &)
}

# Fuzzily detach an app
apprun() {
  local -a files
  local dir file app
  while IFS= read -r dir; do
    [[ -d "$dir/applications" ]] || continue
    while IFS= read -r file; do files+=("$file"); done < <(find "$dir/applications" -iname '*.desktop' 2>/dev/null)
  done < <(printf '%s\n' "${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" | tr ':' '\n')

  app="$(
    awk '
      function flush() {
        if (path != "" && !(base in seen)) {
          seen[base] = 1
          if (name != "" && !hide) printf "%s\t%s\n", name, path
        }
      }
      FNR == 1 { flush(); path = FILENAME; base = FILENAME; sub(/.*\//, "", base); name = ""; hide = 0; inentry = 0 }
      /^\[/ { inentry = ($0 == "[Desktop Entry]"); next }
      inentry && /^Name=/ && name == "" { name = substr($0, 6) }
      inentry && /^(NoDisplay|Hidden)=true/ { hide = 1 }
      END { flush() }
    ' "${files[@]}" | sort -f -t$'\t' -k1,1 | fzf --height 40% --layout=reverse --delimiter=$'\t' --with-nth=1 | cut -f2
  )"

  [[ -n "$app" ]] || return
  (nohup gio launch "$app" "$@" &>/dev/null &)
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

pkgif() { # PacKaGe Install Fuzzyly
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

pkgrf() { # PacKaGe Remove Fuzzyly
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

pkgpf() { # PacKaGe Purge Fuzzyly
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

# Make .desktop file for an item
mkdesktop() {
  # Check if arguments are passed
  if [ -z "$*" ]; then
      echo "Usage: mkdesktop <path(s)>" >&2
      return 1
  fi
  # Define local vars
  local target dir name out icon exec_line type esc

  # Loop
  for input in "$@"; do
    if [ ! -e "$input" ]; then
        echo "Error: '$input' does not exist" >&2
        continue
    fi
    target=$(realpath -- "$input") || return 1
    dir=$(dirname -- "$target")
    name=$(basename -- "$target")
    out="$(pwd)/$name.desktop"

    if [ -e "$out" ]; then
        echo "Error: '$out' already exists" >&2
        continue
    fi

    if [ -d "$target" ]; then
        type="dir"
    elif [ -x "$target" ]; then
        type="exec"
    elif [ -f "$target" ]; then
        type="file"
    else
        echo "Error: Unknown input type '$input'" >&2
        continue
    fi

    # Escape characters that are special inside a quoted Exec argument
    esc=${target//\\/\\\\}
    esc=${esc//\"/\\\"}
    esc=${esc//\`/\\\`}
    esc=${esc//\$/\\\$}
    esc=${esc//\%/%%}

    case "$type" in
        dir)
            icon="inode-directory"
            exec_line="xdg-open \"$esc\""
            ;;
        file)
            icon=$(xdg-mime query filetype "$target" 2>/dev/null | tr '/' '-')
            [ -z "$icon" ] && icon="text-x-generic"
            exec_line="xdg-open \"$esc\""
            ;;
        exec)
            icon="application-x-executable"
            exec_line="\"$esc\""
            ;;
    esac

    cat << EOF > "$out"
[Desktop Entry]
Type=Application
Name=$name
Exec=$exec_line
Path=$dir
Icon=$icon
Terminal=false
EOF

    chmod +x "$out"
    echo "Created: $out ($type)"
  done
}
