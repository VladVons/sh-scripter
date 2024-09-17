#--- wireguard
wg-quick up wg-crawler

#-- monitor processes and versions
cd /root/projects/vMonit
./vMonit.sh &

