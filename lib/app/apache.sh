# VladVons@gmail.com


apache_GenPasswFile()
{
  local aUser=$1; local aPassw=$2; local aFile=$3;
  Log "$0->$FUNCNAME($*)"

  htpasswd -cb $aFile $aUser $aPassw
}
