#!/bin/bash

vmDir="/mnt/hdd/data1/vz/images"
tmpDir="/root/tmp"

if [ ! -d $tmpDir ]; then
   echo "Creating temp dir $tmpDir"
   mkdir -p $tmpDir
fi

echo
read -e -p "Input CHR version to deploy (6.40.1, etc): " -i "6.49" version

# Check if image is available and download if needed
echo
if [ -f $tmpDir/chr-$version.img ]; then
   echo "CHR image is already available in $tmpDir"
else
   echo "Downloading CHR $version image file"
   cd $tmpDir
   wget --no-check-certificate https://download.mikrotik.com/routeros/$version/chr-$version.img.zip
   unzip chr-$version.img.zip
fi

if [ ! -f $tmpDir/chr-$version.img ]; then
   echo "Error downloading CHR $version image file!"
   exit 0
fi

# List already existing VM's and ask for vmID
echo
echo "list of VM's on this hypervisor!"
qm list
echo
echo "list of CT's on this hypervisor!"
pct list
echo
read -e -p "Please Enter free vm ID to use: " -i "101" vmID

# Create storage dir for VM if needed.
if [ -f /etc/pve/nodes/pve/qemu-server/$vmID.conf ]; then
   echo "VM exists! Try another vm ID!"
   exit 0
fi

if [ -f /etc/pve/nodes/pve/lxc/$vmID.conf ]; then
   echo "CT exists! Try another vm ID!"
   exit 0
fi

echo
echo "-- Creating VM image dir $vmDir/$vmID"
mkdir -p $vmDir/$vmID

# Creating qcow2 image for CHR.
read -e -p "Please input image size, GB: " -i "3" imgsize
echo "Converting image to qcow2 format "
qemu-img convert \
 -f raw \
 -O qcow2 $tmpDir/chr-$version.img $vmDir/$vmID/vm-$vmID-disk-1.qcow2

if [ $imgsize -ne 0 ]; then
   echo "Resize image to $imgsize GB"
   qemu-img resize $vmDir/$vmID/vm-$vmID-disk-1.qcow2 +${imgsize}G
fi

# Creating VM
echo "-- Creating new CHR VM"
qm create $vmID \
 --name chr-$version \
 --net0 virtio,bridge=vmbr192 \
 --bootdisk virtio0 \
 --ostype l26 \
 --memory 256 \
 --onboot no \
 --sockets 1 \
 --cores 1 \
 --virtio0 local-data1:$vmID/vm-$vmID-disk-1.qcow2
