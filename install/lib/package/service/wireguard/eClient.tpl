# created: $Now
# server: $ServerConf
# note: $Note 

[Interface]
PrivateKey = $UserPrivateKey
Address = $UserIp/32

[Peer]
PublicKey = $ServerPublicKey
Endpoint = $ServerIp:$ServerPort
AllowedIPs = $Net

#-- Nat
PersistentKeepalive = 25
