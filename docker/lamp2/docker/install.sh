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
    local CurDir=$PWD

    #for Item in $(cat $aFile 2>/dev/null | grep "^[^\#]"); do
    sed '/^[[:blank:]]*#/d;s/#.*//' $aFile 2>/dev/null |\
    while IFS='=' read Key Val; do
        if [[ "$Key" == .* ]]; then
            cd $CurDir/$Key
        else
            cd $cDirRoot/$cDirPkg/$Key
        fi
        gPkgArg=$Val
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


    log_SetColor g
    dir_Show "*.txt"
    log_SetColor

    dir_Source "*.conf"

    for Item in $(ls *.pkg 2>/dev/null | sort) ; do
        local CurDir=$PWD
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

install_Env()
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

install_Pkg()
{
    local aPkg="$1"; aArg=$2;
    log_Print "$0->$FUNCNAME(*$)"

    Dir=$cDirPkg/$aPkg
    if [ -d $Dir ]; then
        gPkgArg=$aArg
        cd $cDirPkg/$aPkg
        ParseDir
    else
        log_Print "Not found $Dir"
    fi
}

install_Dist()
{
    local aPkg="$1";
    log_Print "$0->$FUNCNAME(*$)"

    Dir="dist/$aPkg"
    if [ -d $Dir ]; then
        cd $Dir
        pkg_Update
        ParseDir
        ParseFile_Pkg $aPkg
        install_Env
        pkg_Clear
    else
        log_Print "Not found $Dir"
    fi
}

install_Help()
{
    echo "ussage: $0 [-d | -p]"
    echo "example: ./install.sh -d python_scraper"
}


case $1 in
    dist|-d)    install_Dist  "$2" ;;
    pkg|-p)     install_Pkg   "$2" ;;
    *)          install_Help  "$2" ;;
esac
