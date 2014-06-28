#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8017920 867a86e1d9111aee22f214a168b05ccdd1e9576d 5107712 b9d03ee4efec743e37a1a76c09832220cc75c5e7
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8017920:867a86e1d9111aee22f214a168b05ccdd1e9576d; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5107712:b9d03ee4efec743e37a1a76c09832220cc75c5e7 EMMC:/dev/block/mmcblk0p6 867a86e1d9111aee22f214a168b05ccdd1e9576d 8017920 b9d03ee4efec743e37a1a76c09832220cc75c5e7:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
