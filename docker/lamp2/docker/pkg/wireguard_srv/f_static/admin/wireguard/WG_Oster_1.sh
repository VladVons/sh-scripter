#!/bin/bash
# Created: 2023.02.08
# Vladimir Vons, VladVons@gmail.com


ServerConf=wg-server_1
source ./WG.sh

GenClient()
{
    ServerIp=vpn2.oster.com.ua

    #ClientCreate VladVonsPc       11 "0.0.0.0/0"
    #ClientCreate VladVons         12 "0.0.0.0/0"
    #ClientCreate OlgaVons         13 "0.0.0.0/0"
    #ClientCreate DmytroVons       14 "0.0.0.0/0"
    #ClientCreate DavydVons        15 "0.0.0.0/0"
    #ClientCreate SlavaVons        16 "0.0.0.0/0"
    #ClientCreate SergHomitsky     21 "0.0.0.0/0"
    #ClientCreate JuraDovbush      22 "0.0.0.0/0"
    #ClientCreate Alex_Karpenko     23 "0.0.0.0/0"
    #ClientCreate Davyd_Description 31 "0.0.0.0/0"
    #
    #ClientCreate Srv1             51 "0.0.0.0/0"
    #ClientCreate SrvMedCol        52 "0.0.0.0/0"
    #ClientCreate SrvGeelik        53 "10.71.1.0/24"
    #ClientCreate SrvArsenal       54 "10.71.1.0/24"
    #ClientCreate SrvBTG           55 "10.71.1.0/24"
    #ClientCreate SrvGazda          56 "10.71.1.0/24"

    #ClientsCreate user 50 55
    #CreateUsers user 50 55 0.0.0.0/0

    #LimitSpeed 5000 5000
    #ServiceRestart
}


#ServerCreate 10.71.1.1/24 10711 eth0

#GenClient
ServiceRestart
