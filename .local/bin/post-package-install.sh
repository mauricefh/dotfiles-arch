# docker & docker compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

# pacman cache cleaner
sudo systemctl enable paccache.timer
