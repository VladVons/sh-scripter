PostInstall()
{
    Dir="/usr/lib/eXtplorer"
    File="temp.zip"
    Url="https://extplorer.net/attachments/download/99/eXtplorer_2.1.15.zip"

    sys_ExecM "wget --quiet --output-document=$File $Url"
    sys_ExecM "unzip -q -o -d $Dir $File && rm $File"
    chown -R www-data $Dir
}
