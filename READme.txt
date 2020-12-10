This is a very simple script to install the official
archlinux base and kernel; to download the iso
visit https://www.archlinux.org/download/

To install in "general" any linux distro all you need to do
is format your hard drive with a single root partition, everything will be 
alocated in that partition "aka" the linux tree file structure, not to be confused with the type 
of filesystems Ex: ext4 ext3 xfs....etc 
Linux tree structure, would be:

sda <Your hard drive
  |
 sda1 <Your created partition to be formated with a filesystem Ex: ext4 most "common"
   |
  /boot /home /sys /proc /usr /etc /bin /dev /root /opt /var /tmp /sbin ...etc <Inside of sda1
  
  ^directories created (when insalling base) for the linux tree structure 
  
Creating a swap partition is used as "virtual memory" just incase you run out of ram, linux will
utilize swap space, also if you plan to hibernate your system swap space is "required".
Linux tree with swap partition:

sda <Your hard drive
| |
| sda1 <Your created partition to be formated with a filesystem Ex: ext4 most "common"
|   |
|  /boot /home /sys /proc /usr /etc /bin /dev /root /opt /var /tmp /sbin ...etc <Inside of sda1
|  ^directories created (when insalling base) for the linux tree structure 
|__
   |
 sda2 <Your swap partition/ "virtual memory"
 
NOTE! You can create the partitions in any order you like so you can create the swap partition first, but
if you do, take note that the swap partition will be now sda1 not sda2!! 

Creating a  boot/efi partition is used to boot up the linux kernel with modern uefi bios (GPT/UEFI),
if your motherboard is not uefi compliant dont even worry about creating a efi partition.

NOTE! if installing on modern hardware make sure your hard drive partition table is GPT, not MBR and recommended to use FAT32 on the efi partition.
"A partition table is a table maintained on disk by the operating system describing the partitions on that disk." 
https://en.wikipedia.org/wiki/Partition_table
Linux tree with /boot/efi partition & swap

sda <Your hard drive
|||
||sda1 <Your created partition to be formated with a filesystem Ex: ext4 most "common"
||   |
||  /boot /home /sys /proc /usr /etc /bin /dev /root /opt /var /tmp /sbin ...etc <Inside of sda1
||  ^directories created (when insalling base) for the linux tree structure 
||__
|   |
|sda2 <Your swap partition/ "virtual memory"
|
|__
   |
   sda3 <Your boot/efi partition, inside that partition 2 directory will be created[/boot]inside that directory[/EFI] will be created.
     | 
     /boot
        |
        /EFI

  RECAP:If you have a hard drive thats 100GB: What I would do is partition the drive like so-
in OLD hardware no uefi support but sufficient RAM, Ill just create one large 100GB ext4 partition, thats all!
sda-sda1 use all 100GB 

in OLD hardware no uefi support but not sufficient RAM Ex: 512 or 1GB or 2GB or 3GB, Ill create a 6GB swap- 
partition and the rest for the root partition formated to ext4, thats all!
sda-sda1|6GBswap    sda2|94GBroot partition
 |__________________|

in NEW hardware with everything sufficient BUT not dual booting, Ill do the same as the old hardware, disable secure boot switch to legacy
from UEFI and just use all 100GB for the root partition formated to ext4
sda-sda1 use all 100GB

in NEW hardware dual booting with windows and sufficient in RAM.., Ill login to windows resize the windows partition to 50GB that
leaves 50GB for linux, once booted into the installer Ill create 550mb boot/efi partition and the rest for the root partition ext4 formated, IF its for a
laptop ill alocate 2GB of swap space just in case. NOTE! dualbooting is more complex and you will or might render your system unbootable,
backup your shit! hahaha; If planning on dual booting, do all the research you can on that subject before attempting! because ALL and
I mean ALL systems are different, what might work on one system might not work for you, even if you have the exact setup.
sda-windowsRECOVERYpartition|sda2WINDOWS38GB        sda3|2GBswap         sda4|48GBroot partition
 ||___________________________________________________|                    |
 |_________________________________________________________________________|

To get this script working just boot up the arch iso when you get a prompt (root@archiso~ #)
input pacman -Sy to Synchronize package database. then
pacman -S git to install git to download this installer
git clone https://www.github.com/Parralogic/archinstaller
cd archinstaller
chmod +x archinstaller.sh #if not already executable
./archinstaller.sh

NOTE!:Phase 2 is after script terminates and your chrooted in to your base install, run the script again this time with n,N.
NOTE! IF installation was successfull, you just have a base install of arch, no desktop environment, or windowmanager, but no bloat
just look up what kind of desktop environment you wish to install and good luck.

TIPS: After installation is successful please dont exit and reboot, it is recommaned in my experience!
to install a terminal emulator such as xterm, so just pacman -S xterm
then install the sudo package so you can execute root privilages like so pacman -S sudo
edit the sudo file after installation like so nano /etc/sudoers
scroll to the bottom you'll find 

## User privilege specification
##
root ALL=(ALL) ALL

## Uncomment to allow members of group wheel to execute any command
#%wheel ALL=(ALL) ALL            <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<UNCOMMENT that line

## Same thing without a password
# %wheel ALL=(ALL) NOPASSWD: ALL   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Not this line just for security because you may execute a script that might currupt your system
                                                                    when you execute sudo "whatever command" it will not ask for your password!!
## Uncomment to allow members of group sudo to execute any command
# %sudo ALL=(ALL) ALL

save and exit nano

also add a user and add it to the wheel group like so 
useradd -m -N -G wheel desiredusername

^useradd:command to add user ^-m:means create a home directory ^-N:means dont create a group using your user name
^-G:means add the user to groups in this case wheel:wheel means admin privilages
^desiredusername:means the name you wanna use 

RECAP: if I was to add a user I would execute useradd -m -N -G wheel david
then ill create a password for my login like so- passwd david then enter

to add your user name in other groups if needed just execute gpasswd -a yourusername groupname


        
        
        
        
        
     
