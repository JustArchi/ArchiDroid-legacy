#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 a41dd0c36452308d5d7e1edb3586e922d5d52c41 5087232 253b6abe799cdb135a60a824e60fe47a6c0def84
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:a41dd0c36452308d5d7e1edb3586e922d5d52c41; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:253b6abe799cdb135a60a824e60fe47a6c0def84 EMMC:/dev/block/mmcblk0p6 a41dd0c36452308d5d7e1edb3586e922d5d52c41 7989248 253b6abe799cdb135a60a824e60fe47a6c0def84:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
