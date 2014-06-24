#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8013824 d929b9d3a4b7c11f5f5374c618b6a100b7dc063f 5107712 996c294dd8227ec5179680e709e282057f537a9e
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8013824:d929b9d3a4b7c11f5f5374c618b6a100b7dc063f; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5107712:996c294dd8227ec5179680e709e282057f537a9e EMMC:/dev/block/mmcblk0p6 d929b9d3a4b7c11f5f5374c618b6a100b7dc063f 8013824 996c294dd8227ec5179680e709e282057f537a9e:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
