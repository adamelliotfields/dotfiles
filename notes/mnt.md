# Mounting

Create `/mnt/d` if it doesn't exist:

```sh
sudo mkdir /mnt/d
```

If you need cross-platform compatibility, use exFAT. Otherwise, prefer NTFS on Windows for the `metadata` option. Use `DrvFs` in WSL:

```sh
# 777 - 22 = 755
# 755 - 111 = 644
sudo mount -t drvfs -o metadata,uid=1000,gid=1000,umask=22,fmask=111 D: /mnt/d
```

Delete `/mnt/d` after unmounting so you can eject in Windows:

```sh
sudo umount /mnt/d
sudo rm -rf /mnt/d
```
