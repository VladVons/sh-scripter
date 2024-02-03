# VladVons@gmail.com

PostInstall()
{
    postfix check
    postmap /etc/postfix/sasl_passwd

    #eHostName=$(hostname -A)
    #export eHostName

    postsuper -d ALL
    postconf -e compatibility_level=2
    postconf -e inet_protocols=ipv4

    service postfix restart
    echo "test body" | mail -s "test postfix $HOSTNAME" vladvons@gmail.com
}

#PostInstall
