#!/system/bin/sh
if [ -f /system/etc/recovery-transform.sh ]; then
  exec sh /system/etc/recovery-transform.sh 8038400 d3efcf016fb80098e40ee6ccc8fc9f24ec44446a 5107712 bc7348ffcd3740f7e19e762b4675e5c1d211cc58
fi

if ! applypatch -c EMMC:/dev/block/mmcblk0p6:8038400:d3efcf016fb80098e40ee6ccc8fc9f24ec44446a; then
  log -t recovery "Installing new recovery image"
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/mmcblk0p5:5107712:bc7348ffcd3740f7e19e762b4675e5c1d211cc58 EMMC:/dev/block/mmcblk0p6 d3efcf016fb80098e40ee6ccc8fc9f24ec44446a 8038400 bc7348ffcd3740f7e19e762b4675e5c1d211cc58:/system/recovery-from-boot.p
else
  log -t recovery "Recovery image already installed"
fi
