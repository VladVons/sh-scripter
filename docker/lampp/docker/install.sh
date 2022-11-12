#!/bin/bash
# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

source ./common.sh

cDirRoot=$(pwd)
cDirPkg="pkg"

gArrDone=()


ParseFile_Pkg()
{
    local aFile="$1";

    #for Item in $(cat $aFile 2>/dev/null | grep "^[^\#]"); do
    sed '/^[[:blank:]]*#/d;s/#.*//' $aFile 2>/dev/null |\
    while IFS='=' read Key Val; do
        gPkgArg=$Val
        cd $cDirRoot/$cDirPkg/$Key
        ParseDir
    done
}

ParseDir()
{
    log_Print "$0->$FUNCNAME($PWD)"

    Found=$(echo ${gArrDone[@]} | grep -o $PWD)
    if [ "$Found" ]; then
        log_Print "Already parsed. Skip $PWD"
        return
    fi
    gArrDone+=($PWD)

    dir_Show "*.txt"
    dir_Source "*.conf"

    for Item in $(ls *.pkg 2>/dev/null | sort) ; do
        CurDir=$PWD
        ParseFile_Pkg $Item
        cd $CurDir
    done

    dir_SourceExec "*.sh" "PreInstall"
    if [ -d "os_${ID}" ]; then
        dir_SourceExec "os_${ID}/*.sh" "PreInstall"
    fi

    for File in $(ls *.apt *.snap 2>/dev/null | sort); do
        Ext=${File##*.}
        if [ $Ext == "apt" ]; then
            pkg_FileListInstall $File
        elif [ $Ext == "snap" ]; then
          pkg_FileListInstallSnap $File
        fi
    done

    app_CopyFile
    dir_SourceExec "main.sh" "PostInstall"
}

install_Env_cPkg()
{
    log_Print "$0->$FUNCNAME($*)"

    Prefix="cPkg_"
    for Pkg in $(compgen -v | grep cPkg_); do
        gPkgArg=${!Pkg}
        PkgName=${Pkg/$Prefix/''}
        cd $cDirRoot/$cDirPkg/$PkgName
        ParseDir
    done
}

install_Run()
{
    local aPkg="$1"; aArg=$2;
    log_Print "$0->$FUNCNAME(*$)"

    if [ "$aPkg" ]; then
        gPkgArg=$aArg
        cd $cDirPkg/$aPkg
        ParseDir
    else
        pkg_Update
        ParseDir
        install_Env_cPkg
    fi

    pkg_Clear
}
