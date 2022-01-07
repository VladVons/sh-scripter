#!/bin/bash
#--- VladVons@gmail.com

#https://www.kyrylenkoanatolii.com/2018/12/09/nastrojka-iptables
#https://www.thegeekstuff.com/2011/03/iptables-inbound-and-outbound-rules

IPT="/sbin/iptables"
#
cIntIf=eth0
cExtIf=eth1
cIntNetBase=192.168.2
cIntNet=${gIntNetBase}.0/24
#
p_Vpn=1101
p_rdp=3389
p_torrent=61413
#
TimeStart="18:00"
TimeFinish="20:00"
#
echo "gExtIf: $cExtIf, gIntIf: $cIntIf, gIntNet: $cIntNet"


TestPortOpened()
{
    local aHost=$1;

    #http://www.cyberciti.biz/networking/nmap-command-examples-tutorials/
    nmap -F -Pn $aHost
    nmap -v -d -Pn -p 80 $aHost
    nmap -v -d -Pn -p 0-65535 $aHos
    nmap -v -d -Pn -p 0-65535 --min-parallelism 1000 94.247.62.24
}


Clear()
{
    $IPT -F
    $IPT --table nat --flush
    $IPT --table nat --delete-chain
    $IPT --table mangle --flush

    sleep 1
}


Allow()
{
    $IPT -P INPUT   ACCEPT
    $IPT -P OUTPUT  ACCEPT
    $IPT -P FORWARD ACCEPT
}


Block()
{
    $IPT -P INPUT   DROP
    $IPT -P OUTPUT  DROP
    $IPT -P FORWARD DROP
}


BlockBadPackets_1()
{
    $IPT -A INPUT -m state --state INVALID -j DROP
    $IPT -A INPUT -p tcp  ! --syn -m state --state NEW  -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
}

BlockBadPackets_2()
{
    $IPT -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

    $IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    $IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

    $IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
}

UTC()
{
  aTime=$1;

  TZ=$(date '+%z')
  date --utc --date="$aTime today -${TZ:2:1} hours" '+%T'
}


Try()
{
    WaitTime=1

    echo "Computer will be rebooted in $WaitTime minutes ..."
    shutdown -r +${WaitTime} "Ctrl-C to abort"
}


ChainTraffic()
{
    $IPT -N TRAFFIC_ACCT_IN
    $IPT -N TRAFFIC_ACCT_OUT
    $IPT -I FORWARD -i $cExtIf -j TRAFFIC_ACCT_IN
    $IPT -I FORWARD -o $cExtIf -j TRAFFIC_ACCT_OUT

    #iptables -A TRAFFIC_ACCT_IN  --dst 192.168.2.142
    #iptables -A TRAFFIC_ACCT_OUT --src 192.168.2.142

    #iptables -A FORWARD -s 192.168.2.142 -m quota --quota 3146000 -j ACCEPT
    #iptables -A FORWARD -d 192.168.2.142 -m quota --quota 13636000 -j ACCEPT

    #iptables -L TRAFFIC_ACCT_IN -n -v -x
}


RulesBlockWebServer()
{
    Clear
    Block

    #--- allow all on loopback
    $IPT -A INPUT  -i lo -j ACCEPT
    $IPT -A OUTPUT -o lo -j ACCEPT

    #$IPT -A INPUT  -p icmp -j ACCEPT
    $IPT -A OUTPUT -p icmp -j ACCEPT

    #BlockBadPackets_1
    #BlockBadPackets_2
    #ChainTraffic

    # DDOS
    $IPT -A INPUT -p icmp --icmp-type echo-request -m limit --limit 60/minute --limit-burst 120 -j ACCEPT
    $IPT -A INPUT -p icmp --icmp-type echo-request -j DROP
    $IPT -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 5 -j REJECT

    #--- allow established connections
    $IPT -A INPUT  -m state --state RELATED,ESTABLISHED -j ACCEPT

    #$IPT -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    $IPT -A OUTPUT -j ACCEPT

    #--- DNS 
    #$IPT -A INPUT  -p udp --dport domain -j ACCEPT
    $IPT -A OUTPUT -p udp --dport domain -j ACCEPT

    #--- FTP. FUCK!
    # http://www.devops-blog.net/iptables/iptables-rules-for-nat-with-ftp-active-passive
    # modprobe ip_conntrack_ftp in LXC?
    $IPT -A INPUT  -p tcp --dport ftp      -j ACCEPT
    $IPT -A INPUT  -p tcp --dport ftp-data -j ACCEPT
    $IPT -A INPUT  -p tcp --dport 10000:   -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ftp      -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ftp-data -j ACCEPT

    #--- SSH
    $IPT -A INPUT  -p tcp --dport ssh -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ssh -j ACCEPT

    #--- Internet
    $IPT -A INPUT  -p tcp --dport www   -j ACCEPT
    $IPT -A OUTPUT -p tcp --dport www   -j ACCEPT
    $IPT -A OUTPUT -p tcp --dport https -j ACCEPT

    #--- rsync
    #$IPT -A INPUT  -p tcp --dport rsync -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport rsync -j ACCEPT

    #--- smtp
    #$IPT -A INPUT  -p tcp --dport smtp -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport smtp -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport pop3 -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport 587  -j ACCEPT # gmail

    iptables-save > ${0}_$FUNCNAME.ip4
}


RulesBlockRouterNat()
{
    Clear
    Block

    # Log
    #$IPT -A INPUT   -m limit --limit 5/min -j LOG --log-prefix "iptables_INPUT_denied: "   --log-level 7
    #$IPT -A OUTPUT  -m limit --limit 5/min -j LOG --log-prefix "iptables_OUTPUT_denied: "  --log-level 7
    #$IPT -A FORWARD -m limit --limit 5/min -j LOG --log-prefix "iptables_FORWARD_denied: " --log-level 7

    #--- allow all on loopback
    $IPT -A INPUT  -i lo -j ACCEPT
    $IPT -A OUTPUT -o lo -j ACCEPT

    #--- allow all on local net
    $IPT -A INPUT   -s $cIntNet -j ACCEPT
    $IPT -A OUTPUT  -s $cIntNet -j ACCEPT
    $IPT -A FORWARD -s $cIntNet -j ACCEPT

    $IPT -A INPUT  -p icmp -j ACCEPT
    $IPT -A OUTPUT -p icmp -j ACCEPT

    BlockBadPackets_1
    #BlockBadPackets_2
    #ChainTraffic

    #--- allow established connections
    $IPT -A INPUT  -m state --state RELATED,ESTABLISHED -j ACCEPT

    #$IPT -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IPT -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


    $IPT -A FORWARD -i $cExtIf -o $cIntIf -j ACCEPT
    $IPT -A FORWARD -i ${tun}+ -o $cIntIf -j ACCEPT

    #$IPT -A FORWARD -p tcp --match iprange --src-range 192.168.2.120-192.168.2.129 --match time --timestart $(UTC 00:00) --timestop $(UTC $TimeStart) -j DROP
    #$IPT -A FORWARD -p tcp --match iprange --src-range 192.168.2.120-192.168.2.129 --match time --timestart $(UTC $TimeFinish) --timestop $(UTC 23:59) -j DROP

    #--- port forwarding 
    $IPT -A PREROUTING -t nat -p tcp -i $cExtIf --dport 2233  -j DNAT --to ${cIntNetBase}.13 # WinSpy
    $IPT -A PREROUTING -t nat -p tcp -i $cExtIf --dport 10110 -j DNAT --to ${cIntNetBase}.110:$p_rdp
    $IPT -A PREROUTING -t nat -p tcp -i $cExtIf --dport $p_torrent -j DNAT --to ${cIntNetBase}.102
    $IPT -A PREROUTING -t nat -p udp -i $cExtIf --dport $p_torrent -j DNAT --to ${cIntNetBase}.102

    #--- NAT
    #$IPT -t nat -A POSTROUTING -j MASQUERADE
    #$IPT -t nat -A POSTROUTING -o $cExtIf -j MASQUERADE
    $IPT -t nat -A POSTROUTING -s $cIntNet -o $cExtIf -j MASQUERADE

    #--- DNS 
    #$IPT -A INPUT  -p udp --dport domain -j ACCEPT
    $IPT -A OUTPUT -p udp --dport domain -j ACCEPT

    #--- VPN
    #$IPT -A INPUT  -p tcp --dport $p_Vpn= -i $cExtIf -j ACCEPT
    $IPT -A OUTPUT -p tcp --dport $p_Vpn -j ACCEPT
    #$IPT -A OUTPUT -p udp --dport $p_Vpn= -j ACCEPT
    #$IPT -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    #--- FTP. FUCK!
    # http://www.devops-blog.net/iptables/iptables-rules-for-nat-with-ftp-active-passive
    # modprobe ip_conntrack_ftp in LXC?
    $IPT -A INPUT  -p tcp --dport ftp      -j ACCEPT
    $IPT -A INPUT  -p tcp --dport ftp-data -j ACCEPT
    $IPT -A INPUT  -p tcp --dport 10000:   -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ftp      -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ftp-data -j ACCEPT
    #$IPT -A OUTPUT -p tcp --dport 30000:50000 -j ACCEPT
    #$IPT -A INPUT -p tcp --dport 30000:31000 --sport 30000:31000 -j ACCEPT
    #$IPT -A OUTPUT -p tcp --sport 30000:  --dport 30000: -j ACCEPT
    #$IPT -A OUTPUT -p tcp --sport 30000:31000 -j ACCEPT
    #$IPT -A OUTPUT -p tcp --sport 30000:31000 -j ACCEPT
    #$IPT -A INPUT   -p tcp --sport 1024: --dport 1024: -j ACCEPT
    #$IPT -A OUTPUT  -p tcp --sport 1024: --dport 1024: -j ACCEPT
    #iptables -A INPUT -p tcp --dport 1024:1030 -j ACCEPT
    #$IPT -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
    #$IPT -A INPUT -j ACCEPT


    #--- SSH
    $IPT -A INPUT  -p tcp --dport ssh -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport ssh -j ACCEPT

    #--- Internet
    #$IPT -A INPUT  -p tcp --dport www -i $cExtIf -j ACCEPT
    $IPT -A OUTPUT -p tcp --dport www   -j ACCEPT
    $IPT -A OUTPUT -p tcp --dport https -j ACCEPT

    #--- rsync
    $IPT -A INPUT  -p tcp --dport rsync -j ACCEPT
    $IPT -A OUTPUT -p tcp --sport rsync -j ACCEPT

    iptables-save > ${0}_$FUNCNAME.ip4
}


RulesAllowRouterNat()
{
    Clear
    Allow

    $IPT -A PREROUTING -t nat -p tcp -i $cExtIf --dport 10110 -j DNAT --to ${cIntNetBase}.110:$p_rdp

    $IPT -A PREROUTING -t nat -p tcp -i $cExtIf --dport $p_torrent -j DNAT --to ${cIntNetBase}.102
    $IPT -A PREROUTING -t nat -p udp -i $cExtIf --dport $p_torrent -j DNAT --to ${cIntNetBase}.102

    # ??? block ports
    #$IPT --append INPUT --protocol tcp --in-interface $cExtIf --dport 3306 -j DROP
    #$IPT --append INPUT --protocol tcp --in-interface $cExtIf --dport 3128 -j DROP
    #$IPT --append INPUT --protocol tcp --in-interface $cExtIf --dport 3690 -j DROP
    #$IPT --append INPUT --protocol tcp --in-interface $cExtIf --dport 5080 -j DROP

    $IPT --append POSTROUTING --table nat --jump MASQUERADE

    iptables-save > ${0}_$FUNCNAME.ip4
}

#RulesBlockWebServer
#
RulesBlockRouterNat
#RulesAllowRouterNat
#
iptables-save >/etc/iptables/rules.v4
