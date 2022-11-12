# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

log_SetColor()
{
    local aColor=$1;

    local cClBlack="\033[0;30m"
    local cClRed="\033[1;31m"
    local cClGreen="\033[1;32m"
    local cClNormal="\033[0m"

    case $aColor in
        black | b)      Color=$cClBlack ;;
        red   | r)      Color=$cClRed ;;
        green | g)      Color=$cClGreen ;;
                *)      Color=$cClNormal ;;
    esac
    echo -en $Color
}

log_Print()
{
    local aMsg="$1";

    Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $aMsg"
    echo "$aMsg"
    echo "$Msg" >> $cFileLog
}

log_Clear()
{
    log_Print "$0->$FUNCNAME($*)"

    local DirLog=/var/log
    local FExt="gz|xz|tmp|[1-9]"
    find $DirLog -type f -regextype posix-extended -iregex ".*\.($FExt)" -delete

    FExt="log|err|info|warn|txt"
    local FName="messages|syslog"
    find $DirLog -type f -regextype posix-extended -iregex "(.*\.($FExt)|.*($FName))" | xargs -I {} tr
}
