# Created: ${Now}
# Vladimir Vons, VladVons@gmail.com

[Interface]
Address = $ServerCidr
ListenPort = $aPort
PrivateKey = ${UserPrivateKey}
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${aNetIf} -j MASQUERADE;
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${aNetIf} -j MASQUERADE;
