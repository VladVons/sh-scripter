#!/bin/bash
# VladVons@gmail.com

cDirRoot=$(pwd)
cDirPackage="package"

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/dir.sh
source $cDirLib/pkg.sh
source $cDirLib/user.sh
source $cDirLib/file.sh
source $cDirLib/std.sh


CheckAskFile()
{
  local aFile=$1;

  if [[ "$aFile" == *".ask"* ]]; then
    Std_YesNo "Install $aFile ?" 30 0
  fi
}

AskUser()
{
    if [ -z "$cUser" ]; then
        if [ -z "$SUDO_USER" ]; then
            read -p "Run script as user: " cUser
        else
            cUser=$SUDO_USER
        fi
    fi
}

CopyFiles()
{
    CheckParam "$FUNCNAME($*)" $# 0
    local Item;

    Dir="fstatic"
    if [ -d $Dir ]; then
        Log "$0->$FUNCNAME, $Dir"
        cp -rb $Dir/* / 2>/dev/null

        for Item in $(find $Dir -wholename "*/home/*" -type f -printf '/%P\n'); do
            User=$(echo $Item | awk -F'/'  '{print $3}')
            echo "Change owner to $User for $Item"
            chown $User:$User $Item
        done
    fi

    Dir="fdynamic"
    if [ -d $Dir ]; then
        find $Dir -type f |\
        while read Item; do
            Log "$0->$FUNCNAME, $Item"
            FileDst=$(echo $Item | sed -e "s|${Dir}||")
            mkdir -p $(dirname $FileDst)

            #(echo "cat <<EOF" ; cat $Item ; echo EOF ) | sh
            cat $Item | envsubst > $FileDst
        done
    fi

    Dir="fappend"
    if [ -d $Dir ]; then
        find $Dir -type f |\
        while read Item; do
            Log "$0->$FUNCNAME, $Item"
            FileDst=$(echo $Item | sed -e "s|${Dir}||")
            mkdir -p $(dirname $FileDst)

            LinesDif=$(comm -13 <(sort $FileDst) <(sort $Item) 2>/dev/null | sed '/^\s*$/d' | wc -l)
            if [ $LinesDif -gt 0 ]; then
                cat $Item >> $FileDst
            fi
        done
    fi
}

ExportEnv()
{
    CheckParam "$FUNCNAME($*)" $# 1
    local aFile="$1";
    local Item;

    test -f $aFile || return

    while read Item; do
        export "$Item"
    done < $aFile
}

ParseFile_LinkLst()
{
    CheckParam "$FUNCNAME($*)" $# 1
    local aFile="$1";

    #echo "Check for $aFile ..."
    local Item
    for Item in $(cat $aFile 2>/dev/null | grep "^[^\#]"); do
        if [[ $Item == /* ]]; then
            cd $Item
        else
            cd $cDirRoot/lib/package/$Item
        fi
        ParseDir
    done
}

ParseDir()
{
    CheckParam "$FUNCNAME($*)" $# 0
    local PWD=$(pwd)
    local Item

    #echo "Show files $PWD/*.txt ..."
    Dir_Show "*.txt"

    #echo "Check for $PWD/*.env ..."
    ls *.env 2>/dev/null | sort |\
    while read Item; do
        echo
        echo "Import environment $Item ..."
        ExportEnv $Item
    done

    #echo "Check for $PWD/*.conf ..."
    Dir_Source "*.conf"

    #echo "Check for $PWD/*.lst ..."
    ls *.lst 2>/dev/null | sort |\
    while read Item; do
        ParseFile_LinkLst $PWD/$Item
    done

    #echo "Check for $PWD/*.sh ..."
    Dir_SourceExec "*.sh" "PreInstall"

    #echo "Check for $PWD/*.apt *.snap  ..."
    for File in $(ls *.apt *.snap 2>/dev/null | sort); do
        CheckAskFile "$File"
        [ $? != 0 ] && continue

        echo
        ColorEcho g "Install: $PWD/$File"

        Ext=${File##*.}
        if [ $Ext == "apt" ]; then
          Pkg_FileListInstallFast $File
        elif [ $Ext == "snap" ]; then
          Snap_FileListInstall $File
        fi
    done

    #echo "Check for $PWD/*.sh.usr  ..."
    for File in $(ls *.sh.user 2>/dev/null | sort); do
        echo
        ColorEcho g "Install: $PWD/$File"
        AskUser
        su - $cUser -c "(export cUser=$cUser;cd $PWD;./$File)"
    done

    CopyFiles

    #echo "Check for $PWD/*.sh ..."
    Dir_SourceExec "*.sh" "PostInstall"
}

ParseDirs()
{
    CheckParam "$FUNCNAME($*)" $# 1
    local aDir="$1";
    local Item


    if [ -d $aDir ]; then
        cd $aDir
        ParseDir

        #passwd and other input doesnt work with 'while'
        #ls -d $DirPkg/*/ 2>/dev/null | while read Run_Item

        #for ItemPD in $( (ls -d $aDir/*/ 2>/dev/null; cat $aDir/link.lst 2>/dev/null | grep "^[^\#]") | sort)
        for Item in $(ls -d $(readlink -e $aDir)/*/ 2>/dev/null); do
            CheckAskFile $(basename $Item)
            [ $? != 0 ] && continue

            cd $Item
            ParseDir
        done

        #echo "Check for $PWD/*.lst ..."
        ls $aDir/*.lst 2>/dev/null | sort |\
        while read Item; do
           ParseFile_LinkLst $Item
        done
    fi
}

Run()
{
    CheckParam "$FUNCNAME($*)" $# 1
    local aFile="$1";

    Dir_Source "$cDirLib/*.conf"

    DirPkg=$cDirRoot/$cDirPackage/$aFile
    FilePkg=$cDirPackage/${aFile}.apt

    if [ -d $DirPkg ]; then
        #ParseDirs $cDirPackage/common
        ParseDirs $DirPkg
    elif [ -f $FilePkg ]; then
        Pkg_FileListInstallFast $FilePkg
        ColorEcho g $Item
    else
        DirPkg=$(find $cDirRoot/lib/package -maxdepth 2 -type d -name $aFile)
        if [ "$DirPkg" ]; then
            cd $DirPkg
            ParseDir
        else
            echo "Cant find $aFile"
        fi
    fi

    Pkg_Clear
}

Help()
# ------------------------
{
  CheckParam "$FUNCNAME($*)" $# 0
  VerInfo="1.07, 2022.01.06, VladVons@gmail.com"


  echo
  echo "Package installer $VerInfo"
  echo "Syntax: $0 [option]"
  echo "Options"
  echo " -r [PackageLst | PackageDir]"
  echo "    Run script from Package directory as file or directory"
  echo "Example : $0 -r nas"
}


echo "Run as user (sys $USER/ sudo $SUDO_USER)"
AskUser

case $1 in
    Run|-r)      Run     "$2";;
    *)           Help    ;;
esac
