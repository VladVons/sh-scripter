#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/std.sh


Main()
{
    Log "$0->$FUNCNAME"

    FExt="gz|xz|tmp|[1-9]"
    find /var/log -type f -regextype posix-extended -iregex ".*\.($FExt)" -delete

    FExt="log|err|info|warn|txt"
    FName="messages|syslog"
    find /var/log -type f -regextype posix-extended -iregex "(.*\.($FExt)|.*($FName))" | xargs -I {} truncate -s 0 {}
}


if Std_YesNo "Clear logs ?"; then
    Main
fi
