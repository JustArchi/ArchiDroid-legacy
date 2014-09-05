#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8013824 e2795150795f3e1fe6d0815c651c6bcd7385b859 5101568 8389fbf278472cdf0b424caede6a7a5e2e31f53a
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8013824:e2795150795f3e1fe6d0815c651c6bcd7385b859; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5101568:8389fbf278472cdf0b424caede6a7a5e2e31f53a EMMC:/dev/block/mmcblk0p6 e2795150795f3e1fe6d0815c651c6bcd7385b859 8013824 8389fbf278472cdf0b424caede6a7a5e2e31f53a:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
