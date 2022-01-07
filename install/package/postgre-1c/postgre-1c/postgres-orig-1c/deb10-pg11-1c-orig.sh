#!/bin/bash
#--- VladVons@gmail.com
# 2021.03.28
#
# https://interface31.ru/tech_it/2019/09/ustanovka-postgresql-1c-10-dlya-1spredpriyatie-na-debian-ubuntu.html


cPgVer="11"
cLocale="uk_UA"
cPgPassw="oster2020"
cPgData="/mnt/hdd/data1/postgresql/$cPgVer/main"
#
cService="postgresql"
cPgConf="/etc/postgresql/$cPgVer/main"
cPgBin="/usr/lib/postgresql/$cPgVer/bin"


Help()
{
  echo "$0, $FUNCNAME"

  echo "About: install postgres for 1C (VladVons)"
  echo "Tested on debian 10 + postgres 11"
}

ExecM()
{
  local aExec="$1";

  echo
  echo "--- ExecM: $aExec"
  eval "$aExec"
}

Locales()
{
  echo "$0, $FUNCNAME"

  locale-gen ${cLocale} ${cLocale}.UTF-8
  update-locale LC_ALL=${cLocale}.UTF-8 LANG=${cLocale}.UTF-8
  dpkg-reconfigure locales

  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

  dpkg-reconfigure tzdata
}

DownloadDeb()
{
  echo "$0, $FUNCNAME"

  wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb
  wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu55_55.1-7ubuntu0.5_amd64.deb
}

InstallPgPkg()
{
  echo "$0, $FUNCNAME"

  apt install -y libllvm6.0

  Order="libssl libicu55 libpq5 client postgresql-${cPgVer}"
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
  Order="libpq5 postgresql-${cPgVer} postgresql-client-${cPgVer}"
  for Item in $Order; do
    ExecM "apt-mark hold $Item"
  done
}

InitPg()
{
  echo "$0, $FUNCNAME"

  mkdir -p $cPgData
  ExecM "chown -R postgres:postgres $cPgData"

  systemctl stop $cService
  sleep 2

  ls -1 $cPgConf/{pg_hba.conf,postgresql.conf}
  sed -i "s|all             127.0.0.1/32|all             0.0.0.0/0|" $cPgConf/pg_hba.conf
  sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" $cPgConf/postgresql.conf
  sed -i "s|data_directory = '/var/lib/postgresql/${cPgVer}/main'|data_directory = '$cPgData'|" $cPgConf/postgresql.conf

  echo "run as postgres user"
  su -c "$cPgBin/initdb -D $cPgData --locale=$cLocale.UTF-8 --lc-collate=$cLocale.UTF-8 --lc-ctype=$cLocale.UTF-8 --encoding=UTF8" postgres
  su -c "$cPgBin/pg_ctl -D $cPgData start" postgres
  su -c "$cPgBin/psql -U postgres -d template1 -c \"ALTER USER postgres PASSWORD '$cPgPassw'\"" postgres
  su -c "$cPgBin/psql -l -U postgres" postgres

  ExecM "systemctl start $cService"
}


Run()
{
  echo "$0, $FUNCNAME"

  Locales
  DownloadDeb
  InstallPgPkg
  HoldPkg
  InitPg
}


Help

echo "Run $0 ?"
read -p "Press Enter to continue or Ctrl-C ..."
Run
