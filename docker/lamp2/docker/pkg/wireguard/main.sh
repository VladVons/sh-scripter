PostInstall()
{
  cd /etc/wireguard
  wg genkey | tee server01.private.key | wg pubkey > server01.public.key

  systemctl enable wg-quick@wg-server01
}
