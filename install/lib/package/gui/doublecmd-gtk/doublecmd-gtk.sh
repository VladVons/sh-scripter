PreInstall()
{
    source /etc/os-release

    File=/etc/apt/sources.list.d/doublecmd-gtk.list
    echo "deb http://ppa.launchpad.net/alexx2000/doublecmd/ubuntu $VERSION_CODENAME main" > $File
}
