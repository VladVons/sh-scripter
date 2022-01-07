#!/bin/bash
#--- VladVons@gmail.com

cDirLib=$(readlink -e "../lib")
source $cDirLib/conf.sh
source $cDirLib/log.sh

NetGetHosts()
{ 
  Log "$0->$FUNCNAME"

  IP=$(hostname -I | cut -d ' ' -f 1)

  #ExecM "arp -a | sort | grep ether"
  ExecM "nmap -sP $IP/24"
} 

NetGetHosts
