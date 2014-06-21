#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8013824 c364e660ba12fcec1e779748425ee13ea5c615a1 5107712 62bd86353cd352001a9884ed210aa4924598155a
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8013824:c364e660ba12fcec1e779748425ee13ea5c615a1; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5107712:62bd86353cd352001a9884ed210aa4924598155a EMMC:/dev/block/mmcblk0p6 c364e660ba12fcec1e779748425ee13ea5c615a1 8013824 62bd86353cd352001a9884ed210aa4924598155a:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
