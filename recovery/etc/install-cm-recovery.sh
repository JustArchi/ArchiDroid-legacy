#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 13108a3b23bb4851205d3cc75f75947cfd6290cf 5087232 78a7f0de23d474cd0e9be7c72024830a58f26ab6
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:13108a3b23bb4851205d3cc75f75947cfd6290cf; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:78a7f0de23d474cd0e9be7c72024830a58f26ab6 EMMC:/dev/block/mmcblk0p6 13108a3b23bb4851205d3cc75f75947cfd6290cf 7989248 78a7f0de23d474cd0e9be7c72024830a58f26ab6:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
