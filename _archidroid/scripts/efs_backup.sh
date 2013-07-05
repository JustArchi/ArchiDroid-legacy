#!/sbin/sh

mount /dev/block/mmcblk0p9 /system
mount /dev/block/mmcblk0p12 /data
mount /dev/block/mmcblk0p3 /efs

if [ ! -d /sdcard/efs_Backup ];then
  mkdir /sdcard/efs_Backup
  chmod 777 /sdcard/efs_Backup
fi

busybox tar zcvf /sdcard/efs_Backup/efs_$(busybox date +%d%b%Y-%H%M).tar.gz /efs

unmount /system
unmount /data
unmount /efs

exit 10

# Thanks to ::indie::