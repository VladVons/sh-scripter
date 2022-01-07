#!/bin/bash
#--- VladVons@gmail.com
# https://pve.proxmox.com/wiki/Cloud-Init_Support

cUrl="https://cloud.debian.org/images/cloud/buster/20210208-542"

ExecM()
{
  local aExec="$1";

  echo
  echo "--- ExecM: $aExec"
  eval "$aExec"
}

Download()
{
  echo "$0, $FUNCNAME"

  FHtml="index.html"
  ExecM "wget $cUrl -O $FHtml 2>/dev/null"

  grep -Po '(?<=href=")[^"]*' $FHtml | grep generic-amd64 | grep "qcow2" |\
  while read File; do
    ExecM "wget -q --show-progress $cUrl/$File"
  done

  rm $FHtml
}

Create()
{
  local aId=$1; aImg=$2;

  qm create $aId --memory 2048 --net0 virtio,bridge=vmbr192
  qm importdisk $aId $aImg local-lvm
  qm set $aId --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-$aId-disk-0

  qm set $aId --ide2 local-lvm:cloudinit
  qm set $aId --boot c --bootdisk virtio0
  qm set $aId --serial0 socket --vga serial0

  #qm template $aId

  echo
  echo "done"
  echo "set user and password in ProxMox cloud-init web interface"
}

Help()
{
  echo "$0, $FUNCNAME"

  cat << EOF
Ussage:
 Download
 Create 9200 debian-10-generic-amd64-20210208-542.qcow2

Images:
 https://cloud-images.ubuntu.com/minimal/releases/focal/release
 https://cloud.debian.org/images/cloud/buster

EOF
}


Help
#Download
#Create 9200 debian-10-generic-amd64-20210208-542.qcow2

