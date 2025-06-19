#!/bin/bash

#https://pve.proxmox.com/wiki/Software-Defined_Network
Install_sdn()
{
    apt install --no-install-recommends \ 
        libpve-network-perl dnsmasq frr-pythontools

    systemctl disable --now dnsmasq
    systemctl enable frr.service
}

#Install_sdn
