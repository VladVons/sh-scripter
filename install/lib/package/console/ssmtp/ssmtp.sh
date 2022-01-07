# VladVons@gmail.com

#echo "Test via MAIL" | mail -s "Subj-Test via MAIL-pi" vladvons@gmail.com
#Error: cannot send message: Process exited with a non-zero status
# no issue in internet, so use postfix

PostInstall()
{
    echo 
    #dpkg-reconfigure ssmtp
}
