# VladVons@gmail.com


Net_GetLocalIp()
{
    hostname -I | awk '{print $1}'
}

NetGetExtIP()
{
    Log "$0->$FUNCNAME"

    wget -qO - ipinfo.io/ip
    #wget -qO- icanhazip.com
    #wget -qO - ipecho.net/plain
    #wget -qO - ip.appspot.com
    #wget -qO - v4.ipv6-test.com/api/myip.php

    #curl -s "http://v4.ipv6-test.com/api/myip.php"
}

Net_GetHosts()
{ 
  Log "$0->$FUNCNAME"

  arp -a | sort | grep ether
  #nmap -sP $cIntNet
}

Net_Speed()
{ 
    File="speedtest.py"
    wget --no-check-certificate https://raw.githubusercontent.com/sivel/speedtest-cli/master/$File -O /tmp/$File
    chmod +x /tmp/$File
    /tmp/$File
}
