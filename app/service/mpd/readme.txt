in virtual LXC:
/etc/pve/lxc/101.conf
xc.cgroup.devices.allow: c 116:* rwm # audio
lxc.mount.entry: /dev/snd dev/snd none bind,optional,create=dir #audio


# client
apt install cantata
 