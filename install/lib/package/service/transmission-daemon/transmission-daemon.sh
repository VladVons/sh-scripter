# VladVons@gmail.com

PostInstall()
{
    # http://localhost:9091
    # user transmission, passw transmission

    service transmission-daemon stop
    cp fstatic/etc/transmission-daemon/settings.json /etc/transmission-daemon/

    Dir="/mnt/hdd/data1/share/public/download"
    mkdir -p $Dir
    chown -R $Dir debian-transmission:nogroup
    chmod -R 777 $Dir

    service transmission-daemon start
}
