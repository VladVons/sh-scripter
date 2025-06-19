#!/bin/bash
# VladVons@gmail.com, 2025.05.22
#
# crontab -e
# * * * * * /path/to/your/script.sh

IfExt=eth0

output=$(ip -4 addr show $IfExt | grep "inet")
if [ -z "$output" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S'). Restart dhcp on $IfExt" >> /var/log/$(basename $0).log

  dhclient -r $IfExt
  rm /var/lib/dhcp/dhclient.*.leases
  dhclient $IfExt
fi
