#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/std.sh


Main()
{
    Log "$0->$FUNCNAME"

    if Std_YesNo "Check root disk and reboot ?"; then
        touch /forcefsck
        reboot
    fi
}


Zerro()
{
    aRoot="$1";
    echo "$0, $FUNCNAME, $aRoot"

    File="$Root/Zerro.dat"

    ExecM "dd if=/dev/zero of=$File bs=1M status=progress"
    ExecM "rm -Rf $File"
    ExecM "df -h $Root"
}


read -p "Run $0 ? Press Enter to continue ..."

#Main
#
Zerro ""
#Zerro "/mnt/hdd/data1"

