#!/bin/bash

# Function to check if a package is installed using pacman
is_installed() {
    pacman -Qs "$1" > /dev/null
}

# Function to install a package with pacman
install_pacman() {
    sudo pacman -S --noconfirm "$1"
}

# Function to install a package with paru (for AUR packages)
install_paru() {
    paru -S --noconfirm "$1"
}

# Function to install a package via cargo (Rust package manager)
install_cargo_package() {
    cargo install "$1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for git and install if not present
if ! command_exists "git"; then
    echo "git is not installed. Installing..."
    install_pacman "git"
else
    echo "git is already installed."
fi

# Check for unzip and install if not present
if ! command_exists "unzip"; then
    echo "unzip is not installed. Installing..."
    install_pacman "unzip"
else
    echo "unzip is already installed."
fi

# Check for curl and install rustup if not installed
if ! command_exists "rustup"; then
    echo "rustup is not installed. Installing..."
    if ! command_exists "curl"; then
        echo "curl is not installed. Installing curl..."
        install_pacman "curl"
    fi
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup install stable
else
    echo "rustup is already installed."
fi

# Check for paru and install it if not installed
if ! command_exists "paru"; then
    echo "paru is not installed. Installing..."
    git clone https://aur.archlinux.org/paru.git $HOME/src
    cd "$HOME/src/paru"
    makepkg -si --noconfirm
    cd "$HOME"
else
    echo "paru is already installed."
fi

# Install packages based on availability
install_package() {
    package="$1"
    if is_installed "$package"; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing..."
        if pacman -Si "$package" &> /dev/null; then
            # Available in pacman official repo
            install_pacman "$package"
        else
            # Not available in pacman, try AUR via paru
            install_paru "$package"
        fi
    fi
}

# List of packages to install
packages=(
    "base-devel"
    "network-manager-applet"
    "github-cli"
    "cbatticon"
    "volumeicon"
    "flameshot"
    "discord"
    "keepassxc"
    "batsignal"
    "udiskie"
    "gh-cli"
    "chromium"
    "kakoune"
    "kakoune-lsp"
    "zoxide"
    "eza"
    "fd"
    "ripgrep"
    "bat"
    "gvfs"
    "slack"
    "python"
    "python-pip"
    "python-pipx"
    "rofi"
    "thunderbird"
    "trash-cli"
    "docker"
    "docker-compose"
    "zutty-git"
    "simplescreenrecorder"
    "task"
    "vit"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-linux-libertine"
    "just"
    "x11-emoji-picker-git"
    "pacman-contrib"
    "pavucontrol"
    "helix"
    "gitkraken-cli"
    "fzf"
    "rofi"
    "pyenv"
    "starship"
    "ttf-iosevka"
    "syncthing"
    "ffmpegthumbs"
    "ffmpegthumbnailer"
    "brightnessctl"
)

npm_packages=(
    "emmet-cli"
    "emmet-ls"
    "js-beautify"
    "prettier"
    "typescript"
    "typescript-language-server"
    "vscode-langservers-extracted"
    "yaml-language-server"
    "@hyperupcall/autoenv"
)

cargo_package=(
    "--git https://github.com/euclio/mdpls"
)

# Install all listed packages
for package in "${packages[@]}"; do
    install_package "$package"
done

# Install fnm (via cargo, since it's not in official repo or AUR)
if ! command_exists "fnm"; then
    echo "fnm is not installed. Installing via cargo..."
    install_cargo_package "fnm"
    fnm install --lts
    fnm use --lts
else
    echo "fnm is already installed."
fi

# Loop through the npm packages and install them
for package in "${npm_packages[@]}"; do
    npm install -g "$package"
done

# Loop through the cargo packages and install them
for package in "${cargo_packages[@]}"; do
    cargo install "$package"
done

echo "All packages checked/installed."

echo "Running post install script..."
# docker & docker compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

# pacman cache cleaner
sudo systemctl enable paccache.timer

# Prevent screen from going into sleep on lid close
sudo echo "HandleLidSwitch=ignore" >> /etc/systemd/logind.conf

# Syncthing service
sudo systemctl enable --now syncthing@mauricefh.service
