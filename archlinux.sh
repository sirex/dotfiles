# Archlinux install
# =================

# After booting archlinux get my executable notes
pacman --noconfirm -Sy neovim git
git clone https://github.com/sirex/dotfiles.git
mkdir .config
ln -s ~/dotfiles/.config/nvim .config/nvim
nvim -c PlugInstall -c qa

# Open dotfiles/archlinux.sh
# Open install.txt file.

# Check UEFI
test -f /sys/firmware/efi/efivars && echo yes || echo no

# Connect to the internet
ip link
# Use `wifi-menu` if only wifi is available, cable should work out of the box
ping -c 4 archlinux.org

# Update the system clock
timedatectl set-ntp true

# Find you hard drive device name
lsblk
DISK=/dev/sda
BOOT=${DISK}1
SWAP=${DISK}2
ROOT=${DISK}3

# Partition the disks
cfdisk $DISK
# For UEFI choose GPT partition table, otherwise choose DOS.
#
# Create three partitions:
#
#   1. 512M /boot partition (make it bootable)
#   2. 1G swap partition
#   3. / parition using rest of the free space
#
# Parition table should look like this:
#
#   /dev/sda1  (boot)  512M  83 Linux
#   /dev/sda2          512M  82 Linux swap
#   /dev/sda3            2T  83 Linux
#
# For UEFI /boot partition must be of `ef EFI (FAT-12/16/32)` type.

# Double check if everythin is ok
lsblk

# Format boot partition
# For UEFI
mkfs.fat -F32 $BOOT
# For non-UEFI
mkfs.ext4 $BOOT

# Format swap partition
mkswap $SWAP
swapon $SWAP
# TODO: Instead of separate partition it is possible to use swapfile
#fallocate -l 1G /swapfile
#chmod 600 /swapfile
#mkswap /swapfile
#echo "/swapfile none swap sw 0 0" >> /mnt/etc/fstab

# Format root partition
cryptsetup -y -v luksFormat $ROOT
cryptsetup open $ROOT cryptroot
mkfs.ext4 /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt

# Mount boot partition
mkdir /mnt/boot
mount $BOOT /mnt/boot

# Select the mirrors:
nvim /etc/pacman.d/mirrorlist

# Install essential packages:
pacstrap /mnt \
    base \
    grub \
    linux-lts \
    linux-firmware \
    linux-lts-headers \
    base-devel \
    iputils \
    dhcpcd \
    iproute2 \
    iw \
    wpa_supplicant \
    networkmanager \
    cryptsetup \
    sudo \
    neovim \
    git \
    man-db \
    man-pages

# Create /etc/fstab
genfstab -U /mnt | tee /mnt/etc/fstab

# Chroot
arch-chroot /mnt

# After arch-chroot all our environment is gone we have to create it again
# TODO: move this to a function
lsblk
DISK=/dev/sda
BOOT=${DISK}1
SWAP=${DISK}2
ROOT=${DISK}3

# Set time zone
ln -sf /usr/share/zoneinfo/Europe/Vilnius /etc/localtime

# Generate /etc/adjtime
hwclock --systohc

# Localization
cat > /etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
EOF

locale-gen

cat > /etc/locale.conf <<EOF
LANG=en_US.UTF-8
EOF

# Network configuration
_HOSTNAME=sirex-t450
cat > /etc/hostname <<EOF
$_HOSTNAME
EOF

cat > /etc/hosts <<EOF
127.0.0.1       localhost
::1             localhost
127.0.1.1       $_HOSTNAME.localdomain   $_HOSTNAME
EOF

systemctl enable dhcpcd

# Initramfs configuration
# Add encrypt to HOOKS in /etc/mkinitcpio.conf, since root is encrypted
nvim /etc/mkinitcpio.conf
mkinitcpio -P

# Root password
passwd

# Non-root user
useradd -m -g users -G wheel,audio,video,optical,storage sirex
passwd  sirex

# Allow members of wheel group to use sudo (uncomment `%wheel ALL=(ALL) ALL` line).
EDITOR=nvim visudo

# Boot loader

# Find persistent (UUID) name of $ROOT partition
lsblk -f
ROOTUUID=

# Uncomment `GRUB_ENABLE_CRYPTODISK=y`
# Add `cryptdevice=UUID=$ROOTUUID:cryptroot` at the beginning of GRUB_CMDLINE_LINUX_DEFAULT.
nvim /etc/default/grub
grub-install $DISK
grub-mkconfig -o /boot/grub/grub.cfg


# Remove install media and reboot
reboot




# Post install configuration
# ==========================

mkdir -p devel  .config
git -C devel clone https://github.com/sirex/dotfiles.git

# Configure neovim
ln -s ~/devel/dotfiles/.config/nvim .config/nvim
nvim -c PlugInstall -c qa

# Configure zsh
sudo pacman --noconfirm -S zsh wget python-virtualenvwrapper vte-common
ln -s ~/devel/dotfiles/.zshrc .zshrc
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
exit
mv .zshrc.pre-oh-my-zsh .zshrc
ln -s ~/devel/dotfiles/.oh-my-zsh/themes/sirex.zsh-theme .oh-my-zsh/themes/sirex.zsh-theme
zsh


# Install Gnome
sudo pacman --noconfirm -S gnome
sudo systemctl enable gdm.service
sudo systemctl start gdm.service




# Fixing things from Archlinux install media
# ==========================================

# Name disk prtitions
lsblk
DISK=/dev/sda
BOOT=${DISK}1
SWAP=${DISK}2
ROOT=${DISK}3

# Mount disk partitions
cryptsetup open $ROOT cryptroot
mount /dev/mapper/cryptroot /mnt
mount $BOOT /mnt/boot

arch-chroot /mnt

# After arch-chroot all our environment is gone we have to create it again
lsblk
DISK=/dev/sda
BOOT=${DISK}1
SWAP=${DISK}2
ROOT=${DISK}3





# Testing arch install on virtualbox
# ==================================

# Check what vms you already have
VBoxManage list vms

# Check which os types are supported
VBoxManage list ostypes

# Create VM
VBoxManage createvm --name arch --ostype ArchLinux_64 --register

# Add RAM
VBoxManage modifyvm arch --memory 2048

# Create hard disk (--size in megabytes)
VBoxManage createmedium --filename VirtualBox\ VMs/arch/arch.vdi --size 10000 --format VDI

# Add SATA controller and attach hard disk
VBoxManage storagectl arch --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach arch --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/arch/arch.vdi

# Add ISO image
VBoxManage storagectl arch --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach arch --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/Downloads/archlinux-2019.11.01-x86_64.iso

# Configure SSH port forwarding
VBoxManage modifyvm arch --natpf1 "ssh,tcp,,2222,,22"

# Run virtual vm
VBoxManage startvm arch

# On VM run
pacman -Sy openssh
systemctl start sshd
passwd

# On host machine
ssh -p 2222 root@127.0.0.1

# In case of failed key verification
ssh-keygen -R "[127.0.0.1]:2222"

# Done!

# Exit chroot
exit

# Shut down the mashine
shutdown now

# Remove attached ISO media after install is done
VBoxManage storagectl arch --name "IDE Controller" --remove
