#!/bin/bash
#--- VladVons@gmail.com

cDirHome=/mnt/hdd/data1/home
cDirBackup=backup/current
cDirOld=backup/old
cDaysNoFile=1
cDaysInCurrent=15
cDaysInOld=365
cDOW=5
cCheckCRC=0
cMinSize=10000
#
cFtpUser=
cFtpPassw=
cFtpHost=
#
cMailTo=VladVons@gmail.com


cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source lib/backup.sh

echo "cDirHome: $cDirHome, cDirBackup $cDirBackup"

CheckDirAsList()
{
    List=$(grep -v '^$\|^\s*\#' $cDirHome/Archive.lst)
    ParseStrList "$List"
}


CheckDirAsLocation()
{
    if [ -d "$cDirHome" ]; then
        #List=$(find -L $cDirHome -wholename "*/$cDirBackup$*" -type d | sort)
        List=$(find -L $cDirHome -type d | grep $cDirBackup | sort)
        ParseStrList "$List"
    else
        Log "$0->$FUNCNAME. Err. Directory not exists $cDirHome"
    fi
}
