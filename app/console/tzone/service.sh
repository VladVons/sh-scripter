TestEx()
{

    ExecM "cat /etc/timezone"

    #timedatectl list-timezones
    ExecM "timedatectl"

    #cat /etc/timezone | xargs timedatectl set-timezone
}

