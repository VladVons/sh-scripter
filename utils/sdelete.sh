File=/zero.tmp

echo "Filling free space with zeros into file $File.."
sudo dd if=/dev/zero of=/$File bs=1M status=progress || true

echo "sync changes"
sudo sync

du -BG $File

echo "remove file"
sudo rm -f $File