some problems with avahi in LXC

???
https://github.com/lxc/lxc/issues/25
$ sudo useradd -r avahi-$LXC_NAME # rely on -r to provide a unique UID in 0-1000 range and not create a homedir...
$ host_avahi_uid=id -u avahi-$LXC_NAME
$ lxc-execute --name=$LXC_NAME -- useradd -r -u $host_avahi_uid avahi 
