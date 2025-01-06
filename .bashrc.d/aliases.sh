#!/usr/bin/env bash

# Git bare repo config manager
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".cfg" >> .gitignore

# Directory navigation aliases
alias home='cd ~'
alias ..='cd ..'
alias cd..='cd ..'
alias bd='cd "$OLDPWD"'  # Go back to previous directory
alias pacman='sudo pacman'
alias pacman-search='sudo pacman -Ss'
alias pacman-rm='sudo pacman -Rcns'
alias pacman-rm-safe='sudo pacman -Runs'

# Quick directory access
alias web='cd /var/www/html'

# Common command modifications
alias cp='cp -i'  # Prompt before overwrite
alias mv='mv -i'  # Prompt before overwrite
alias rm='trash -v'  # Use `trash` command instead of `rm`
alias mkdir='mkdir -p'  # Create parent directories as needed
alias ps='ps auxf'  # Show process tree
alias ping='ping -c 10'  # Limit ping to 10 packets
alias less='less -R'  # Display raw control characters
alias cls='clear'
alias vi='nvim'
alias vim='nvim'
alias hx='helix'
alias hxf='hx "$(fzf)"'
alias shxf='sudo helix "$(fzf)"'
alias unzip='unzip -O UTF-8'
alias clip='xclip -selection clipboard'

# File permissions shortcuts
alias mx='chmod a+x'  # Make file executable
alias chmod000='chmod -R 000'  # No permissions
alias chmod644='chmod -R 644'  # Owner read/write, others read
alias chmod666='chmod -R 666'  # All read/write
alias chmod755='chmod -R 755'  # Owner read/write/execute, others read/execute
alias chmod777='chmod -R 777'  # Full permissions

# Search shortcuts
alias h='history | grep'  # Search command line history
alias p='ps aux | grep'   # Search running processes
alias f='find . | grep'   # Search files in the current folder

# Networking
alias openports='netstat -nape --inet'  # Show open ports

# View logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d':' -f1 | xargs tail -f"

# Docker cleanup
alias docker-clean='docker system prune -af --volumes'  # Clean up Docker

# Alias for `grep`
if command -v rg &>/dev/null; then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

# Alias for 'ls' using 'eza'
alias ls='eza --oneline --long --color=always --group-directories-first --no-time --no-user --no-filesize --octal-permissions --no-permissions'

alias la='eza --oneline --long --color=always --group-directories-first --no-time --no-user --no-filesize --octal-permissions --no-permissions --all'

# Alias fzf
# alias fzf="fzf --preview 'bat --color=always {}' --preview-window '~3'"

# Alias cat
# alias cat='bat --force-colorization'
