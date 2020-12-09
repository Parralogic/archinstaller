#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 12/01/2020
#Last Modified: 12/07/2020
clear
read -p "This installer script has 2 phases, is this your first time running the script [y/n]? " YN
case $YN in
y|Y )
echo "This script will guide you to install Arch-Linux."
read -p "Press Enter key to continue: WARNING use at your own risk!"
clear
echo "First lets select your keyboard layout, only worry about the (NAME) minus the extension of (.map.gz)"
echo "So if your keyboard layout is in /usr/share/kbd/keymaps/i386/azerty/fr-latin1.map.gz"
echo "Only input fr-latin1, Use spacebar or the up/down arrowkeys to navigate, [q] exit keymaps"
read -p "Press Enter"
ls /usr/share/kbd/keymaps/**/* | less
read -p "Whats the name of the keyboard layout:? " KEYBOARD
loadkeys $KEYBOARD
timedatectl set-ntp true
timedatectl status
sleep 3
clear
echo "Second lets partition the hard drive!"
echo "Lets use cfdisk to partition the hard drive, it is by far the easiest tool"
read -p "Press Enter"
lsblk
echo
read -p "Hard drive to use:? Ex. sda or sdb .. etc :? " DRIVE
cfdisk /dev/$DRIVE
wait
echo "NOTE! Only use sda1 sda2 sdb1 sdb2...etc not /dev/sda1 /dev/sdb2...etc below"
read -p "Whats the root partition:? " ROOTPAR
read -p "Whats the swap partition if any:? " SWAPPAR
read -p "Whats the boot or efi partition if any:? " BOOTPAR
case $SWAPPAR in
""|" " ) echo "No swap created!"; sleep 3 ;;
sd* ) 
mkswap /dev/$SWAPPAR
swapon /dev/$SWAPPAR
;;
esac
case $BOOTPAR in
""|" " ) echo "No boot/efi created!"; sleep 3 ;;
sd* ) 
mkfs.fat -F32 /dev/$BOOTPAR
;;
esac
echo "Format the root partition using which filesystem:? [ext4 most common fs]"
select FS in ext2 ext4 xfs zfs btrfs; do
mkfs.$FS /dev/$ROOTPAR
wait
mount /dev/$ROOTPAR /mnt
pacstrap /mnt base linux linux-firmware
wait
genfstab -U /mnt >> /mnt/etc/fstab
break
done
clear
echo "Now chrooting into the new installation; to finalize the install."
echo "Script is going to terminate re-execute ./archinstaller.sh to continue"
read -p "archinstaller.sh will be copied to the new root partition: Press Enter"
cp archinstaller.sh /mnt
arch-chroot /mnt ;;
n|N )
read -p "Third lets set your timezone: Press Enter"
echo
ls /usr/share/zoneinfo/
echo
read -p "Whats your Region:? " REGION
echo
ls /usr/share/zoneinfo/$REGION
echo
read -p "Whats your City:? " CITY
echo
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc
clear
echo "Fourth Localization, We need to edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8"
echo "and other needed locales."
read -p "Press Enter: nano editor will be installed."
pacman -S nano
nano  /etc/locale.gen
wait
locale-gen
clear
localectl list-locales
touch /etc/locale.conf
read -p "system locale to use from above:? " LOCALE
echo "LANG=$LOCALE" >> /etc/locale.conf
clear
echo "What do you want to name this computer aka hostname;" 
read -p "used to distinguish you on the network:? " HOSTNAME
echo "$HOSTNAME" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts
mkinitcpio -P
clear
echo "set root password"
passwd
echo
echo "Lastly let's install the grub bootloader; if you created an efi partition, type efi below or just ENTER."
read -p "efi will install the necessary packages for an efi setup: " EFI
case $EFI in
""|" " )
pacman -S os-prober grub
lsblk
read -p "Install grub on drive:? Ex: sda sdb sdc:? " DRIVE
grub-install /dev/$DRIVE
grub-mkconfig -o /boot/grub/grub.cfg ;;
efi )
pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
lsblk
read -p "whats the boot/efi partition:? " BOOTPAR
mount /dev/$BOOTPAR /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg ;;
esac
echo
read -p "Now installing networkmanager so when you reboot you'll have an internet connection: Press Enter"
pacman -S networkmanager
systemctl enable NetworkManager
clear
echo -e "\e[92mGREAT! Arch SEEMS to be installed SUCCESSFULLY!, read the READme.txt\e[0m"
read -p "If you read the READme.txt you know what to do; in prompt just input exit then reboot: Press Enter"
;;
*) echo ONLY [y,Y] [n,N]; sleep 3 ; exit 1 ;;
esac

##Thanks to DT Youtube channel:DistroTube
##https://wiki.archlinux.org/index.php/installation_guide
