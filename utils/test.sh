#!/bin/bash
#--- VladVons@gmail.com

clear

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh
source $cDirLib/mail.sh
source $cDirLib/file.sh

#File_StrReplace sshd_config "#PermitRootLogin prohibit-password" "PermitRootLogin=yes #VladVons"
#if [ ! -z $(File_StrKeyFind sshd_config PermitRootLogin1 " ") ]; then
#    echo OK
#fi

#FileFind="fstab-p"
#File="fstab"
#comm -13 <(sort $File) <(sort $FileFind) 2>/dev/null

#LinesDif=$(comm -13 $File $FileFind 2>/dev/null | sed '/^\s*$/d' | wc -l)
#if [ $LinesDif -gt 0 ]; then
#    echo "Dif"
#fi

x1=$(tune2fs -l $(findmnt / -o source -n) | grep 'Filesystem created' | awk '{print $3,$4,$5,$6,$7}')
#dumpe2fs /dev/sda1 | grep 'Filesystem created:'
#echo $x1

#findmnt / -o source -n
#df -P / | tail -1 | cut -d" " -f1

ls -ldc --full-time /etc | awk '{print $6}'

