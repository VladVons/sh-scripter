# VladVons@gmail.com

PostInstall()
{
    eMail="vladvons@gmail.com"

    postfix check
    postmap /etc/postfix/sasl_passwd

    eHostName=$(hostname -A)
    export eHostName

    postsuper -d ALL
    postconf -e compatibility_level=2
    postconf -e inet_protocols=ipv4

    service postfix restart
    echo "test body" | mail -s "test postfix $HOSTNAME 1" $eMail
    journalctl --since today | grep postfix | tail -20

    #echo "root: vladvons@gmail.com" >> /etc/aliases
    grep -q "^root: $eMail" /etc/aliases || echo "root: $eMail" >> /etc/aliases
    newaliases
    echo "test body" | mail -s "test postfix $HOSTNAME 2" root
}

#PostInstall
