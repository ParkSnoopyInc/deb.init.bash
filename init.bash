#!/bin/env bash


# For docker container
apt update && apt install -y sudo || echo "Sudo is Installed"

# Some General Packages
sudo apt update
sudo apt install -y git gh nano curl wget zsh sed htop btop ca-certificates build-essential cmake pkg-config

# OhMyZsh + powerlevel10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
source .zshrc

# RUST
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# TAILSCALE
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

echo
echo
echo
echo ===== Installation Complete! ======
echo
echo To change your shell to ZSH, run:
echo chsh -s /usr/bin/zsh
echo
echo To login GitHub, run:
echo gh auth login
echo
echo To login Tailscale, run one of:
echo sudo tailscale up
echo sudo tailscale up --advertise-exit-node
echo
echo ===================================
echo
