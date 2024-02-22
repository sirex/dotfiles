##########################################
# How to create a new bootable USB Stick

cd ~/Downloads
wget https://download.manjaro.org/i3/23.0.1/manjaro-i3-23.0.1-230921-linux65.iso
wget https://download.manjaro.org/i3/23.0.1/manjaro-i3-23.0.1-230921-linux65.iso.sha512
iso=$PWD/manjaro-i3-21.3.7-minimal-220817-linux515.iso
sha512sum -c $iso.sha512
#| manjaro-i3-23.0.1-230921-linux65.iso: OK
du -sh $iso
#| 2,3G    /home/sirex/Downloads/manjaro-i3-23.0.1-230921-linux65.iso

lsblk -po NAME,FSTYPE,LABEL,SIZE,FSUSE%,MOUNTPOINT
#| └─/dev/sdc1      vfat   Atmintukas   7,5G        
usb=/dev/sdc
sudo dd bs=4M if=$iso of=$usb status=progress oflag=sync
#| 2397337600 bytes (2,4 GB, 2,2 GiB) copied, 576 s, 4,2 MB/s 
#| 571+1 records in
#| 571+1 records out
#| 2397337600 bytes (2,4 GB, 2,2 GiB) copied, 576,818 s, 4,2 MB/s


##########################################
# Set up new instance

# Update
sudo pacman -Syu

# Check system parameters
sudo pacman -S neofetch
neofetch
df -h

# dotfiles
sudo pacman -Sy git stow
git clone https://github.com/sirex/dotfiles.git
cd dotfiles

# Neovim
sudo pacman -Sy neovim
stow neovim
nvim -c PackerSync

# Qtile
sudo pacman -Sy qtile rofi xclip network-manager-applet terminus-font alacritty ranger
stow qtile

# Passwords
sudo pacman -Sy keepassxc
sudo pacman -S pass pass-otp rofi-pass pwgen

# Apps
sudo pacman -Sy chromium telegram-desktop
