#!/bin/bash
# VladVons@gmail.com
#https://www.raspberrypi.org/downloads/raspbian/

img="2021-05-07-raspios-buster-armhf-lite.img"
#img="2021-01-11-raspios-buster-armhf-lite.img"


#dev="/dev/mmcblk0"
dev="/dev/sdb"


Clone()
{
    aDev="$1"; aImg="$2";

    lsblk | egrep "sd[a-z]|mmcb"

    echo
    Exec="dd conv=fsync if=$aImg of=$aDev status=progress bs=1M"
    echo "Exec: $Exec"

    Msg="$(du -h $aImg) -> $aDev"
    read -p "$Msg (y/n): " KeyYN
    if [ $KeyYN == "y" ];then
        umount ${aDev}1
        umount ${aDev}2

        $Exec
        sync
        sleep 2

        umount ${aDev}1
        umount ${aDev}2
    fi
}


Help()
{
    echo "ToDo"
    echo "/boot/ssh"
    echo "apt remove libpam-chksshpwd"
    echo "dpkg-reconfigure keyboard-configuration"
}


Clone $dev $img
Help

