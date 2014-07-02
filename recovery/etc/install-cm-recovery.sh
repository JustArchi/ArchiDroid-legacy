#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 21f316625e94145988ca315298a80afdaa934bb4 5087232 adf1adb126152f65a591c002b3a3cb60e62378f8
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:21f316625e94145988ca315298a80afdaa934bb4; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:adf1adb126152f65a591c002b3a3cb60e62378f8 EMMC:/dev/block/mmcblk0p6 21f316625e94145988ca315298a80afdaa934bb4 7989248 adf1adb126152f65a591c002b3a3cb60e62378f8:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
