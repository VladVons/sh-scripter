#!/bin/bash

source ../common.conf

cLog="$(pwd)/$0.log"

Dump()
{
  Cmd="./esp_8266.sh"
  #strace -f -o $cLog $Cmd
  #strace -o $0.log -e openat $Cmd > /dev/null
  strace -f -o $cLog -e openat,faccessat,access,stat,execve $Cmd
}

Filter()
{
  #grep "openat(" $cLog | grep -Ev 'ENOENT|O_DIRECTORY|"/lib|"/etc' | awk '{ $1=""; $2=""; print }' > $cLog.1
    cat $cLog |\
    grep -Ev 'ENOENT|O_DIRECTORY|"/lib|"/etc|"/tmp|"/usr' |\
    awk -F'"' '{print $2}' |\
    #xargs -n1 basename |\
    awk 'BEGIN{FS="/"} {print $NF}' |\
    sort | uniq  > $cLog.1
}

Copy()
{
  DirSrc="$cDirMPY/esp-open-sdk/xtensa-lx106-elf"
  DirDst="$cDirMPY/esp-open-sdk-min"

  readarray -t Arr < $cLog.1
  for Item in $(find $DirSrc -type f); do
    File=$(echo $Item | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ " ${Arr[*]} " =~ " $File " ]]; then
      Dst=$DirDst/$(echo $Item | sed "s|$DirSrc/||")
      Dir=${Dst%/*}
      mkdir -p $Dir
      cp $Item $Dst
      echo "$Dst"
    fi
  done
}

#--------

cd ..
#Dump
#Filter
Copy
