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
 
NOTE! You can create the partitions in any order you like so you can creat the swap partition first, but
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
        
NOTE! IF installation was successfull, you just have a base install of arch, no desktop environment, or windowmanager, but no bloat
just look up what kind of desktop environment you wish to install and good luck.
        
        
        
        
        
        
     
