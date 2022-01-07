#!/bin/bash
#---VladVons@gmail.com
# Sync two directories
# Log diff files and collect them to directory 
  

DirOld=3w_bereka-radio.com.ua/public_html
DirNew=3w_test.oster.com.ua/public_html
Exclude="--exclude public_html/import --exclude import/Common --exclude image/data --exclude image/cache --exclude system/cache"
#
ID=$(hostname)_$(date +%Y%m%d_%H%M%S)
DirDiff=DirSync/$ID

FileDiff=$DirDiff/report.txt
echo $FileDiff


Main()
{
    mkdir -p $DirDiff

    rsync --out-format="%f" --recursive --no-links --size-only --dry-run $Exclude $DirNew/ $DirOld/ > $FileDiff
    cat $FileDiff | xargs -I{} cp --parents {} $DirDiff
    echo "Difference copied to $DirDiff"
    wc -l $FileDiff

    read -p "Update directory?  (y/n): " KeyYN
    case $KeyYN in
        [Yy] ) 
            cat $FileDiff | xargs -I{} cp --parents {} $FileOld
    esac
}

Main

