#!/bin/bash
# VladVons@gmail.com

#img="2019-09-26-raspbian-buster-lite.img"
img="2019-09-26-raspbian-buster.img"

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


Clone $dev $img
