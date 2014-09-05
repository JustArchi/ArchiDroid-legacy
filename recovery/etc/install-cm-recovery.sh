#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8015872 4a840f57f9d40faf05bc8a46230b4aefe7d01aea 5103616 6c69d45c48961a2961cdbf5882e7b484741f6e94
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8015872:4a840f57f9d40faf05bc8a46230b4aefe7d01aea; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5103616:6c69d45c48961a2961cdbf5882e7b484741f6e94 EMMC:/dev/block/mmcblk0p6 4a840f57f9d40faf05bc8a46230b4aefe7d01aea 8015872 6c69d45c48961a2961cdbf5882e7b484741f6e94:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
