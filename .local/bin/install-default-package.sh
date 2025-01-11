#!/bin/bash

# Function to check if a package is installed
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

# Install git if not installed
if ! is_installed "git"; then
    echo "git is not installed. Installing..."
    install_pacman "git"
else
    echo "git is already installed."
fi

# Install rustup if not installed
if ! is_installed "rustup"; then
    echo "rustup is not installed. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup install stable
else
    echo "rustup is already installed."
fi

# Install paru if not installed
if ! is_installed "paru"; then
    echo "paru is not installed. Installing..."
    git clone https://aur.archlinux.org/cgit/aur.git/git/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
else
    echo "paru is already installed."
fi


# Function to install packages
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
            # Not available in pacman, try AUR
            install_paru "$package"
        fi
    fi
}

# List of packages to install
packages=(
    "network-manager-applet"
    "cbatticon"
    "volumeicon"
    "flameshot"
    "discord"
    "keepassxc"
    "batsignal"
    "udiskie"
    "gh-cli"
    "zen-browser-bin"
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
    "ttf-iosevka"
    "thunderbird"
    "trash-cli"
    "docker"
    "docker-compose"
)

# Install all listed packages
for package in "${packages[@]}"; do
    install_package "$package"
done

# Install fnm (via cargo, since it's not in official repo or AUR)
if ! is_installed "fnm"; then
    echo "fnm is not installed. Installing via cargo..."
    cargo install fnm
else
    echo "fnm is already installed."
fi

npm install -g emmet-cli emmet-ls js-beautify prettier typescript typescript-language-server vscode-langservers-extracted yaml-language-server

echo "All packages checked/installed."


