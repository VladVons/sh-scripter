#!/bin/bash

#Img="2020-02-05-raspbian-buster-lite.img"
Img="2020-02-13-raspbian-buster.img"
Dir="/mnt/img"


ImgMount() 
{

  Offset=$(fdisk -l $Img | grep img1 | awk '{print $2}')
  #Offset=$(fdisk -l $Img | grep img2 | awk '{print $2}')

  mkdir -p $Dir 2>/dev/null
  #losetup -f --show -P $Img
  mount -o loop,offset=$(($Offset * 512)) $Img $Dir
}


Virtual_1()
{
qemu-system-arm \
  -M versatilepb \
  -cpu arm1176 \
  -m 256 \
  -hda $Img \
  -net user,hostfwd=tcp::5022-:22 \
  -dtb ./qemu/versatile-pb.dtb \
  -kernel ./qemu/kernel-qemu-4.19.50-buster \
  -append 'root=/dev/sda2 rootfstype=ext4 rw panic=1' \
  -serial stdio \
  -no-reboot \
  -show-cursor
}

Virtual_4()
{
  qemu-system-arm \
    -M raspi2 \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/sda2" \
    -cpu arm1176 \
    -dtb ./qemu/bcm2709-rpi-2-b.dtb \
    -sd $Img \
    -kernel ./qemu/kernel7.img \
    -serial stdio \
    -no-reboot \
    -show-cursor
}


Virtual_5()
{
  qemu-system-arm \
  -M raspi2 \
  -dtb ./qemu/bcm2710-rpi-2-b.dtb \
  -kernel ./qemu/kernel7.img \
  -cpu arm1176 \
  -serial stdio \
  -append "root=/dev/sda3 rootfstype=ext4 rw" \
  -hda $Img \
  -clock dynticks
}


Virtual_6()
{
qemu-system-arm \
   -kernel ./qemu/kernel-qemu-4.19.50-buster \
   -dtb ./qemu/versatile-pb.dtb \
   -M versatilepb \
   -cpu arm1176 \
   -m 256 \
   -serial stdio \
   -append "rw root=/dev/sda2" \
   -drive file=$Img,format=raw \
   -redir tcp:5022::22  \
   -no-reboot
}

#ImgMount
Virtual_1
#Virtual_4
#Virtual_5
#Virtual_6
