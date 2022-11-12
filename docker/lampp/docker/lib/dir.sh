# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

dir_Source()
{
    local aMask="$1";
    log_Print "$0->$FUNCNAME($*)"

    local Item
    for Item in $(ls $aMask 2>/dev/null | sort); do
        echo "$0->$FUNCNAME $Item ..."
        source $Item
    done
}

dir_SourceExec()
{
    local aMask="$1"; local aFunc="$2";
    log_Print "$0->$FUNCNAME($*)"
    local Item

    # dont use while read
    for Item in $(ls $aMask 2>/dev/null | sort); do
        if grep -Fxq "$aFunc()" $Item;  then
            echo
            echo "$0->$FUNCNAME $aFunc $Item ..."
            source $Item
            $aFunc
        fi
    done
}

dir_Show()
{
    local aMask="$1";
    log_Print "$0->$FUNCNAME($*)"

    local Item
    for Item in $(ls $aMask 2>/dev/null | sort); do
        echo "$0->$FUNCNAME $Item ..."
        cat $Item
        echo
    done
}
