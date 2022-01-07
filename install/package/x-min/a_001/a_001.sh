# VladVons@gmail.com
# https://www.pestmeester.nl

PostInstall()
{
    User=vladvons
    adduser $User 
    usermod -aG tty $User
}
