# VladVons@gmail.com


File_StrReplace()
{
    local aFile=$1; local aSearch=$2; local aReplace=$3;

    sed -i "s/$aSearch/$aReplace/g" $aFile
}


File_StrKeyFind()
{
    local aFile=$1; local aKey=$2; local aDelim=${3:-"="};

    awk -F"${aDelim}" -v Key="$aKey" '$1==Key {print $2}' $aFile
}


File_GetSize()
{
    local aFile=$1;

    stat -c %s  $aFile
}


File_Show()
# IN: FileName, Action
# Actions: S, SG, SGC, ST, SGT
# S   -Show whole file
# SG  -Show+Grep
# SGC -Show+Grep+Count
# ST  -Show+ Tail
# SGT -Show+Greo+Tail...
# ------------------------
{
    local aFile=$1; local aAction=$2;

    if [ ! -r $aFile ]; then
        echo "Error! Can't read file: $aFile"
        return
    fi

    FileSize=$(du $aFile | awk '{ print $1 }')
    echo "$aFile size: $FileSize"

    case $aAction in
        All|SA)         cat $aFile ;;
        Grep|SG)        cat $aFile | grep -i "$3" --color=auto ;;
        GrepCount|SGC)  cat $aFile | grep -c -v "grep" ;;
        Tail|ST)        cat $aFile | tail "-$3" ;;
        GrepTail|SGT)   cat $aFile | grep -i "$3" | tail "-$4" | grep -i "$3" --color=auto ;;
        Uncomment|SU)   cat $aFile | grep -v "^$\|^#" ;;
        *)              echo "Unknown option $aAction"
    esac
}
