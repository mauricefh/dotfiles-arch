# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source bash completion if available
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Source git completion if available
if [ -f /usr/share/git/completion/git-completion.bash ]; then
    . /usr/share/git/completion/git-completion.bash
fi

# Source all scripts in .bashrc.d/
if [ -d "$HOME/.bashrc.d" ]; then
    for file in "$HOME/.bashrc.d/"*.sh; do
        [ -r "$file" ] && . "$file"
    done
fi

if [ -f "$HOME/.xinitrc" ]; then
    . "$HOME/.xinitrc"
fi
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# Initialize starship prompt
eval "$(starship init bash)"

# Initialize zoxide
eval "$(zoxide init --cmd cd bash)"

# Initialize fast node manager (fnm)
eval "$(fnm env --use-on-cd --shell bash)"

# if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
#    exec tmux && exit;
# fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# FNV_VERSION=echo $("fnm version")
# source "$HOME/.local/share/fnm/node-versions/v22.12.0/installation/lib/node_modules/@hyperupcall/autoenv/activate.sh"

# Direction for new install
# if [ ! -d "$HOME/.dotfiles" ]; then
#   printf "If you are a new user, chmod +x and run the following script: \n - git-bare-repo-init.sh \n - install-default-package.sh \n - install-iosevka-font.sh \n\nThey are located in ~/.local/bin/\n"
# fi
source "$HOME/.npm-global/lib/node_modules/@hyperupcall/autoenv/activate.sh"

