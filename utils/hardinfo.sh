#!/bin/bash
#--- VladVons@gmail.com

echo
echo "--- Vendor"
dmidecode | grep -A 9 "System Information"

echo
echo "--- CPU"
cat /proc/cpuinfo |\
  grep "model name"

echo
echo "--- RAM"
dmidecode --type memory |\
  grep -E -i "size:|type: DDR|^\s*speed:|factor:" |\
  sed -e 's/^[ \t]*//'
echo
cat /proc/meminfo |\
   grep -E -i "MemTotal|MemFree"

echo
echo "--- MotherBoard"
cat /sys/devices/virtual/dmi/id/board_{vendor,name}

echo
echo "--- Network"
lspci | grep -E -i 'net|wlan'

echo
echo "--- Disk"
cat /sys/class/block/*/device/model
df -h -T | egrep "ext"

echo "--- OS"
cat /etc/os-release |\
  grep -E -i "^name=|version="
#uptime -p
