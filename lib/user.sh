# VladVons@gmail.com


User_AddParam()
{
    local aUser=$1; local aPassw=$2; local aHome=$3; aParam="$4"
    Log "$0->$FUNCNAME($*)"

    DirHome=$aHome/$aUser
    mkdir -p $DirHome

    useradd $aUser 
    usermod --password $(openssl passwd $aPassw) --home $DirHome $aParam $aUser
    chown $aUser:$aUser $DirHome

    #useradd --password $(openssl passwd $aPassw) --shell /usr/sbin/nologin --home $DirHome --create-home $aUser
}



User_AddNoLogin()
{
    local aUser=$1; local aPassw=$2; local aHome=$3;
    Log "$0->$FUNCNAME($*)"

    User_AddParam $aUser $aPassw $aHome "--shell /usr/sbin/nologin"
}


User_Add()
{
    local aUser=$1; local aPassw=$2; local aHome=$3;
    Log "$0->$FUNCNAME($*)"

    User_AddParam $aUser $aPassw $aHome "--shell /bin/bash"
}


User_Del()
{
    local aUser=$1;
    Log "$0->$FUNCNAME($*)"

    userdel --remove $aUser
}


User_SetPassw()
{
    local aUser=$1;
    Log "$0->$FUNCNAME($*)"

    passwd $aUser
}


User_GetRandPasswMatrix()
{
  local aLen=$1;
  Result=""

  Matrix="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  #Matrix="AaEeIiOoUu"
  while [ ${n:=1} -le $aLen ]; do
    Result=$Result${Matrix:$(($RANDOM%${#Matrix})):1}
    let n+=1
  done

  echo "$Result"
}


User_GetRandPassw()
{
    date +%s | sha256sum | base64 | head -c 32; echo
}
