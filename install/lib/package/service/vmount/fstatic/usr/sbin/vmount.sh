#!/bin/bash
#--- VladVons@gmail.com

Log()
{
    local aMsg="$1";
    FileLog=/var/log/vmount.log

    Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
    echo "$Msg" >> $FileLog
}

Start()
{
  modprobe cifs
  sleep 1
  mount -a
}

Log "start"
Start
