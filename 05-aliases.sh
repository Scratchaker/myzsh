# Other aliases
alias snano='sudo nano'
alias sedit='sudo ms-edit'
alias svi='sudo vi'
alias svim='sudo vim'
alias snvim='sudo nvim'
alias rmdir='rm --recursive --force'
alias rmd='rm --recursive --force'
alias rmdv='rm --recursive --force --verbose'
alias ff='fastfetch'
alias nf='neofetch'
alias dolphin.='dolphin .'
alias e.='(nohup dolphin . >/dev/null 2>&1 &)'
alias neofetch='fastfetch --config neofetch'
alias bios='systemctl reboot --firmware-setup'
alias sourcezsh='source ~/.zshrc'
alias homeserver='ssh pi@homeserver.local'
alias winapp='WINEPREFIX=~/.wine64 WINEARCH=win64 wine'
alias testgpu='mangohud __GL_SYNC_TO_VBLANK=0 vblank_mode=0 glxgears'
alias open='xdg-open'
alias o='xdg-open'
alias o.='xdg-open .'
alias please='sudo'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias cls='clear'


# cd aliases
alias z..='z ..'
alias cdr='cd'
alias cdr..='cd ..'
alias home='cd ~'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias '\cd'='builtin cd' # Allow using bultin cd (overriden by zoxide)

# ls aliases
if command -v eza >/dev/null 2>&1; then
    alias ls='eza -F -h --color=always' # add colors and file type indicators
else
    alias ls='ls -Fh --color=always' # add colors and file type indicators
fi
alias la='eza -Alh --icons --header'                                       # show hidden files
alias lx='eza -lh --sort=extension --icons --header'                       # sort by extension
alias lk='eza -lh --total-size --sort=size --reverse --icons --header'     # sort by size
alias lc='eza -lh --sort=changed --reverse --icons --header'               # sort by change time
alias lu='eza -lh --sort=accessed --reverse --icons --header'              # sort by access time
alias lr='eza -lh --recurse --icons --header'                              # recursive listing
alias lt='eza -lh --sort=modified --reverse --icons --header'              # sort by date
alias lm='eza -Alh --icons --header --color=always | less -R'              # pipe through 'less'
alias lw='eza -x -Ah --icons --header'                                     # wide/grid listing format
alias ll='eza -l -F -h --color=always --icons --header'                    # long listing format
alias labc='eza -lh --sort=name --icons --header'                          # alphabetical sort
alias lf="eza -lh --only-files --icons --header"                           # files only
alias ldir="eza -lh --only-dirs --icons --header"                          # directories only
alias lla='eza -Alh  --icons --header'                                     # list and hidden files
alias las='eza -A --icons --header'                                        # hidden files
alias dir='eza -l -F -h --color=always --icons --header'

# tar aliases # From: https://github.com/ChrisTitusTech/mybash
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
