
PreInstall()
{
    CUR_HOSTNAME=$(cat /etc/hostname | tr -d " \t\n\r")
    NEW_HOSTNAME=$(whiptail --inputbox "Enter a hostname" 20 60 "$CUR_HOSTNAME" 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then
        echo $NEW_HOSTNAME > /etc/hostname
        sed -i "s/127.0.1.1.*$CUR_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
    fi
}
