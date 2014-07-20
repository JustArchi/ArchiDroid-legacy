#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 7962624 cfb0c100699722ad76d3300d57a1789c34d249f0 5085184 f46fec6e24befb04cf3ac7172b2dff7c08af9d4d
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:7962624:cfb0c100699722ad76d3300d57a1789c34d249f0; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5085184:f46fec6e24befb04cf3ac7172b2dff7c08af9d4d EMMC:/dev/block/mmcblk0p6 cfb0c100699722ad76d3300d57a1789c34d249f0 7962624 f46fec6e24befb04cf3ac7172b2dff7c08af9d4d:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
