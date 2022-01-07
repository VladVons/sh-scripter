TestEx()
{
    ExecM "fs_cli -x 'show registrations'"
    ExecM "fs_cli -x 'list_users'"
    ExecM "fs_cli -x 'show calls'"

    #reloadxml
    #reload mod_sofia
}
