#!/bin/bash
#--- VladVons@gmail.com


cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/std.sh


Simulate()
# ------------------------
{
    local aCmd=$1;
    Log "$0->$FUNCNAME, $aCmd"

    echo "Simulate mode"
    rsync --dry-run $aCmd

    if Std_YesNo "Synchronize ?" 10 0; then
        rsync $aCmd
    fi
}


Sync_Script()
# ------------------------
{
    Log "$0->$FUNCNAME"


    #DstHost="192.168.2.101"
    DstHost="tr24.oster.com.ua"
    DstPack="ScriptFull"
    SrcDir="/usr/lib/scripter"

    mkdir -p /usr/lib/scripter && rsync --verbose --progress --recursive --links --times --delete ${DstHost}::ScriptFull /usr/lib/scripter
    #mkdir -p /usr/lib/scripter /admin && ln -s /usr/lib/scripter /admin && rsync -vPrlt --delete tr24.oster.com.ua::ScriptFull /usr/lib/scripter

    rsync -vPrlt --delete 192.168.2.102::ScriptFull /usr/lib/scripter
    apt update -y && apt dist-upgrade -y && apt autoremove -y && apt clean -y

    mkdir -p $SrcDir

    # copy from DstHost to localhost
    #Cmd="--update --verbose --progress --recursive --links --times ${DstHost}::Conf $SrcDir"
    Cmd="--verbose --progress --recursive --links --times --delete ${DstHost}::${DstPack} $SrcDir"
    #Cmd="--verbose --progress --recursive --times --delete ${DstHost}::${DstPack} $SrcDir"
    Simulate "$Cmd"
}


Sync_Package()
# ------------------------
{
    Log "$0->$FUNCNAME"

    dpkg --configure -a

    apt update --yes
    apt dist-upgrade --yes

}


if Std_YesNo "Update scripts ?" 10 0; then
    Sync_Script
fi

if Std_YesNo "Update packages ?" 10 0; then
    Sync_Package
fi
