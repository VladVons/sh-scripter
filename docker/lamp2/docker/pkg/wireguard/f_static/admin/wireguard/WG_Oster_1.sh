#!/bin/bash
# Created: 2023.02.08
# Vladimir Vons, VladVons@gmail.com

source ./WG.sh

Conf_01()
{
    ServerConf=wg-server_1
    #ServerIp=$(curl ifconfig.me)
    ServerIp=vpn2.oster.com.ua
    #
    ServerConfFile=$SysDir/$ServerConf.conf

    #ServiceRemove
    #ServerCreate 10.71.1.1/24 10711 eth0


    #ClientCreate VladVonsPc       11 "0.0.0.0/0"
    #ClientCreate VladVons         12 "0.0.0.0/0"
    #ClientCreate OlgaVons         13 "0.0.0.0/0"
    #ClientCreate DmytroVons       14 "0.0.0.0/0"
    #ClientCreate DavydVons        15 "0.0.0.0/0"
    #ClientCreate SlavaVons        16 "0.0.0.0/0"
    #ClientCreate SergHomitsky     21 "0.0.0.0/0"
    #ClientCreate JuraDovbush      22 "0.0.0.0/0"

    #ClientsCreate user 50 55
    #CreateUsers user 50 55 0.0.0.0/0

    LimitSpeed 5000 5000
    #ServiceRestart
}

Test()
{
    ServerConf=wg-server_2
    ServerIp=vpn2.oster.com.ua
    ServerConfFile=$SysDir/$ServerConf.conf

    ServiceRemove

    #CreateUser dovbush2  23 "0.0.0.0/0"
}

Conf_01
#Test
