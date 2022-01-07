# VladVons@gmail.com

SetUpdateAlternative()
{
    source /etc/os-release

    mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.orig

    File="/etc/apt/sources.list.d/no-subscription.list"
    echo "deb http://download.proxmox.com/debian/pve $VERSION_CODENAME pve-no-subscription" > $File
}


GetDebLxc()
{
    pveam update
    Pkg=$(pveam available | grep debian-10 | awk '{ print $2 }')
    pveam download local $Pkg
}


PreInstall()
{
    # allow nested virtualization
    echo "options kvm-intel nested=Y" > /etc/modprobe.d/kvm-intel.conf

    mkdir -p /mnt/{hdd/data1,iso,smb/temp,usb}

    dpkg-reconfigure locales
    dpkg-reconfigure tzdata

    GetDebLxc
    SetUpdateAlternative
    Pkg_Update
}
