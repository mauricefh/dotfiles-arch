#!/usr/bin/env bash

# Ensure the script only runs in interactive shells
if [[ $- != *i* ]]; then
    return
fi

# Allow Ctrl+S for history navigation with Ctrl+R
stty -ixon

# Ignore case on auto-completion
bind "set completion-ignore-case on"

# Show auto-completion list automatically without double tab
bind "set show-all-if-ambiguous on"

# Disable the bell
bind "set bell-style visible"

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Append to history instead of overwriting it
shopt -s histappend
PROMPT_COMMAND='history -a'
