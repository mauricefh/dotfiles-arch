#!/usr/bin/env bash

# Expand history size and format
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T"  # Add timestamp to history
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and commands starting with space

# Set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Export LINUXTOOLBOXDIR for other scripts
export LINUXTOOLBOXDIR="$HOME/linuxtoolbox"

# Set the default editor
export EDITOR=hx
export VISUAL=hx

# Color settings for `less` when viewing man pages
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# Dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# fzf configuration
export FZF_DEFAULT_OPTS='--height 40%'

# Starship prompt configuration
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# dprint formatter
export DPRINT_INSTALL="$HOME/.dprint"

# deno
export DENO="$HOME/.deno"

# fzf setup
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "

export TASKRC="$HOME/.config/task/taskrc"
export VIT_DIR="$HOME/.config/vit"

# NPM Global Path
export NPMGLOBAL="$HOME/.npm-global/lib/node_modules"

export HELIX_RUNTIME="$HOME/src/helix/runtime"

export DOTNET_ROOT="$HOME/.dotnet"

# Update PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:$HOME/.scripts:$HOME/.npm-global/bin:$DPRINT_INSTALL/bin:$DENO/bin:$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"

# Postgres local db password
export DATABASE_PASSWORD="5\q\MG3\$kH\Hi@"
