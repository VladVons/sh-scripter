# VladVons@gmail.com


PostInstall()
{
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/xubuntu-logo 100
    update-initramfs -u
}
