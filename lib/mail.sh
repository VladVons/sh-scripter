# VladVons@gmail.com


Mail_Send()
{
    local aMailTo=$1; local aSubj=$2; local aBody=$3;
    Log "$0->$FUNCNAME($*)"

    echo -e "$aBody" | mail -s "$aSubj" $aMailTo
}


Mails_Send()
{
    local aMailTo=$1; local aSubj=$2; local aBody=$3;

    for Item in $(echo $aMailTo | tr ',' '\n'); do
        Mail_Send $Item "$aSubj" "$aBody"
    done
}


Mail_Install()
{
    apt install ssmtp mailutils openssl libssl-dev
}
