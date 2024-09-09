#!/bin/bash
# vladvons 2024.02.03


DirLog=/var/log/nginx
DirReport=/var/www/html/goaccess


Report()
{
    aHost="$1";

    echo "processing $aHost"
    Mask=${DirLog}/${aHost}.log_access.log
    Files=$(ls -1 $Mask.*.gz | sort -V -r)
    zcat $Files >> ${aHost}.log
    cat $Mask >> $aHost.log

    mkdir -p $DirReport
    goaccess $aHost.log -o $DirReport/$aHost.html --log-format=COMBINED
    rm $aHost.log
}

ParseDir()
{
    ls -1 ${DirLog}/*.log_access.log |\
    while read x; do
        Host=`echo $x | sed "s|/var/log/nginx/\(.*\).log_access.log|\1|"`
        Report $Host
    done
}


ParseList()
{
    aHosts="$1";

    for x in $aHosts; do
        Report $x
    done
}

ParseList "used.1x1.com.ua oster.com.ua"
