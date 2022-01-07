TestEx()
{
    ExecM "smbstatus"
    ExecM "pdbedit -L -v | grep 'Unix username'"
    ExecM "testparm -s | grep path"
}
