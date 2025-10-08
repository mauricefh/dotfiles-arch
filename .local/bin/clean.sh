#!/bin/bash

# Clean package manager cache
sudo pacman -Scc
sudo pacman -Qtdq | sudo pacman -Rns -

# Clean command and clipboard
echo "" > ~/.bash_history
clipcatctl clear
trash-empty
