#!/bin/bash
#--- VladVons@gmail.com

#https://forum.proxmox.com/threads/local-lvm-storage-and-vm-format.27209/page-2

AddNewPartition()
{
  # storage tree
  lsblk

  # text gui partition manager
  cfdisk /dev/sda

  #--- refresh partitins
  #apt-get install parted
  #partprobe

  mkfs -t ext4 /dev/sdX
}


SwapFile()
{
  swapon -s

  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  #swapoff /swapfile
}


SwapPart()
{
  #--- create simple swap volume
  free -m
  swapon -s
   
  lvcreate -L 4G -n swap2 vgdata
  mkswap /dev/vgdata/swap2
  blkid /dev/vgdata/swap2
  swapon xxx-xxxxx
}


LVM()
{
  apt-get install lvm2
  modprobe dm-mod
  mkdir -p /mnt/hdd/data2
  mount /dev/vgdata/home /mnt/hdd/data2


  #--------------- physical group  ---------------
  #--- list
  pvs
  pvscan
  pvdisplay


  #--------------- volume group  ---------------
  #--- volume group list
  lsblk
  vgs
  vgdisplay
  vgscan

  #--- create volume group
  vgcreate vgdata /dev/sdaX

  #--- volume group rename
  vgdisplay
  vgrename -v LGE8xa-m4Q8-zFRc-U1df-X2Me-t37c-XIcRbt vgdata2
  vgchange -ay vgdata2

  #--- group volume remove
  vgremove vgdata
  pvremove /dev/sdb1


  #--------------- logical volume  ---------------
  #--- logical volume list
  lsblk
  lvs vgdata
  lvdisplay

  #--- create simple volume
  lvcreate -L 10G -n vol21 vgdata
  mkfs -t ext4 -L "data1" /dev/vgdata/vol21
  mkfs -t ntfs -Q -L "WinData" /dev/vgdata/vol21

  #--- create logical volume 'thin'
  pvesm lvmthinscan vgdata
  lvcreate -L 10G -n vol1 vgdata
  lvconvert --type thin-pool vgdata/vol1_a

  #--- logical volume rename
  lvrename vgdata vol1 vol3

  # make disk size 3G
  resize2fs /dev/sda1a 3G

  #--- logical volume resize
  umount -l /dev/vgdata/vol1_a
  e2fsck -ff /dev/vgdata/vol1_a
  #lvreduce -L -4G /dev/vgdata/vol1_a
  #lvresize --size -4G /dev/vgdata/vol1_a
  lvresize --size +4G /dev/vgdata/vol1_a
  mount /dev/vgdata/vol1_a
  resize2fs /dev/vgdata/vol1_a
  #fsadm resize /dev/vgdata/vol1

  # zfs resize 
  apt install parted
  zpool set autoexpand=on data1
  parted /dev/vdb resizepart 1 100%
  zpool online -e data1 /dev/vdb

  #--- lvm-thin  resize
  lvextend -L +10G /dev/mapper/vgdata-vol1_a

  #--- logical volume remove
  umount /dev/vgdata/vol2_a
  lvremove /dev/vgdata/vol2_a
  lvremove /dev/mapper/pve-vm--103--disk--10
}


ClearBoot()
{
  aDev="$1"
  Log "$0->$FUNCNAME, $aDev"

  dd if=/dev/zero of=/dev/$aDev count=1
  sync

}