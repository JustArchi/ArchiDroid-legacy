#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 c531d46eece03a8a8f74c1605302a8f9ab4bf147 5087232 1f6faa4600d7a975d82f9b3af753871559318778
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:c531d46eece03a8a8f74c1605302a8f9ab4bf147; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:1f6faa4600d7a975d82f9b3af753871559318778 EMMC:/dev/block/mmcblk0p6 c531d46eece03a8a8f74c1605302a8f9ab4bf147 7989248 1f6faa4600d7a975d82f9b3af753871559318778:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
