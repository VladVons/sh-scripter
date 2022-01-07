PreInstall()
{
    source /etc/os-release

    File=/etc/apt/sources.list.d/remmina.list
    echo "deb http://ppa.launchpad.net/remmina-ppa-team/remmina-next/ubuntu $VERSION_CODENAME main" > $File
}
