# VladVons@gmail.com


PreInstall()
{
    cat /var/lib/locales/supported.d/*

    locale -a
    #dpkg-reconfigure locales
    #dpkg-reconfigure localepurge

    #dpkg-reconfigure tzdata
}


PostInstall()
{
    cat /etc/timezone | xargs timedatectl set-timezone
}
