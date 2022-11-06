# VladVons@gmail.com


cClBlack="\033[0;30m"
cClRed="\033[1;31m"
cClGreen="\033[1;32m"


ColorEcho()
{
    local aColor=$1; local aMsg="$2";

    case $aColor in
        black | b)      Color=$cClBlack ;;
        red   | r)      Color=$cClRed ;;
        green | g)      Color=$cClGreen ;;
                *)      aMsg="$1"
    esac
    [ "$aMsg" ] && aMsg="$Color$aMsg${Code}\033[0m"
    echo -e "$aMsg"
}

Log()
{
    local aMsg="$1";

    cFileLog="./docker.log"

    Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $aMsg"
    echo "$Msg"
    echo "$Msg" >> $cFileLog
}


ExecM()
{
    local aExec="$1"; local aMsg="$2";

    echo
    Log "$0, $aExec, $aMsg"
    eval "$aExec"
}
