# 2024-02-13 08:07

cd dotfiles
ln -fis $PWD/.config/alacritty/alacritty.toml ~/.config/alacritty
y
ls -l ~/.config/alacritty
#| alacritty.toml -> ~/dotfiles/.config/alacritty/alacritty.toml


# Test Nix and Home manager on Docker
docker run -it --rm -e USER=$USER -v "$PWD:$PWD" archlinux:latest bash

pacman -Syu --noconfirm base-devel git sudo util-linux

useradd -m sirex
echo "sirex ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Nix
curl --proto '=https' --tlsv1.2 -sSf \
  -L https://install.determinate.systems/nix | \
  sh -s -- install linux --init none --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

chown -R $USER /nix
mkdir -p /home/$USER/.local/state/nix/profiles
mkdir -p /home/$USER/.cache
chown -R $USER /home/$USER/.local /home/$USER/.cache
chown sirex /home/$USER

su - sirex
cd ~/dotfiles

nix flake --version
#| nix (Determinate Nix 3.15.0) 2.33.0


# Install Home manager
nix run home-manager -- switch --flake path:.#$USER

# Update changes to dotfiles
home-manager switch --flake path:.#$USER

zsh --version
nvim --version
which zsh
#| /home/sirex/.nix-profile/bin/zsh
file /home/sirex/.nix-profile/bin/zsh
#| /home/sirex/.nix-profile/bin/home/sirex/.nix-profile/bin/zsh/zsh: symbolic link to /nix/store/gm8ldbac46x710xlmxanblzvw4yimjzd-zsh-5.9/bin/
bat ~/.zshrc

# Without these directories Obsidian crashes
mkdir -p ~/notes
mkdir -p ~/ivpk/notes


# How to reproduce configuration on a new machine
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/sirex/dotfiles.git
nix run home-manager/master -- switch --flake dotfiles#server -b nixhm
