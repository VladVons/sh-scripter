#!/bin/sh

CPUT=$(sensors | grep -i "core 0" | awk '{print $3}' | egrep -o -E '[0-9\.]+')
CPUT=${CPUT%.*}
#echo $CPUT
exit "$CPUT"
