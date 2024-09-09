#!/bin/bash

Disk=mmcblk0

echo "umount"
lsblk --list --noheadings  /dev/$Disk |\
while read x; do
    Dev=/dev/$(echo $x | awk '{print $1}')
    sudo umount -f $Dev
done

echo "dd erase boot"
sudo dd if=/dev/zero of=/dev/$Disk bs=512 count=1

echo "format"
sudo mkdosfs   -n 'DRON' -F32 -I /dev/$Disk
#sudo mkntfs --fast --force /dev/$Disk
