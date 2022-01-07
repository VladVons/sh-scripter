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
}
