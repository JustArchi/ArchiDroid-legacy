#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8015872 ce1939082eac2430fbf76e0c4b2769b114de7803 5103616 d3e44b62811c7699d5f6688dc0414c58849e7671
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8015872:ce1939082eac2430fbf76e0c4b2769b114de7803; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5103616:d3e44b62811c7699d5f6688dc0414c58849e7671 EMMC:/dev/block/mmcblk0p6 ce1939082eac2430fbf76e0c4b2769b114de7803 8015872 d3e44b62811c7699d5f6688dc0414c58849e7671:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
