# VladVons@gmail.com


RulesClear()
{
  iptables --flush
  iptables --table nat --flush
  iptables --table nat --delete-chain
  iptables --table mangle --flush

  iptables -P INPUT   ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT  ACCEPT
}


PostInstall()
{
    RulesClear

    cExtIf="eno1"
    IntNet="192.168.0.0/24"

    # NAT
    iptables --append POSTROUTING --table nat --out-interface $cExtIf --source $IntNet --jump MASQUERADE
    #iptables --append POSTROUTING --table nat --jump MASQUERADE

    iptables-save > /etc/iptables/rules.v4
}
