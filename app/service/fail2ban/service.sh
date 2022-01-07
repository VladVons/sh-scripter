GetBanCountry()
{
    cnt=0
    iptables -S | egrep "f2b|fail2ban" | grep -E "REJECT|DROP" | sort -V | uniq | \
    while read i; do
        ((cnt++))

        ip=`echo $i | grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}"`
        country=$(geoiplookup -l $ip | grep -i "country" | awk -F: '{print $2}')
        echo "$cnt, IP $ip, Country ${country##*:}"
    done
}


TestEx()
{
    GetBanCountry | column -t
}
