# add client  to server
# restart wiriguard service on server

systemctl start wg-quick@wg-Srv1_31
systemctl status wg-quick@wg-Srv1_31
#curl ipv4.icanhazip.com
systemctl enable wg-quick@wg-Srv1_31
