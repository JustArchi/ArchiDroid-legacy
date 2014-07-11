#!/sbin/busybox sh

###### AGNi FSTAB-FS_CHECKER HANDLER v1.3 (I9300)################

BBOX="/sbin/busybox"
TMP_LOG_FILE="/agni_fs_checker.log"
FINAL_LOG_FILE="/data/.AGNi/agni_fs_checker.log"
FS_CHECKER_STATUS="/fs_checker_status"

$BBOX mount -o rw,remount /

### FS_CHECKER
if [ -f $TMP_LOG_FILE ];
	then
	$BBOX mkdir -p /data/.AGNi
	$BBOX mv -f $TMP_LOG_FILE $FINAL_LOG_FILE
	else
	$BBOX rm $FINAL_LOG_FILE
fi

$BBOX rm $FS_CHECKER_STATUS

### BATTERY_STATS_CLEANER
if [ -f /system/etc/init.d/S94enable_001bkbatterystatsclear_002-on ];
	then
	$BBOX rm /data/system/batterystats.bin
fi

$BBOX mount -o ro,remount /

