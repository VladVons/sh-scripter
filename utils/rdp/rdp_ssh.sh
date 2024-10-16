#--- dont forget redirect proper ports on router

#--- RDP
ssh -L 10116:94.247.62.24:10116 vladvons@oster.com.ua -N
#--- in another session
#vxfreerdp /v:127.0.0.1:10116 /bpp:8 /size:95% /u:snoVdalV

#--- SSH ProxMox
#ssh -J vladvons@oster.com.ua root@94.247.62.24 -p 10100
