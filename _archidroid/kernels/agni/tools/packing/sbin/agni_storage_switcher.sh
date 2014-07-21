#!/sbin/busybox sh

## AGNi pureCM KITKAT sdcard1<-->sdcard0 switcher v1.2

#while ! /sbin/busybox pgrep sdcard ; do
#  /sbin/busybox sleep 1
#done
#if [ ! -d /mnt/shell/emulated/0 ];
#	then
#	/sbin/busybox sleep 20
#fi
#if [ ! "`/sbin/busybox mount | grep fuse | grep sdcard1`" ];
#	then
#	/sbin/busybox sleep 20
#fi

#if [ -d /mnt/shell/emulated/0 ] && [ "`/sbin/busybox mount | grep fuse | grep sdcard1`" ];
#	then
	/sbin/busybox sh /sbin/rootrw
	/system/bin/am force-stop sdcard
	/system/bin/am force-stop fuse_sdcard1
	sync
	umount /storage/sdcard1
	umount /mnt/shell/emulated
	mount -t sdcardfs -o rw,nosuid,nodev,noatime,nodiratime,uid=1023,gid=1023 /data/media/0 /storage/sdcard1
	mount -t sdcardfs -o rw,nosuid,nodev,noatime,nodiratime,uid=1023,gid=1023 /mnt/media_rw/sdcard1 /mnt/shell/emulated
	ln -s /data/media/obb /original-sdcard0-obb
	ln -s /mnt/shell/emulated /original-sdcard1-data
	ln -s /mnt/shell/emulated/0/Android/obb /new-sdcard1-obb
	export SECONDARY_STORAGE=/storage/emulated/legacy:/storage/usbdisk0
	export EXTERNAL_STORAGE=/storage/sdcard1
	rm /res/scripts/S35enable_001bkusbumsmode_001-off_default
	rm /res/scripts/S35enable_001bkusbumsmode_002-on
	/sbin/busybox sh /sbin/rootro
#fi

