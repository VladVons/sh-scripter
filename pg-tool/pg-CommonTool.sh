#!/bin/bash
#--- VladVons@gmail.com
# 2021.12.10


source ./pg-Common.sh


DbList()
{
  ExecAs "psql -l -U postgres | awk '{print \$1}' | tail -n +4 | head -n -2 | grep -Evi 'postgres|template|\|'"
}

DbReindex()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aDbName=$1;

  #ExecAs "psql -l -U postgres"

  ExecM "service $cPgService restart"
  ExecM "sleep 1"

  time ExecAs "reindexdb --dbname=$aDbName"
}

DbRestore()
{
  CheckArgCnt "$FUNCNAME($*)" $# 2
  local aDbName=$1; local aFile=$2;

  time ExecAs "zstd -dc $aFile | psql -q -d $aDbName"
}

DbRestoreCreate()
{
  CheckArgCnt "$FUNCNAME($*)" $# 2
  local aDbName=$1; local aFName=$2;

  ExecAs "psql -l -U postgres"

  ExecAs "dropdb $aDbName"
  sleep 1

  ExecAs "createdb $aDbName"
  sleep 1

  DbRestore $aDbName $cDirBackup/$aFName
}

DbDumpToFtp()
{
  CheckArgCnt "$FUNCNAME($*)" $# 2
  local aDbName=$1; local aFtp=$2;

  MaxDays=30

  chown $cPgUser $cDirBackup

  FName=$(uname -n)_$(date "+%y%m%d_%H%M")_${aDbName}.sql.zst
  Path=$cDirBackup/$FName

  mkdir -p $cDirBackup
  if [ -d "$cDirBackup" ]; then
    find $cDirBackup -type f -mtime +${MaxDays} -delete
  fi

  #ExecAs "pg_dump $aDbName --schema-only | zstd -z > $Path"
  ExecAs "pg_dump $aDbName | zstd -z > $Path"
  ExecM "wput --tries=1 $Path $aFtp/$FName"
}

DbDumpStru()
{
  CheckArgCnt "$FUNCNAME($*)" $# 2
  aDbName=$1; aPath=$2;

  FName=$(uname -n)_$(date "+%y%m%d_%H%M")_${aDbName}
  time ExecAs "pg_dump $aDbName --schema-only > ${aPath}/${FName}_stru.sql"
}

FsZerro()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  File="$cRoot/Zerro.dat"

  echo "oOccupy all free space ..."
  ExecM "dd if=/dev/zero of=$File bs=1M status=progress"
  ExecM "rm -Rf $File"
  ExecM "df -h $cRoot"
}

FsCheck()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  Container=$(grep -ca "container" /proc/1/environ)
  if [ $Container == 0 ]; then
    ExecM "service $cPgService stop"
    ExecM "sleep 1"
    ExecM "umount $cDev"
    ExecM "fsck -f $cDev"
    ExecM "mount $cDev"
    ExecM "service $cPgService start"
  else
    echo "Cant fsck in container! Run it in host:"
    echo "pct fsck VMID"
    echo "pct fsck VMID --device mp1"
    WaitKey 3
  fi
}


#ExecSQL test1 "SELECT name  FROM v8users;"
#DbReindex test1
#DbRestoreCreate test1 zpk-vm-deb10-pg11-1c_211202_2315_zpk1.sql.zst
#FsCheck
#FsZerro
