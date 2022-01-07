#!/bin/bash
#--- VladVons@gmail.com


cDirLib=$(readlink -e "../lib")
source $cDirLib/log.sh
source $cDirLib/std.sh

cDirSrc="/usr/lib/scripter/app"
cDirDst="/admin/host"


SymLink()
{
    local aFile=$1;

    if [ ! -L $cDirDst/$aFile ]; then
        ln -s $cDirSrc/$aFile $cDirDst/$aFile
    fi
}


Parse()
{
    Log "$0->$FUNCNAME"
    local Item

    mkdir -p $cDirDst/{console,service}
    SymLink "_etc"
    SymLink "_etc"
    SymLink "console/service.sh"
    SymLink "service/service.sh"

    find {console,service} -maxdepth 1 -type d | sort |\
    while read Item; do
        # clear sets
        source _lib/const.conf

        Dir=$Item
        test -f ./$Dir/const.conf && source ./$Dir/const.conf

        if [[ $cToHost == 1 ]]; then
            SymLink $Dir
        elif [ -n "$cPkgName" ]; then
            Ver=$(dpkg -l $cPkgName 2>&1 | grep ii | awk '{ print $3 }')
            if [ -n "$Ver" ]; then
                echo "$Dir, $Ver"
                SymLink $Dir
            fi
        else
            ProcStatus=$(systemctl is-active $cProcess)
            if [ "$ProcStatus" ]; then
                echo "$Dir, $Ver"
                SymLink $Dir
            fi
        fi
    done
}


if Std_YesNo "Symlink ?" 10 0; then
    Log "Starting $0"
    Parse
fi
