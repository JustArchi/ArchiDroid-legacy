#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8013824 162597be327b482ba2f12679376bfe6695cb335a 5107712 ee1ed45a502f66773a352bdb17d0f60c1ff7a533
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8013824:162597be327b482ba2f12679376bfe6695cb335a; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5107712:ee1ed45a502f66773a352bdb17d0f60c1ff7a533 EMMC:/dev/block/mmcblk0p6 162597be327b482ba2f12679376bfe6695cb335a 8013824 ee1ed45a502f66773a352bdb17d0f60c1ff7a533:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
