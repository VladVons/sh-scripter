# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>


std_Wait()
# Wait for keyboartd stroke
# ------------------------
{
    local aMsg="$1"; local aTimeOut=${2:-600};

    if [ $# = 0 ]; then
        aMsg="Press a key ..."
    else
        aMsg="-= $aMsg =- Press a key ..."
    fi

    echo
    read -t $aTimeOut -p "$aMsg"
}


std_YesNo()
# Wait for keyboartd stroke Y or N
# Default Timeout=60sec, Result=1 (no)
# ------------------------
{
    local aMsg="$1"; local aTimeOut=${2:-600}; local aResult=${3:-1};
    local KeyYN;

    #if [ $aTimeOut != 600 ]; then
    #    echo "timeout: $aTimeOut, result: $aResult"
    #fi;

    while true; do
        read -t $aTimeOut -p "$aMsg (y/n): " KeyYN
        case $KeyYN in
            [Yy] ) return 0 ;;
            [Nn] ) return 1 ;;
            ''   ) return $aResult ;;
            *    ) echo "answer Y or N";;
        esac
    done
}
