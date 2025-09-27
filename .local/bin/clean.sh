#!/bin/bash

sudo pacman -Scc

sudo pacman -Qtdq | sudo pacman -Rns -
