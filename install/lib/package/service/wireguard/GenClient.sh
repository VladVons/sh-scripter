#!/bin/bash
# Created: 08.02.2023
# Vladimir Vons, VladVons@gmail.com


UserNetIp=10
UserName=vladvons


Install()
{
    apt install wireguard qrencode
}

InitVar()
{
    ServerConfFile=/etc/wireguard/wg-server01.conf
    ServerIp=$(curl ifconfig.me)
    ServerPort=$(grep "^ListenPort" $ServerConfFile | awk -F "=" '{ print $2 }' | xargs)
    ServerAddress=$(grep "^Address" $ServerConfFile | awk -F "=" '{ print $2 }' | xargs | cut -d '.' -f 1,2,3)
    UserIp=${ServerAddress}.${UserNetIp}
}

GenKeys()
{
    local UserPrivateFile=client.private.key
    local UserPublicFile=client.public.key
    local ServerPublicFile=/etc/wireguard/server01.public.key

    wg genkey | tee $UserPrivateFile | wg pubkey > $UserPublicFile

    UserPrivateKey=$(cat $UserPrivateFile)
    UserPublicKey=$(cat $UserPublicFile)
    ServerPublicKey=$(cat $ServerPublicFile)
}

ClientConf()
{
ConfFile=client.conf
cat <<EOT > $ConfFile
[Interface]
PrivateKey = $UserPrivateKey
Address = $UserIp/32

[Peer]
PublicKey = $ServerPublicKey
Endpoint = $ServerIp:$ServerPort
AllowedIPs = 0.0.0.0/0
EOT

qrencode -t ansiutf8 < client.conf
}

ServerConf()
{
cat <<EOT >> $ServerConfFile

#--- $UserName
[Peer]
PublicKey = $UserPublicKey
AllowedIPs = $UserIp/32
EOT
}

Create()
{
    mkdir -p ./$UserName
    cd ./$UserName

    InitVar
    GenKeys
    ServerConf
    ClientConf

    service wg-quick@wg-server01 restart
}

Create
