PreInstall()
{
    source /etc/os-release

    File=/etc/apt/sources.list.d/youtube-dlg.list
    echo "deb http://ppa.launchpad.net/flexiondotorg/youtube-dl-gui/ubuntu $VERSION_CODENAME main" > $File
}
