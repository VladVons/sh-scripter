#!/bin/bash
#--- VladVons@gmail.com, 2021/04/05
#
#Extends LVM on logical extended disk
#https://habr.com/ru/post/252973/



ExecM()
{
  local aExec="$1";

  echo
  echo "--- ExecM: $aExec"
  eval "$aExec"
}

ResizeExtPart()
{
  local aDev="$1"; local aLvName="$2";

  DiskSize=$(parted $aDev u MB p | grep $aDev | awk '{ print $3 }')
  PartExt=$(parted $aDev p | grep extended | awk '{ print $1 }')
  PartLog=$(parted $aDev p | grep " logical" | awk '{ print $1 }')
  DevLv=$(lvdisplay | grep "LV Path" | awk '{ print $3}' | grep $aLvName)

  lsblk --paths $aDev
  #parted $aDev u MB p
  cat << EOF

 Device $aDev
 DevLv $DevLv
 DiskSize $DiskSize
 PartExtNo $PartExt
 PartLogNo $PartLog

 It will increase $DevLv to all free space
EOF

  read -p "Press Enter to resize"
  ExecM "parted $aDev resizepart $PartExt $DiskSize"
  ExecM "parted $aDev resizepart $PartLog $DiskSize"
  ExecM "pvresize $aDev${PartLog}"
  ExecM "lvextend $DevLv -l +100%FREE"

  #resize2fs $aDev

  echo "done"
  lsblk $DevLv
}

ResizeExtPart /dev/vda swap
