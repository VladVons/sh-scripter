#!/bin/bash

IfExt=eth0


ClearRules()
{
  # Flush existing rules
  iptables -F
  iptables -X

  iptables -P INPUT ACCEPT
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD ACCEPT
}

SetRules()
{
  # Load the FTP conntrack module
  modprobe ip_conntrack_ftp

  # Flush existing rules
  iptables -F
  iptables -t nat -F
  iptables -t mangle -F
  iptables -X

  # Set default policies
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT ACCEPT

  # Allow established and related connections
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

  # Allow loopback traffic
  iptables -A INPUT  -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Allow VPN traffic Oster
  ifv=tun_vpn10101
  iptables -A INPUT -p tcp --dport 10101 -j ACCEPT
  iptables -A INPUT -i $ifv -j ACCEPT
  iptables -A OUTPUT -o $ifv -j ACCEPT

  # wireguard VPN. Oster
  ifv=wg-server_1
  iptables -A INPUT -p udp --dport 10711 -j ACCEPT
  iptables -A INPUT  -i $ifv -j ACCEPT
  iptables -A OUTPUT -o $ifv -j ACCEPT
  iptables -A FORWARD -i $ifv -o $ifv -j ACCEPT

  # wireguard VPN. Crawler
  ifv=wg-server_2
  iptables -A INPUT -p udp --dport 10721 -j ACCEPT
  iptables -A INPUT  -i $ifv -j ACCEPT
  iptables -A OUTPUT -o $ifv -j ACCEPT
  iptables -A FORWARD -i $ifv -o $ifv -j ACCEPT

  #OpenVPN Arsenal
  iptables -A INPUT -p tcp --dport 10102 -j ACCEPT
  #OpenVPN SA.Ira
  iptables -A INPUT -p tcp --dport 10111 -j ACCEPT

  # FTP
  iptables -A INPUT -p tcp --dport 21 -j ACCEPT
  iptables -A INPUT -p tcp --dport 50000:51000 -j ACCEPT

  # SSH
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT

  # HTTP
  iptables -A INPUT -p tcp --dport 80 -j ACCEPT

  # HTTPS
  iptables -A INPUT -p tcp --dport 443 -j ACCEPT

  # Allow custom port 1971
  #iptables -A INPUT -p tcp --dport 1971 -j ACCEPT

  # python crawler server
  iptables -A INPUT -p tcp --dport 8182 -j ACCEPT


  # ping icmp
  iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

  # Drop all other traffic
  iptables -A INPUT -i $IfExt -j DROP
}

ClearRules
SetRules

iptables-save > /etc/iptables/rules.v4
