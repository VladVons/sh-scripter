#!/bin/bash
# Created: 2023.02.08
# Vladimir Vons, VladVons@gmail.com


SysDir=/etc/wireguard


Version()
{
    echo "VladVons@gmail.com, v1.03, 2023.02.12"
}

Log()
{
    local aMsg="$1";

    local Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg, $ServerConf"
    echo "$Msg"
    echo "$Msg" >> $0.log
}

Install()
{
    apt install wireguard qrencode 
    #apt install wondershaper
}

ServiceInstall()
{
    Log "$FUNCNAME($*)"

    sysctl -w net.ipv4.ip_forward=1
    systemctl enable wg-quick@$ServerConf
    systemctl start wg-quick@$ServerConf
    service wg-quick@$ServerConf restart
}

ServiceRemove()
{
    Log "$FUNCNAME($*)"

    systemctl disable wg-quick@$ServerConf
    systemctl stop wg-quick@$ServerConf
    #ip link set dev $ServerConf down
}

ServiceRestart()
{
    Log "$FUNCNAME($*)"

    service wg-quick@$ServerConf restart
    wg show
}

GenKeys()
{
    local UserPrivateFile=$UserDir/$UserBase.private.key
    local UserPublicFile=$UserDir/$UserBase.public.key
    local ServerPublicFile=/etc/wireguard/$ServerConf.public.key

    wg genkey | tee $UserPrivateFile | wg pubkey > $UserPublicFile
    UserPrivateKey=$(cat $UserPrivateFile)
    UserPublicKey=$(cat $UserPublicFile)
    ServerPublicKey=$(cat $ServerPublicFile)
}

ClientConf()
{
    local ServerPort=$(grep "^ListenPort" $ServerConfFile | awk -F "=" '{ print $2 }' | xargs)
    local ServerAddress=$(grep "^Address" $ServerConfFile | awk -F "=" '{ print $2 }' | xargs | cut -d '.' -f 1,2,3)
    UserIp=${ServerAddress}.${UserNetIp}

    if [ -z "$Net" ]; then
        Net=${ServerAddress}.0/24
    fi

    local Now=$(date +%Y-%m-%d)
    local ConfFile=$UserDir/$UserBase.conf

    export UserPrivateKey UserIp ServerPublicKey ServerIp ServerPort Net Now
    cat eClient.tpl | envsubst > $ConfFile

    qrencode --read-from=$ConfFile --type=png --output=$ConfFile.png
    qrencode --read-from=$ConfFile --type=ansiutf8 --output=$ConfFile.qr.txt
}

ClientToServer()
{
    export UserDir UserPublicKey UserIp
    cat eServerClient.tpl | envsubst >> $ServerConfFile
}

ClientCreate()
{
    UserName=$1; UserNetIp=$2; Net=$3;
    Log "$FUNCNAME($*)"

    UserBase="wg-${UserName}_${UserNetIp}"
    UserDir="$ServerConf/$UserBase"
    mkdir -p $UserDir

    GenKeys
    ClientConf
    ClientToServer
}

ClientsCreate()
{
    local aUser=$1; local aIpFrom=$2; local aIpTo=$3; local aNet=$4;
    Log "$FUNCNAME($*)"

    for i in $(seq $aIpFrom $aIpTo); do
        ClientCreate $aUser $i $aNet
    done
}

ServerCreate()
{
    local aNetIp=$1; local aPort=$2; local aNetIf=$3;
    Log "$FUNCNAME($*)"

    UserBase=$ServerConf
    UserDir="$ServerConf/$UserBase"
    mkdir -p $UserDir

    GenKeys
    cp $UserDir/* $SysDir

    local Now=$(date +%Y-%m-%d)

    export aNetIp aPort UserPrivateKey aNetIf Now
    cat eServer.tpl | envsubst > $ServerConfFile

    ServiceInstall
}

LimitSpeed()
{
    local aDownlSpeed=$1; aUplSpeed=$2;
    Log "$FUNCNAME($*)"

    #tc qdisc del dev $ServerConf root
    #sleep 1
    #tc qdisc add dev $ServerConf root tbf rate $aDownlSpeed burst 15kbit latency 56ms
    #tc qdisc show dev $ServerConf

    wondershaper clear $ServerConf
    wondershaper $ServerConf $aDownlSpeed $aUplSpeed
}
