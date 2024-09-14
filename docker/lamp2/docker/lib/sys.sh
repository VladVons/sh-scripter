# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

sys_ExecM()
{
    local aExec="$1"; local aMsg="$2";
    log_Print "$0, $FUNCNAME($*)"

    eval "$aExec"
}

sys_ExecAs()
{
    local aUser=$1; aCmd=$2; aDir=$3;
    log_Print "$0, $FUNCNAME($*)"

    if [ -n "$aDir" ]; then
       aCmd="cd $aDir && $aCmd"
    fi
    su - $aUser -c "$aCmd"
}

sys_Services()
{
    local aServices="$1"; aMode="$2";
    log_Print "$0->$FUNCNAME($*)"

    if [ -z "$aServices" ]; then
        aServices=$(ls $cDirInit)
    fi

    for Service in $aServices; do
        File=$cDirInit/$Service
        if [ -f "$File" ]; then
            sys_ExecM "$File $aMode 2>/dev/null"
            #sleep 0.5
            #service $Service $aMode
            #sleep 0.5
            #$File status
            #ps aux | grep $Service | grep -v grep
        else
            log_Print "Err: File not exists $File"
        fi
    done
}

sys_Random()
{
    local aLen=$1;
    cat /dev/urandom | tr -dc A-Za-z0-9 | head -c $aLen
}

sys_TimeZone()
{
    local aZone="$1";
    log_Print "$0->$FUNCNAME($*)"

    FileTimeZone="/usr/share/zoneinfo/$aZone"
    FileLocalTime="/etc/localtime"

    if [ -f $FileTimeZone ]; then
        rm $FileLocalTime
        ln -s $FileTimeZone $FileLocalTime
    fi
}
