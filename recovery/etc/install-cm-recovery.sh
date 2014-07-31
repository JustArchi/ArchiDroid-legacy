#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 07ad9f03653940ae122c0456f6f2d84032e4a031 5087232 f037493846173af08aa784dcf0cbabc6b8c560ca
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:07ad9f03653940ae122c0456f6f2d84032e4a031; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:f037493846173af08aa784dcf0cbabc6b8c560ca EMMC:/dev/block/mmcblk0p6 07ad9f03653940ae122c0456f6f2d84032e4a031 7989248 f037493846173af08aa784dcf0cbabc6b8c560ca:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
