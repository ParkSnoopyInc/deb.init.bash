#!/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install -y sudo || echo "Sudo is Installed"


# DOTFILES GIT REPO
DOTFILES_GIT="https://github.com/ParkSnoopy/ubuntu-dotfiles.git"

# UBUNTU or DEBIAN
DISTRO=$( . /etc/lsb-release && echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]' )


sudo apt update
sudo apt install -y git gh nano curl wget zsh htop btop ca-certificates build-essential cmake

# RUST
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# TAILSCALE
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf

# DOCKER
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/$DISTRO/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$DISTRO \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# GITHUB LOGIN
gh auth login
git clone $DOTFILES_GIT $HOME
# TAILSCALE LOGIN
sudo tailscale up --advertise-exit-node
