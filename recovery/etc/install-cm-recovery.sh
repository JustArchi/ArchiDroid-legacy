#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 b60148a58d794ef1796a15cf0a44e7631c1c93dd 5087232 9c18c371a2eaa4a6ee9dfb6c725408760e2e7643
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:b60148a58d794ef1796a15cf0a44e7631c1c93dd; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:9c18c371a2eaa4a6ee9dfb6c725408760e2e7643 EMMC:/dev/block/mmcblk0p6 b60148a58d794ef1796a15cf0a44e7631c1c93dd 7989248 9c18c371a2eaa4a6ee9dfb6c725408760e2e7643:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
