# VladVons@gmail.com

PostInstall()
{
    Dir="/mnt/hdd/data1/share/public/download"
    mkdir -p $Dir
    chown -R $Dir debian-transmission:nogroup
    chmod -R 777 $Dir

    ln -s $Dir /var/lib/minidlna
    minidlnad -R
}
