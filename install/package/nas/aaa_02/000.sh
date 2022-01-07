# VladVons@gmail.com
# https://www.pestmeester.nl

source $cDirLib/std.sh


ResizeFlash()
{
    Log "$0->$FUNCNAME"

    ROOT_DEV=$(findmnt / -o source -n)
    resize2fs $ROOT_DEV 2500M
    df -hT /dev/root
}


FormatDisk()
{
    local aDev=$1;
    Log "$0->$FUNCNAME, $aDev"

    Dir="/mnt/hdd/data1"
    lsblk
    echo
    echo "!!! All data will be lost on $aDev !!!"
    if Std_YesNo "format as EXT4 $aDev storage?"; then
        mkfs  -t ext4 -L "oster-nas" $aDev
        mkdir -p $Dir
        mount -t ext4 $aDev $Dir
    fi
}


PreInstall()
{
    mkdir -p /mnt/{smb/temp,hdd/data1,iso,share}
    ##FormatDisk /dev/sda

    #User_SetPassw root
    #User_SetPassw pi

    #dpkg-reconfigure tzdata
    #dpkg-reconfigure locales

    #ResizeFlash

    Pkg_Update
    df -h /
}
