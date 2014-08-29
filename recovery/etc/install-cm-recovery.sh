#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8013824 db6410345ce8d5844eabacb8320b1b7a2e38de90 5101568 12d2453311b9f1219bceaa8e93c6f655d5b6a0eb
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8013824:db6410345ce8d5844eabacb8320b1b7a2e38de90; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5101568:12d2453311b9f1219bceaa8e93c6f655d5b6a0eb EMMC:/dev/block/mmcblk0p6 db6410345ce8d5844eabacb8320b1b7a2e38de90 8013824 12d2453311b9f1219bceaa8e93c6f655d5b6a0eb:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
