cEnabled=1
cDebug=0
cSleep=60
cDelay=120
#cMailTo=


MonitService()
{
  Debug "$FUNCNAME()"

  mCpuLoad "CpuLoad-1" "1"                                "2.00"

  mProcess "ssh"       "/var/run/sshd.pid"                "/etc/init.d/ssh start"
  #mProcess "smbd"      "/var/run/samba/smbd.pid"          "/etc/init.d/smbd start"
  #mProcess "pure-ftpd" "/var/run/pure-ftpd/pure-ftpd.pid" "/etc/init.d/pure-ftpd start"
  #mProcess "mpd"       "/var/run/mpd/pid"                 "/etc/init.d/mpd start"
  #mProcess "bind"      "/var/run/named/named.pid"         "/etc/init.d/bins9 start"

  #mFileAccess "FA_py-relay"      "/var/log/py-relay/py-relay.wd.log"          10 "shutdown -r 0 'Watch Dog'"
}


MonitDisk()
{
  Debug "$FUNCNAME()"

  #mMount    "ExtUsb"    "/dev/sda1"                        "mount /dev/sda1"

  mDiskFree "DF-root"   "/"                                "80%"
  #mDiskFree "DF-data"   "/mnt/hdd/data1"                   "90%"

  #mDirPerm "wwwPerm"   "/var/www/enabled"                 ":www-data"                           664     774
}


CallBackUserLoop_10()
{
  Debug "$FUNCNAME()"
}


CallBackUserLoop_1()
{
  Debug "$FUNCNAME()"

  MonitService
  MonitDisk
}


CallBackUserLoop()
{
  local aCnt=$1
  Debug "$FUNCNAME($*)"

  CallBackUserLoop_1

  if [ $(expr $aCnt % 10) -eq 0 ]; then
    CallBackUserLoop_10
  fi
}
