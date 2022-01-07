TestEx()
{
  ExecM "ifconfig | grep 'inet '"
  ExecM "ip route"
  ExecM "route -n"
}
