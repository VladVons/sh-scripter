#!/bin/bash
#--- VladVons@gmail.com

cDirLib="/usr/lib/scripter/lib"

source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/pkg.sh
source $cDirLib/sys.sh
source $cDirLib/file.sh

gDirD=/etc/init.d
gFileSysLog=/var/log/syslog


ShowLog()
{
    local aFile="$1";
    Log "$0->$FUNCNAME, $aFile"

    if [ -n "$aFile" ]; then
        echo
        if [ "$aFile" == "$cFileSysLog" ]; then
            File_Show "$aFile" SGT "$cProcess" 15
        else
            #echo "$Log1, $cFileSysLog, $cProcess"
            File_Show "$aFile" ST 15
        fi
    fi
}


Test()
{
    Log "$0->$FUNCNAME"
    local Item

    Info=$(uname --operating-system  --nodename)
    echo "Machine: $Info"

    echo
    compgen -A variable | egrep "^c\w+" | sort |\
    while read Item; do
        echo "$Item=${!Item}"
    done

    if [ -n "$cApp" ] && [ -n "$cPkgName" ]; then
        echo
        Pkg_Version "$cPkgName"
    fi

    if [ -n "$cProcess" ]; then
        echo
        ProcStatus=$(systemctl is-active $cProcess)
        echo Service status: $(ColorEcho r $ProcStatus)

        ExecM "ps aux | grep -v grep | egrep -iw '$cProcess' | awk '{ print \$1, \$2, \$11, \$12 }' | egrep -i '$cProcess' --color=auto"

        ExecM "netstat -lnp | egrep $cProcess --color=auto"

        #Sys_ProcInMem "$cProcess"
        #ExecM "systemctl status -l '$cProcess'"
    fi

    #if [ -n "$cService" ]; then.
    #    echo
    #    "$cService" status
    #fi

    if [ -n "$cPort" ]; then
        #Sys_SockPort "$cPort"
        #ExecM "netstat -lnp | egrep --color=auto -w '$cProcess'"
        ExecM "netstat -lnp | egrep --color=auto -w '$cPort'"
    fi

    if [ "$(type -t TestEx)" == "function" ]; then
        TestEx
    fi

    echo
    compgen -A variable | egrep "^cLog.*" | sort |\
    while read Item; do
        ShowLog ${!Item}
    done
}


Exec()
{
    local aAction=${1:-"restart"}
    Log "$0->$FUNCNAME, $cApp, $aAction"

    eval "$cService $aAction"

    sleep 3
    $cService status

    if [ "$(type -t ExecEx)" == "function" ]; then
        ExecEx
    fi

    echo
    Test
}


Parse()
{
    local aDir=$1; local aMode=$2; local aOpt=$3; 
    Log "$0->$FUNCNAME, $aDir, $aMode"
    local Item

    if [ "$aDir" ] && [ -d $aDir ]; then
        test -f ./$aDir/const.conf && source ./$aDir/const.conf
        test -f ./$aDir/service.sh && source ./$aDir/service.sh
    else
        Log "Cant open directory '$aDir'"
        exit
    fi

    case $aMode in
        e)         Exec ;;
        *|t)       Test ;;
    esac
}

clear
Parse $1 $2 $3
