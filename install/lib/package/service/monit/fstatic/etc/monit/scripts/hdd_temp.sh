#!/bin/sh

aDev=$1;

HDDTP=$(/usr/sbin/smartctl -a /dev/$aDev | grep Temp | awk -F " " '{printf "%d", $10}')
#echo $HDDTP 
exit $HDDTP
