#!/bin/bash
# Created: 2025.05.20
# Vladimir Vons, VladVons@gmail.com


ServerConf="wg_cloud1"
Net="10.72.1.0/24"
source ./WG.sh


GenServer()
{
  ServerCreate 1 11001 eth0
}

GenClient()
{
    ServerIp=vpn3.oster.com.ua

    #ClientCreate Router     10
    #ClientCreate srv01      11
    #ClientCreate admin01    12
    #ClientCreate user01     21
    #ClientCreate user02     22
}


#GenServer
#GenClient
ServiceRestart
