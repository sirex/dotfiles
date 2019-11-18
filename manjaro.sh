# Check USB stick device name
lsblk -p

# Burn USB Stick
sudo dd bs=4M if=$HOME/manjaro-gnome-18.1.3-191114-linux53.iso of=/dev/sdc status=progress oflag=sync

