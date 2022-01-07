#--- VladVons@gmail.com

source $cDirLib/dir.sh
source $cDirLib/mail.sh
source $cDirLib/net.sh
source $cDirLib/sys.sh


CheckLastArch()
{
    local aDir=$1; local aDays=$2;
    Log "$0->$FUNCNAME, $aDir, $aDays"

    # global vars
    #gUser, gMailTo, gCheckCRC, gPasswArch, gFtpHost, gFtpUser, gFtpPassw, gFtpHost

    Host=$(hostname)

    #IsAny=$(ls $aDir/*.{7z,zip,gz} 2>/dev/null | tail -n1)
    Filter=".*\.(7z|zip|.gz)"
    IsAny=$(find $aDir   -maxdepth 1 -type f -regextype posix-extended -iregex $Filter | sort | tail -n1)

    Last=$(find -L $aDir -maxdepth 1 -type f -regextype posix-extended -iregex $Filter -mtime -${aDays} | tail -n1)

    Sys_GetInfo
    Info="$GetInfoRes
File: $Last

Files:
$(find -L $aDir -type f | sort)
"
    #echo "----- aDir: $aDir, Last: $Last"
    if [ -z "$Last" ]; then
        if [ "$IsAny" ]; then
            Subject="Err:No backup, Host:$Host, User:$cUser"
            Mails_Send $cMailTo "$Subject" "$Info"
        else
            echo "Dir is empty. Skip $aDir"
        fi
        return 0
    fi

    #echo "----- aDir: $aDir, Last: $Last"
    Size=$(stat -c%s $Last)
    if [ $cMinSize -ne 0 ] && [ $Size -lt $cMinSize ]; then
        Subject="Err:Bad file length $Size. Host:$Host, User:$cUser"
        Mails_Send $cMailTo "$Subject" "$Info"
        return 0
    fi

    if [ $cCheckCRC -eq 1 ]; then
        echo "Check CRC state: $cCheckCRC"
        echo "Try password $cPasswArch for $Last"
        7z t -p$cPasswArch $Last 2>&1 > /dev/null
        if [ $? -ne 0 ]; then
            Subject="Err:Bad archive CRC, Host:$Host, User:$cUser"
            Mails_Send $cMailTo "$Subject" "$Info"
            return 0
        fi
    fi

    chown root:root $Last
    chmod 644 $Last

    if [ "$cFtpHost" ]; then
        echo "OK"
        #File="$(basename $0)_${RANDOM}.gz"
        File=$(basename $0)_$(date +%Y%m%d_%H%M%S).gz
        FilePath="/tmp/$File"
        echo $Info | gzip -cf > $FilePath
        wput -B -u $FilePath ftp://$cFtpUser:$cFtpPassw@$cFtpHost/$File
        rm  $FilePath
    fi
}


ParseStrList()
{
    local aList=$1;
    Log "$0->$FUNCNAME"

    for Dir in $aList; do
        DirUser=`awk -v Str="$Dir" -v Search="/$cDirBackup" "BEGIN{print substr(Str, 0, index(Str, Search))}"`

        echo "DirUser: $DirUser"
        [ -r $cDirHome/user.conf ] && source $cDirHome/user.conf
        [ -r $DirUser/user.conf ] && source $DirUser/user.conf

        #DirOld=$(dirname $Dir)/old
        #DirOld=$cDirHome/$cDirOld
        DirOld=$DirUser/$cDirOld
        mkdir -p $DirOld
        #echo "Dir: $Dir,$DirOld User:$cUser, Passw:$cPassw, MailTo:$cMailTo, PasswArch:$cPasswArch"

        if [ "$cDOW" ]; then
            Dir_RemoveOld $DirOld $cDaysInOld
            Dir_CopyOld_DOW $Dir $DirOld $cDaysInCurrent $cDOW
        fi
        Dir_RemoveOld $Dir $cDaysInCurrent

        CheckLastArch $Dir $cDaysNoFile
    done
}
