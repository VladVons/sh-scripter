#!/bin/bash
#--- VladVons@gmail/com 

cDirRoot=/mnt/hdd/data1/home/user01/backup/rsync
cMarkerFile=".RsyncWeek.lst"
cMarkerAge=1
cMailOnErr=1


cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/sys.sh
source $cDirLib/mail.sh


Check()
{
  Err=""
  for Dir in $(ls -d $cDirRoot/*/current); do
    Marker=$Dir/$cMarkerFile
    if [ -r $Marker ]; then
      Days=$((($(date +%s) - $(date +%s -r $Marker)) / 86400))
      if [ $Days -gt $cMarkerAge ]; then
        Msg="Marker age is $Days days old in $Dir. Max $cMarkerAge"
        Err=$(printf "$Err\n$Msg")
      fi
    else
      Msg="$cMarkerFile not found in $Dir"
      Err=$(printf "$Err\n$Msg")
    fi
  done

  if [ "$Err" ]; then
    Sys_GetInfo
    Body=$(printf "$cAppName\n$GetInfoRes\n$Err")

    Subject="Err: $(hostname) -> $cAppName"
    Mails_Send "$cMailTo" "$Subject" "$Body"
  fi
}


Check
