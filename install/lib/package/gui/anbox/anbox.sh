PreInstall()
{
    add-apt-repository ppa:morphis/anbox-support
}


PostInstall()
{
    modprobe ashmem_linux
    modprobe binder_linux
    ls -l /dev/{ashmem,binder}

    snap install --devmode --beta anbox
    adb start-server
}
