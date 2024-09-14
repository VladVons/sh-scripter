#!/bin/bash
# Created: 2024.09.14
# Vladimir Vons, VladVons@gmail.com


ServerConf=wg-server_2
source ./WG.sh


GenClient()
{
    ServerIp=vpn2.oster.com.ua

    ClientCreate crawler_1     10 "10.71.2.0/24"
}

#ServerCreate 10.71.2.1/24 10721 eth0

GenClient
ServiceRestart
