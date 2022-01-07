#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/std.sh
source $cDirLib/dir.sh
#
source lib/*.sh


PkgUpdate()
{
    Pkg_Update
} 


Help()
{
    echo "No options "
}


clear
case $1 in
    Dir_FindLatest)     $1 $2 $3 $4;;
    Dir_RemoveOld)      $1 $2 $3 $4;;
    Dir_SetAllPerm)     $1 $2 $3 $4;;
    Dir_SetOwnerPerm)   $1 $2 $3 $4;;
    Dir_StrFind)        $1 $2 $3 $4;;
    Dir_ToLower)        $1 $2 $3 $4;;
    NetGetExtIP)        $1 $2 $3 $4;;
    NetSpeed)           $1 $2 $3 $4;;
    PkgRemoveBad)       $1 $2 $3 $4;;
    PkgRemoveOldKernel) $1 $2 $3 $4;;
    PkgRemoveForce)     $1 $2 $3 $4;;
    PkgUpdate|pu)       $1 $2 $3 $4;; 
    ShutDown)           $1 $2 $3 $4;;
    UsbFormat)          $1 $2 $3 $4;;
    *)                  Help ;;
esac
