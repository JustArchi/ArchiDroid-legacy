#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 4fd21fd4cc6fd7d637a77d7651a8ed0590c47e85 5087232 c3caf4762f30fa5f467ddac374e980775162bd98
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:4fd21fd4cc6fd7d637a77d7651a8ed0590c47e85; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:c3caf4762f30fa5f467ddac374e980775162bd98 EMMC:/dev/block/mmcblk0p6 4fd21fd4cc6fd7d637a77d7651a8ed0590c47e85 7989248 c3caf4762f30fa5f467ddac374e980775162bd98:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
