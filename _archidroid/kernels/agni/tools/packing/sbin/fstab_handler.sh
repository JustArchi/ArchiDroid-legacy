#!/sbin/sh

BBOX="/sbin/busybox"
DATA="/dev/block/mmcblk0p12"

$BBOX mount -o rw,remount /

if [ "`grep mmcblk0p12 /proc/mounts | grep f2fs`" ];
	then
	$BBOX mv -f /res/etc/fstab.smdk4x12.f2fs /fstab.smdk4x12
	else
	$BBOX mv -f /res/etc/fstab.smdk4x12.ext4 /fstab.smdk4x12
fi

$BBOX mount -o ro,remount /
