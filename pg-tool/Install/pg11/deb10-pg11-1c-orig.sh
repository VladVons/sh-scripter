#!/bin/bash
#--- VladVons@gmail.com
# 2021.03.28
#
# https://interface31.ru/tech_it/2019/09/ustanovka-postgresql-1c-10-dlya-1spredpriyatie-na-debian-ubuntu.html


source ../../pg-Tool.conf
source ../../pg-Common.sh


cPgVer="11"
cLocale="uk_UA"
cPgPassw="oster2020"
cPgData="$cRoot/postgresql/$cPgVer/main"
#
cPgConf="/etc/$cPgService/$cPgVer/main"
cPgBin="/usr/lib/postgresql/$cPgVer/bin"


Help()
{
  echo
  echo "Install postgres for 1C"
  echo "Tested on debian 10 + postgres 11"
  echo
}

Locales()
{
  Log "$0, $FUNCNAME($*)"

  locale-gen ${cLocale} ${cLocale}.UTF-8
  update-locale LC_ALL=${cLocale}.UTF-8 LANG=${cLocale}.UTF-8
  dpkg-reconfigure locales

  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

  dpkg-reconfigure tzdata
}

DownloadDeb()
{
  Log "$0, $FUNCNAME($*)"

  wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb
  wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu55_55.1-7ubuntu0.5_amd64.deb
  wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu60_60.2-3ubuntu3.2_amd64.deb
}

InstallPgPkg()
{
  Log "$0, $FUNCNAME($*)"

  apt install -y libllvm6.0

  Order="libssl libicu libpq5 client postgresql-${cPgVer}"
  for Item in $Order; do
    Pkg=$(find . -name "*.deb" | grep $Item)
    ExecM "dpkg -i $Pkg"
    apt -f -y install
  done

  ExecM "dpkg -l | grep postgres"
  ExecM "postgres -V"
}

HoldPkg()
{
  Log "$0, $FUNCNAME($*)"

  Order="libpq5 postgresql-${cPgVer} postgresql-client-${cPgVer}"
  for Item in $Order; do
    ExecM "apt-mark hold $Item"
  done
}

InitPg()
{
  Log "$0, $FUNCNAME($*)"

  mkdir -p $cPgData
  ExecM "chown -R postgres:postgres $cPgData"

  ExecM "systemctl stop $cPgService"
  sleep 2

  echo "Conf directory: $cPgConf"
  ls -1 $cPgConf/{pg_hba.conf,postgresql.conf}
  #sed -i "s|all             127.0.0.1/32|all             0.0.0.0/0|" $cPgConf/pg_hba.conf
  #sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" $cPgConf/postgresql.conf
  #sed -i "s|data_directory = '/var/lib/postgresql/${cPgVer}/main'|data_directory = '$cPgData'|" $cPgConf/postgresql.conf
  cp -R conf.d $cPgConf

  echo "run as postgres user"
  ExecAs "$cPgBin/initdb -D $cPgData --locale=$cLocale.UTF-8 --lc-collate=$cLocale.UTF-8 --lc-ctype=$cLocale.UTF-8 --encoding=UTF8"
  ExecAs "$cPgBin/pg_ctl -D $cPgData start"
  ExecAs "$cPgBin/psql -U postgres -d template1 -c \"ALTER USER $cPgUser PASSWORD '$cPgPassw'\""
  ExecAs "$cPgBin/psql -U postgres -d template1 -c \"CREATE DATABASE test1\""
  ExecAs "$cPgBin/psql -l -U postgres"
  #ExecAs "$cPgBin/psql -U postgres -d template1 -c \"SHOW ALL\""

  ExecM "systemctl start $cPgService"
}

GetHugePage()
{
  Pid=$(head -1 $cPgData/postmaster.pid)
  Peak=$(grep ^VmPeak /proc/$Pid/status | awk '{ print $2 }')
  HPS=$(grep ^Hugepagesize /proc/meminfo | awk '{ print $2 }')
  HP=$((Peak/HPS))

  #echo "Pid: $Pid, VmPeak: $Peak kB, HugePageSize: $HPS kB, HugePage: $HP"
  echo $HP
}

Sys()
{
  Log "$0, $FUNCNAME($*)"
  #https://habr.com/ru/post/458860/

  sysctl -a | grep -E "kernel.shmmax|hugepages|vm.swappiness|vm.overcommit|vm.dirty_background|vm.dirty"
  #ipcs -lm

  echo
  echo "Tip: edit /etc/sysctl.conf"
  echo "#postgres"

  sysctl -w kernel.shmmax=$((128*1024*1024))

  #huge_pages 'on' в $PGDATA/postgresql.conf
  sysctl -w vm.nr_hugepages=$(GetHugePage)

  # disable IPv6
  sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sysctl -w net.ipv6.conf.lo.disable_ipv6=1

  sysctl -p
}

Links()
{
  ln -s $cPgConf pg_conf
  ln -s $cPgData/pg_log pg_log
}

Run()
{
  Sys
  Locales
  DownloadDeb
  InstallPgPkg
  HoldPkg
  InitPg
  Links
}


#----
Help
WaitKey
Log
Run

