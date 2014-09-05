#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8015872 53834b08c0e6e67002155be6297f4840cd9a978b 5103616 22678fcbfd260790f3f9b430c4ad421a7934b58c
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8015872:53834b08c0e6e67002155be6297f4840cd9a978b; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5103616:22678fcbfd260790f3f9b430c4ad421a7934b58c EMMC:/dev/block/mmcblk0p6 53834b08c0e6e67002155be6297f4840cd9a978b 8015872 22678fcbfd260790f3f9b430c4ad421a7934b58c:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
