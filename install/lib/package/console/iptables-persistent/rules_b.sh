#!/bin/bash

IfExt=eth0
IfVpn=tun_vpn10101

# Load the FTP conntrack module
modprobe ip_conntrack_ftp

# Flush existing rules
iptables -F
iptables -X

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow my VPN traffic
iptables -A INPUT -i $IfVpn -j ACCEPT
iptables -A OUTPUT -o $IfVpn -j ACCEPT

# Allow FTP (port 21)
iptables -A INPUT -p tcp --dport 21 -j ACCEPT

# Allow SSH (port 22)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP (port 80)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow HTTPS (port 443)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow custom port 1971 VPN
iptables -A INPUT -p tcp --dport 1971 -j ACCEPT

# Allow custom port 10101 VPN
iptables -A INPUT -p tcp --dport 10101 -j ACCEPT

# Allow Passive FTP ports (e.g., 50000-51000)
iptables -A INPUT -p tcp --dport 50000:51000 -j ACCEPT

# allow icmp ping
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Drop all other traffic
iptables -A INPUT -i $IfExt -j DROP


#iptables-save > /etc/iptables/rules.v4
