mkdir -p /admin/conf && rsync --verbose --progress --recursive --compress --links --times --delete tr24.oster.com.ua::AdminFull /admin/conf
mkdir -p /usr/lib/scripter && rsync --verbose --progress --recursive --links --times --delete tr24.oster.com.ua::ScriptFull /usr/lib/scripter
mount -t cifs //192.168.2.102/temp /mnt/smb/temp -o user=guest -o password=guest
rm /root/.ssh/known_hosts
echo -e "aBody" | mail -s "aSubj-2" vladvons@gmail.com
ls -lR . | grep ^l
ssh vladvons@vpn2.oster.com.ua
ssh linux@tr24.oster.com.ua
