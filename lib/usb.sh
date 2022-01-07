Usb_List()
{
    local Item

    ls /dev/disk/by-id/usb* | \
    while read Item; do
        readlink -f $Item
    done
}


Usb_Format()
{
    Log "$0->$FUNCNAME"
    local Item

    # ubuntu zero fill free space
    #dd if=/dev/zero of=outputfile bs=1024K count=1024

    for Item in $(UsbList); do
        Size=$(blockdev --getsz $Item)
        if Std_YesNo "format $Item $(expr $Size / 1000))Kb ?"; then
            umount -f $Item
            dd if=/dev/zero of=$Item bs=512 count=1

            mkntfs --fast --force $Item
            #mkdosfs   -n 'Label' -F32 -I $Item
            #mkfs.ext3 -n 'Label' -I $Item
        fi
    done
}
