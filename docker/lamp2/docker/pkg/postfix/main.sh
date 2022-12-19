PostInstall()
{
    chown postfix:postfix /etc/postfix/sasl_passwd

    postfix check
    postmap /etc/postfix/sasl_passwd

    postsuper -d ALL
    postconf -e compatibility_level=2
    postconf -e inet_protocols=ipv4

    #echo "Test via MAIL" | mail -s "Subj-Test via MAIL" vlad@gmail.com
}
