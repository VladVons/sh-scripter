# VladVons@gmail.com


Dir_SetAllPerm()
{
  local aDir="$1";

  #chmod -R go+rX,go-w $aDir

  find "$aDir" -type f -print0 | xargs -0 chmod 666
  find "$aDir" -type d -print0 | xargs -0 chmod 777
}


Dir_SetOwnerPerm()
# ------------------------
{
  local aDir="$1"; local aOwner="$2";

  find "$aDir" -print0 | xargs -0 chown "$aOwner"
  find "$aDir" -type f -print0 | xargs -0 chmod 644
  find "$aDir" -type f -name "*.sh" -print0 | xargs -0 chmod 774 # warn
  find "$aDir" -type d -print0 | xargs -0 chmod 755

  #chgrp -R $aOwner $aDir
}


Dir_RemoveOld()
# ------------------------
{
  local aDir=$1; local aDays=$2;

  #find $aDir -type f -atime +${aDays} -delete
  ## touch -m -a -d "40 days ago" FileName.txt
  ## stat FileName.txt.

  #find -L $aDir -type f -atime +${aDays} -delete
  #find -L $aDir -type d -ctime +${aDays} -delete -empty

  find $aDir -type f -mtime +${aDays} -delete
  find $aDir -type d -mtime +${aDays} -delete -empty
}


Dir_MoveOld_DOW()
# Move old files depends on DaysOfWeek
# ------------------------
{
  local aDirSrc=$1; local aDirDst=$2; local aDays=$3; local aDOW=$4;

  #find /bin -printf "1 %M 2 %n 3 %u 4 %g 5 %10s 6 %TY-%Tm-%Td-%Tw 7 %Ta 8 %TH:%TM:%TS 9 %h/ 10 %f\n"
  find ${aDirSrc} -type f -mtime +${aDays} -printf "%Tw %h/%f\n" | awk -v DOW=$aDOW '($1==DOW) {print $2}' | xargs -I {}    mv {} ${aDirDst}
}


Dir_CopyOld_DOW()
# ------------------------
{
  local aDirSrc=$1; local aDirDst=$2; local aDays=$3; local aDOW=$4;

  find ${aDirSrc} -type f -mtime +${aDays} -printf "%Tw %h/%f\n" | awk -v DOW=$aDOW '($1==DOW) {print $2}' | xargs -I {}    cp {} ${aDirDst}
}


Dir_FindLatest()
{
  local aDir="$1";
  Log "$0->$FUNCNAME, $aDir"

  find $aDir -printf '%T+ %p\n' | \
    sort -r | \
    head --lines 40
}



Dir_StrFind()
{
  local aDir="$1"; local aFind="$2";
  Log "$0->$FUNCNAME($*)"

  grep --dereference-recursive --ignore-case "$aFind" "$aDir" | sort | grep --color=auto "$aFind"
}


Dir_ToLower()
# ------------------------
{
  local aDir=$1;
  Log "$0->$FUNCNAME, $aDir"

  find $aDir | xargs rename 'y/A-Z/a-z/' *
  #rename 'y/A-Z/a-z/' *

  #rename 's/\.jpeg$/\.jpg/' *.jpeg
}


Dir_SymLinks()
# ------------------------
{
  local aDir=$1;
  Log "$0->$FUNCNAME($*)"

  ls -Rl $aDir | grep "^l"
}


Dir_Show()
{
    local aMask="$1";
    Log "$0->$FUNCNAME($*)"
    local Item

    for Item in $(ls $aMask 2>/dev/null | sort); do
        echo "$0->$FUNCNAME $Item ..."
        cat $Item
    done
}


Dir_Source()
{
    local aMask="$1";
    Log "$0->$FUNCNAME($*)"
    local Item

    for Item in $(ls $aMask 2>/dev/null | sort); do
        echo "$0->$FUNCNAME $Item ..."
        source $Item
    done
}


Dir_SourceExec()
{
    local aMask="$1"; local aFunc="$2";
    Log "$0->$FUNCNAME($*)"
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

