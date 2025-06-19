#!/bin/bash
# VladVons@gmail.com

Pump()
{
  aFile="$1";


  echo "Pump file $aFile with zeros till disk full..."
  dd if=/dev/zero of=$aFile bs=1M status=progress || true

  echo "sync changes"
  sync

  echo
  du -BG $aFile

  echo "remove file"
  rm -f $aFile
}

#Pump /zero.tmp
Pump /mnt/data1/zero.tmp
