#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/log.sh
source $cDirLib/std.sh

cDirBackup=/admin/backup/conf
cDirHost=/admin/host


GetBackupName()
{
  local aMode="$1";

  HostName=$(uname -n)
  SysName=$(uname -s)
  SysVer=$(uname -r | awk -F '-' '{ print $1 }')
  Date=$(date "+%y%m%d-%H%M")
  echo ${HostName}_${SysName}_${SysVer}_${Date}
}


ConfBackup()
{
    Log "$0->$FUNCNAME"

    DirBackupConf
    mkdir -p $cDirBackup

    FileName=$cDirBackup/$(GetBackupName)

    FileNameArc=${FileName}_lnk.tgz
    Files=$(find . -type l | sort)
    tar --verbose --create --gzip --file $FileNameArc $Files

    FileNameArc=${FileName}_dat.tgz
    tar --verbose --create --gzip --dereference --exclude=_inf --exclude=.git --file $FileNameArc $cDirHost
}


if Std_YesNo "Backup ?" 10 0; then
    Log "Starting $0"
    ConfBackup
fi
