#!/bin/bash

ALIAS_NAME="note"
DIR="$HOME/.notes"
BASH_FILE="$HOME/.bashrc.d/aliases.sh"

git init --bare $DIR
alias note="/usr/bin/git --git-dir=$DIR --work-tree=$HOME"
note config --local status.showUntrackedFiles no
echo "alias note='/usr/bin/git --git-dir=$DIR --work-tree=$HOME'" >> $BASH_FILE
