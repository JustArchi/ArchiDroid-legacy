#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 084ebfc457bdf56b3455fb783146571cedd184b6 5087232 94079f123e939d2da6a43982c9b57d3f1c27b04d
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:084ebfc457bdf56b3455fb783146571cedd184b6; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:94079f123e939d2da6a43982c9b57d3f1c27b04d EMMC:/dev/block/mmcblk0p6 084ebfc457bdf56b3455fb783146571cedd184b6 7989248 94079f123e939d2da6a43982c9b57d3f1c27b04d:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
