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
alias linutil='curl -fsSL https://christitus.com/linux | sh'
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


# cd aliases
alias z..='z ..'
alias cdr='builtin cd'
alias cdr..='builtin cd ..'
alias home='builtin cd ~'
alias cd..='builtin cd ..'
alias cd...='builtin cd ../..'
alias cd....='builtin cd ../../..'
alias cd.....='builtin cd ../../../..'
alias '\cd'='builtin cd' # Allow using bultin cd (overriden by zoxide)

# ls aliases  # From: https://github.com/ChrisTitusTech/mybash
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List
alias dir='ls -lah'

# tar aliases # From: https://github.com/ChrisTitusTech/mybash
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
