#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 ef2948b24fc410525c0ee75021f0155ef329f079 5087232 a9460aa3969d3bba6af535350a360882672fc9d0
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:ef2948b24fc410525c0ee75021f0155ef329f079; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:a9460aa3969d3bba6af535350a360882672fc9d0 EMMC:/dev/block/mmcblk0p6 ef2948b24fc410525c0ee75021f0155ef329f079 7989248 a9460aa3969d3bba6af535350a360882672fc9d0:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
