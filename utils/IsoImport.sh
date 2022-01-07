#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source lib/iso.sh

Main()
{
    cDirMnt="/mnt/hdd/data1/share/public/image/tftp/x86/image/iso-data"
    Mount "$cIsoRoot/Windows/Win7/win7_sp1_x86-x64.iso"
}

Main

