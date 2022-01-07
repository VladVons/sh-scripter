#!/bin/bash
#--- VladVons@gmail/com 

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source lib/RsyncWeekCore.sh


DoBackup()
{
  Host="nas.lan"
  Section="BackupWeek"
  Prefix="1C"
  SrcDir="/admin/conf/doc"
  Excl="--exclude=hard.txt"
  ExclExt="sh,tmp"
  Backup

  #User="vladvons"
  #Passw="xxx"
  #export RSYNC_PASSWORD=$Passw
}


if [ -r $cAppDefault ]; then
  source $cAppDefault
else
  echo "default backup"
  #DoBackup
fi
