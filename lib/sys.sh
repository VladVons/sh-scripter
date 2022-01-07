# VladVons@gmail.com


Sys_FindFuncLib()
# Search for object in libraries
#------------------------
{
    local aFunc=$1;
    Log "$0->$FUNCNAME($*)"
    local Item

    local Dir="/usr/lib/";

    find $Dir -type f -executable | \
    while read Item; do
        OBJ_DUMP="$(objdump -tT $Item 2>/dev/null | grep "$aFunc")";
        if [ -n "${OBJ_DUMP}" ]; then
            echo "$Item"
            echo "$OBJ_DUMP"
        fi;
    done
}


Sys_GetInfo()
{
  # error on LXC
  #Installed: $(tune2fs -l $(findmnt / -o source -n) | grep 'Filesystem created' | awk '{print $3,$4,$5,$6,$7}')

  GetInfoRes="
Date:       $(date '+%Y-%m-%d %H:%M:%S')
Host:       $(hostname)
Int IP:     $(hostname -I | awk '{print $1}')
Ext IP:     $(wget -qO - ipinfo.io/ip)
CPU:        $(cat /proc/cpuinfo | grep 'model name' | tail -n 1 | cut -d ':' -f 2)
RAM Mb:     $(grep MemTotal /proc/meminfo | awk '{print int($2/1000)}')
Root disk:  $(df -lh / | tail -n 1 | sed "s/%/%%/")
Uptime:     $(uptime)
Installed:  $(ls -lact --full-time /etc | awk '{print $6}' | sort | head -2)
User:       $(id -u -n)
Last login: $(last | tac | tail -n 1)
"
}


Sys_GetSysInfo()
{
    echo
    echo "Motherboard"
    dmidecode -t system | egrep "Manufacturer:|Name:" 
    #cat /sys/devices/virtual/dmi/id/{board_vendor,board_name,board_version,product_name}

    echo
    echo "Memory"
    dmidecode -t memory | egrep "Type:|Speed:|Factor:|Maximum Voltage" | grep -v Unknown | sort -u

    echo
    echo "VGA"
    lspci | egrep -i 'vga|3d|2d'

    echo
    echo "HDD"
    cat /sys/block/sd*/device/model
}


Sys_ProcInMem()
# Test if process in memory
# IN:  aProcName
# OUT: ProcOwner<->ProcID<->ProcCommand
# ------------------------
{
  local aName=$1
  ps aux | egrep -iv "(grep|ProcInMem)" | egrep -i $aName | awk '{ print $1, $2, $11, $12 }' | column -t | egrep -i $aName --color=auto
}


Sys_SockPort()
{
# Show socket status
# IN: aPort
# ------------------------
  local aPort=$1
  lsof -i :$aPort | grep -i 'listen' --color=auto
}


Sys_ShutDown()
# ShutDown 30 "today 21:30"   (ShutDown in 30 minutes and wakeup in 21:30)
# ShutDown 0  "tomorrow 8:30" (ShutDown now and wakeup in 21:30)
{
    local aWait=${1:-0}; local aWakeUp="$2";
    Log "$0->$FUNCNAME, $aWait, $aWakeUp"

    echo 0 > /sys/class/rtc/rtc0/wakealarm
    if [ ! -z "$aWakeUp" ]; then
        Seconds=$(date +%s --date "$aWakeUp")
        echo "wake up $aWakeUp ($Seconds)"
        rtcwake --verbose --mode no --utc --time $Seconds
    fi

    # debug info
    ExecM "cat /proc/driver/rtc"
    ExecM "cat /sys/class/rtc/rtc0/wakealarm"

    Msg="Power off in $aWait minutes. To abort 'killall shutdown'"
    echo $Msg
    shutdown -P +${aWait} $Msg &
    #--pm-suspend
}
