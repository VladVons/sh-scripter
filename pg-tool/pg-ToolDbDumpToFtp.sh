#!/bin/bash
#--- VladVons@gmail.com
# 2021.12.10


source ./pg-CommonTool.sh

cFtp="ftp://$cFtpUser:$cFtpPassw@$cFtpHost/Backup/DB"


BackUp()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aDbName=$1;

  DbDumpToFtp "$aDbName" "$cFtp"
}

BackUpAll()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  for Db in $(DbList); do
    DbDumpToFtp $Db $cFtp
  done
}


#---
#ExecAs "psql -l -U postgres"
DbList
WaitKey
Log

#BackUp
BackUpAll
Log "$0, $FUNCNAME. Done"
