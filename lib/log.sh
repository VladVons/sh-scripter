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
    local aMsg="$1"; local aShow=${2:-1};

    if [ -z "$cFileLog" ]; then
        cFileLog=$(readlink -e $0).log
    fi

    Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
    echo "$Msg" >> $cFileLog

    if [ $aShow = 1 ]; then
        echo "$Msg"
    fi
}


ExecM()
{
    local aExec="$1"; local aMsg="$2";

    echo
    Log "$0->$FUNCNAME, $aExec, $aMsg"
    eval "$aExec"
}


CheckParam()
# Check parameters quantity bound.
# IN: aCaller, aArgC, aMin, aMax
# ------------------------
{
    local aCaller="$0->$1"; local aArgC=$2; local aMin=$3; local aMax=${4:-$3};
    Log "$aCaller"

    if [ $aArgC -lt $aMin -o $aArgC -gt $aMax ]; then
        Msg="Error! Parameters count $aArgC not in range $aMin..$aMax"
        echo $Msg
        exit 0
    fi
}
