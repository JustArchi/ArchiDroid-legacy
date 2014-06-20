#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7997440 da567f49ec9576ad1032d1c59fbf3700a671ff25 5099520 c229f287db894f9b0f344de67b24bf296a6340ed
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7997440:da567f49ec9576ad1032d1c59fbf3700a671ff25; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5099520:c229f287db894f9b0f344de67b24bf296a6340ed EMMC:/dev/block/mmcblk0p6 da567f49ec9576ad1032d1c59fbf3700a671ff25 7997440 c229f287db894f9b0f344de67b24bf296a6340ed:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
