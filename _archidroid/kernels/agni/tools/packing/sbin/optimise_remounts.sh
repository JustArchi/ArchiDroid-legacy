#!/sbin/busybox sh

###### AGNi FS OPTIMAL-REMOUNTS v1.0 (I9300)#######

SYSTEM_PARTITION="mmcblk0p9"
DATA_PARTITION="mmcblk0p12"
CACHE_PARTITION="mmcblk0p8"
PRELOAD_PARTITION="mmcblk0p10"

SYSTEM="/dev/block/$SYSTEM_PARTITION"
DATA="/dev/block/$DATA_PARTITION"
CACHE="/dev/block/$CACHE_PARTITION"
PRELOAD="/dev/block/$PRELOAD_PARTITION"

###################################################

BBOX="/sbin/busybox"
PARTITION_INFO="/partition_info"

sleep 60

/sbin/busybox sh /sbin/rootrw

$BBOX echo "`$BBOX cat /proc/mounts`" > $PARTITION_INFO

# /system
if [ "`$BBOX grep $SYSTEM_PARTITION $PARTITION_INFO | $BBOX grep ext4`" ];
	then
	$BBOX mount -o ro,noatime,nodiratime,remount /system
	else
	$BBOX mount -o ro,noatime,nodiratime,background_gc=off,inline_xattr,active_logs=2,remount /system
fi

sleep 2

# /cache
if [ "`$BBOX grep $CACHE_PARTITION $PARTITION_INFO | $BBOX grep ext4`" ];
	then
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,remount /cache
	else
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,background_gc=off,inline_xattr,active_logs=2,remount /cache
fi

sleep 2

# /preload
if [ "`$BBOX grep $PRELOAD_PARTITION $PARTITION_INFO | $BBOX grep ext4`" ];
	then
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,remount /preload
fi
if [ "`$BBOX grep $PRELOAD_PARTITION $PARTITION_INFO | $BBOX grep f2fs`" ];
	then
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,background_gc=off,inline_xattr,active_logs=2,remount /preload
fi

sleep 2

# /data
if [ "`$BBOX grep $DATA_PARTITION $PARTITION_INFO | $BBOX grep ext4`" ];
	then
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,remount /data
	else
	$BBOX mount -o noatime,nodiratime,nosuid,nodev,discard,background_gc=off,inline_xattr,active_logs=2,remount /data
fi

sleep 2

$BBOX rm $PARTITION_INFO

/sbin/busybox sh /sbin/rootro

