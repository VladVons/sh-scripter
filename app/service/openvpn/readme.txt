in virtual LXC:
/etc/pve/lxc/101.conf
lxc.mount.entry: /dev/net dev/net none bind,create=dir # vpn
lxc.cgroup.devices.allow: c 10:200 rwm # vpn
 