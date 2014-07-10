#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 a117aa1157a1507f43cd01b59c3029074463cd28 5087232 ebfda89b6a7d4595447044527b52882f872f42e9
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:a117aa1157a1507f43cd01b59c3029074463cd28; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:ebfda89b6a7d4595447044527b52882f872f42e9 EMMC:/dev/block/mmcblk0p6 a117aa1157a1507f43cd01b59c3029074463cd28 7989248 ebfda89b6a7d4595447044527b52882f872f42e9:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
