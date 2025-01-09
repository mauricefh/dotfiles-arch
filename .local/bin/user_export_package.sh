#!/bin/bash

# Get pacman user-installed packages
pacman_packages=$(pacman -Qqe)

# Get paru (AUR) user-installed packages
paru_packages=$(paru -Qqm)

# Get cargo user-installed binaries
cargo_packages=$(ls ~/.cargo/bin)

# Get global pip user-installed packages
pip_packages=$(pip list --user --format=json | jq -r '.[].name')

# Get global npm user-installed packages
npm_packages=$(npm list -g --depth=0 --json | jq -r '.dependencies | keys[]')

# Combine everything into JSON format
cat <<EOF > user_installed_packages.json
{
  "pacman": [
    $(echo "$pacman_packages" | jq -R -s -c 'split("\n")[:-1]')
  ],
  "paru": [
    $(echo "$paru_packages" | jq -R -s -c 'split("\n")[:-1]')
  ],
  "cargo": [
    $(echo "$cargo_packages" | jq -R -s -c 'split("\n")[:-1]')
  ],
  "python": [
    $(echo "$pip_packages" | jq -R -s -c 'split("\n")[:-1]')
  ],
  "npm": [
    $(echo "$npm_packages" | jq -R -s -c 'split("\n")[:-1]')
  ]
}
EOF

echo "User-installed packages saved to user_installed_packages.json"

