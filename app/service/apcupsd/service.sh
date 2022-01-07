TestEx()
{
  #service apcupsd stop
  #apctest

  ExecM "dmesg | grep --ignore-case --color=auto American"
  ExecM "apcaccess"
}
