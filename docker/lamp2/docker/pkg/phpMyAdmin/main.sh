PostInstall()
{
    Dir="/usr/lib"
    File="temp.zip"
    Url="https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip"

    sys_ExecM "wget --quiet --output-document=$File $Url"
    sys_ExecM "unzip -q -o $File && rm $File"
    mv $(ls | grep phpMyAdmin) $Dir/phpMyAdmin
    chown -R www-data $Dir/phpMyAdmin
}
