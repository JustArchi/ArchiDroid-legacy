#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7989248 b849c006b101209e779addd224c26f09dad8a675 5087232 d202e7bb1910b99bd61ae457a809fddba5b17e04
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7989248:b849c006b101209e779addd224c26f09dad8a675; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5087232:d202e7bb1910b99bd61ae457a809fddba5b17e04 EMMC:/dev/block/mmcblk0p6 b849c006b101209e779addd224c26f09dad8a675 7989248 d202e7bb1910b99bd61ae457a809fddba5b17e04:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
