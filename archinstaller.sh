#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 12/01/2020
#Last Modified: 02/03/2024
clear

if [[ -z $(command -v git) ]]; then
#Just Incase
pacman -Sy
pacman -S git --noconfirm
pacman-key --init
pacman-key --populate
pacman -S archlinux-keyring --noconfirm
pacman -Sy
#
else echo "...........................MY-ARCH_LINUX-SCRIPT....................................."
fi
echo -en "\e[92mThis installer script has 2 phases, is this your first time running the script [y/n]? "; read YN
case $YN in
y|Y )
echo -e "This script will guide you to install \e[34mArch-Linux\e[00m."
echo -e "Press Enter key to continue: \e[91mWARNING use at your own risk!\e[00m"
echo "Ctrl+c to Quit/Terminate this bitch!"
read
clear
echo "First lets select your keyboard layout, only worry about the (NAME) minus the extension of (.map.gz)"
echo "So if your keyboard layout is in /usr/share/kbd/keymaps/i386/azerty/fr-latin1.map.gz"
echo -e "Only input \e[93mfr-latin1\e[00m, Use spacebar or the up/down arrowkeys to navigate, \e[91m[q]\e[00m exit keymaps"
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
echo -e "\e[33mNOTE! Only use sda1 sda2 sdb1 sdb2...etc not /dev/sda1 /dev/sdb2...etc below\e[00m"
read -p "Whats the root partition:? " ROOTPAR
read -p "Whats the swap partition if any:? " SWAPPAR
read -p "Whats the boot or efi partition if any:? " BOOTPAR
case $SWAPPAR in
""|" " ) echo "No swap created!"; sleep 3 ;;
sd* | vda*)
mkswap /dev/$SWAPPAR
swapon /dev/$SWAPPAR
;;
esac
case $BOOTPAR in
""|" " ) echo "No boot/efi created!"; sleep 3 ;;
sd* | vda*)
mkfs.fat -F 32 /dev/$BOOTPAR
;;
esac
echo "Format the root partition using which filesystem:? [ext4 most common fs]"
select FS in ext2 ext4 xfs zfs btrfs; do
case $FS in
ext*)
mkfs.$FS /dev/$ROOTPAR; break ;;
xfs) 
mkfs.$FS -f /dev/$ROOTPAR; break;;
zfs)
echo "To use zfs visit:"
echo -e "\e[34mhttps://wiki.archlinux.org/index.php/Install_Arch_Linux_on_ZFS\e[00m"; echo -e "\e[91mPlease! run installer again!\e[00m"; exit 1 ;;
btrfs)
mkfs.btrfs -f /dev/$ROOTPAR; break ;;
esac
done
echo "Now mounting the ROOT partition"
echo "mount /dev/$ROOTPAR /mnt" && sleep 2
echo
mount /dev/$ROOTPAR /mnt
echo "Now INSTALLING base,linux,linux-firmware in the /dev/$ROOTPAR root partition."
echo "With pacstrap /mnt base linux linux-firmware"
read -p "PRESS Enter To Execute that Shit!"
pacstrap /mnt base linux linux-firmware
echo
echo "Listing BASE install in the new Fucking ROOT partition /dev/$ROOTPAR"
echo "Under the mount point /mnt"
ls /mnt
echo
echo "Now mounting the BOOT/EFI partition"
echo "mount /dev/$BOOTPAR /mnt/boot" && sleep 2
mount /dev/$BOOTPAR /mnt/boot
sleep 1
echo "Listing BOOT/EFI partition /dev/$BOOTPAR; Under /mnt/boot"
ls /mnt/boot
echo
echo "ls /mnt/boot"
ls /mnt/boot
echo "Nothing should be in that bitch! HAHAHAHAHhahah"
read -p "PRESS Enter to Proceed!"
pacstrap /mnt base linux linux-firmware &> /dev/null
genfstab -U /mnt >> /mnt/etc/fstab
echo
echo -e "Now \e[91mchrooting\e[00m into the new installation; to finalize the install."
echo "Script is going to terminate re-execute ./archinstaller.sh to continue"
read -p "archinstaller.sh will be copied to the new ROOT partition: Press Enter"
cp -v archinstaller.sh /mnt
ls /mnt
echo . && sleep .50
echo .. && sleep .50
echo ... && sleep .50
echo .... && sleep .50
echo ..... && sleep .50
echo "arch-chroot /mnt"
sleep 1
arch-chroot /mnt;;
n|N )
read -p "Third lets set your timezone: Press Enter"
echo
ls /usr/share/zoneinfo/
echo
echo "Type that shit! in; no select loop here! HAHAHAH"
read -p "Whats your Region:? " REGION
echo
ls /usr/share/zoneinfo/$REGION
echo
echo "Same Fucking! shit Type. hahaha"
read -p "Whats your City:? " CITY
echo
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc
sleep 3
clear
echo -e "Fourth Localization, We need to edit \e[91m/etc/locale.gen\e[00m"
echo "uncomment en_US.UTF-8 UTF-8 and other needed locales."
echo "Press Ctrl+o then just Enter to SAVE it, Then Ctrl+x To QUIT/Exit that Shit!"
read -p "Press Enter: nano editor will be installed."
pacman -S nano --noconfirm
nano  /etc/locale.gen
locale-gen
echo -e "\e[92m"
localectl
echo -e "\e[00m"
touch /etc/locale.conf
read -p "system locale to use from above:? " LOCALE
echo "LANG=$LOCALE" >> /etc/locale.conf
echo "What do you want to name this computer aka hostname;" 
read -p "used to distinguish you on the network:? " HOSTNAME
echo "$HOSTNAME" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1	localhost >> /etc/hosts"
echo "::1		localhost >> /etc/hosts"
echo "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME >> /etc/hosts"
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts
sleep 4
mkinitcpio -P
echo
echo -e "\e[91mset root password\e[00m"
passwd
echo
echo -e "Lastly let's install the \e[95mgrub bootloader\e[00m; if you created an efi partition, type \e[91mefi\e[00m below" 
echo "or just press ENTER; for regular BIOS/MBR Shit!"
read -p "efi will install the necessary packages for an efi setup: " EFI
case $EFI in
""|" " )
pacman -S os-prober grub
echo
echo -e "\e[33m"
lsblk
read -p "Install grub on drive:? Ex: sda sdb sdc:? " DRIVE
echo -e "\e[00m"
grub-install /dev/$DRIVE
grub-mkconfig -o /boot/grub/grub.cfg ;;
efi )
pacman -S grub efibootmgr dosfstools os-prober mtools
echo "Making a Fucking Directory of EFI in the boot/efi Partition. So whatever your boot/efi Partition Was?; Shit I dont know....Yeah; Right inside that!"
echo "mkdir /boot/EFI"
mkdir /boot/EFI
echo "ls boot/"
ls boot/
sleep 3
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck --efi-directory=/boot/EFI
grub-mkconfig -o /boot/grub/grub.cfg ;;
esac
echo -e "\e[91m"
read -p "Now installing networkmanager so when you reboot you'll have an internet connection: Press Enter"
echo -e "\e[00m"
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager
clear
echo -e "\e[92mGREAT! Arch SEEMS to be installed SUCCESSFULLY!, read the READme.txt\e[0m"
read -p "If you read the READme.txt you know what to do; in prompt just input exit then reboot: Press Enter"
;;
*) echo -e "\e[91mONLY! [y,Y] [n,N]\e[00m"; sleep 3 ; exit 1 ;;
esac
