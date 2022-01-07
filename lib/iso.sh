#--- VladVons
# http://www.gtkdb.de/index_7_2419.html

# apt install syslinux syslinux-efi pxelinux 

# apt install wimtools cabextract
# wimextract F3_WINPE.WIM 1 --dest-dir=F3_WINPE

#source $0.conf


cDirMnt="/mnt/iso"
cIsoRoot="/mnt/hdd/data1/share/public/image/iso"


Mount()
{
    local aIso=$1;

    File=$(basename "$aIso")
    DirMnt=$cDirMnt/$File
    echo "DirMnt: $DirMnt"
    mkdir -p $DirMnt
    mount -o loop $aIso $DirMnt
}

iso_pmagic()
{
    local aIso=$1; local aDirDst=$2;
    Log "$0->$FUNCNAME, $aIso, $aDirDst"

    mkdir -p $aDirDst
    Mount $aIso

    sh $DirMnt/boot/pxelinux/pm2pxe.sh
    cp pm2pxe/files.cgz $aDirDst
    rm -R pm2pxe
    cp $DirMnt/pmagic/{bzImage,bzImage64,fu.img,initrd.img,m32.img,m64.img} $aDirDst
    umount $DirMnt
}


iso_sysresccd()
{
    local aIso=$1; local aDirDst=$2;
    Log "$0->$FUNCNAME, $aIso, $aDirDst"

    mkdir -p $aDirDst
    Mount $aIso

    cp -R $DirMnt/sysresccd/x86_64/ $aDirDst
    cp $DirMnt/sysresccd/boot/{amd_ucode.img,intel_ucode.img} $aDirDst
    cp $DirMnt/sysresccd/boot/x86_64/{sysresccd.img,vmlinuz} $aDirDst
    umount $DirMnt
}


iso_xubuntu()
{
    local aIso=$1; local aDirDst=$2;
    Log "$0->$FUNCNAME, $aIso, $aDirDst"

    mkdir -p $aDirDst
    Mount $aIso

    cp $DirMnt/casper/{filesystem.squashfs,initrd,vmlinuz} $aDirDst
    umount $DirMnt
}


iso_gparted()
{
    local aIso=$1; local aDirDst=$2;
    Log "$0->$FUNCNAME, $aIso, $aDirDst"

    mkdir -p $aDirDst
    Mount $aIso

    cp $DirMnt/live/{filesystem.squashfs,initrd.img,vmlinuz} $aDirDst
    umount $DirMnt
}


iso_clonezilla()
{
    iso_gparted $1 $2
}


isoExtract()
{
    Log "$0->$FUNCNAME"

    #iso_pmagic     $cIsoRoot/Tools/pmagic_2019_05_30.iso             pmagic
    #iso_gparted    $cIsoRoot/Tools/gparted-live-1.0.0-5-amd64.iso    gparted_x64
    #iso_clonezilla $cIsoRoot/Tools/clonezilla-live-2.6.3-7-amd64.iso clonezilla_x64
    #iso_sysresccd  $cIsoRoot/Linux/systemrescuecd-6.0.3.iso          sysresccd

    #?iso_xubuntu    $cIsoRoot/Linux/xubuntu-18.04.3-desktop-amd64.iso xubuntu_x64
}
