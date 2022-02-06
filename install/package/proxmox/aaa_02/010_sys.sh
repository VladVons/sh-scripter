# VladVons@gmail.com

source $cDirLib/std.sh


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
    BackDoorUser="toor"
    echo "see also: /etc/group, /etc/passwd, /etc/shadow"
    ExecM "useradd --non-unique --uid 0 --gid 0 --home-dir /root --shell /bin/bash $BackDoorUser"
    ExecM "passwd $BackDoorUser"

    VirtOn=$(grep -Ewo 'vmx|svm' /proc/cpuinfo | sort | uniq)
    if [ -z "$VirtOn" ]; then
        grep -Ewo 'vmx|svm|ept|vpid|npt|tpr_shadow|flexpriority|vnmi|lm|aes' /proc/cpuinfo
        Std_YesNo "No CPU virtualization. BIOS ok ?" 30 0
    fi

    # allow nested virtualization
    echo "options kvm-intel nested=Y" > /etc/modprobe.d/kvm-intel.conf

    mkdir -p /mnt/{hdd/data1,iso,smb/temp,usb}

    dpkg-reconfigure locales
    dpkg-reconfigure tzdata

    GetDebLxc
    SetUpdateAlternative
    Pkg_Update
}
