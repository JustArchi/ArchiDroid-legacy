#!/sbin/sh

###### AGNi FSTAB-FS_CHECKER HANDLER v1.1 (I9300)################

BBOX="/sbin/busybox"
TMP_LOG_FILE="/agni_fs_checker.log"
FINAL_LOG_FILE="/data/.AGNi/agni_fs_checker.log"
DATA_F2FS_INDICATOR="/data_is_f2fs"
FS_CHECKER_STATUS="/fs_checker_status"

$BBOX mount -o rw,remount /

if [ -f $DATA_F2FS_INDICATOR ];
	then
	$BBOX mv -f /res/etc/fstab.smdk4x12.f2fs /fstab.smdk4x12.additional
	chmod 644 /fstab.smdk4x12.additional
	rm $DATA_F2FS_INDICATOR
	else
	$BBOX mv -f /res/etc/fstab.smdk4x12.ext4 /fstab.smdk4x12.additional
	chmod 644 /fstab.smdk4x12.additional
fi


### FS_CHECKER
if [ -f $TMP_LOG_FILE ];
	then
	$BBOX mkdir -p /data/.AGNi
	$BBOX mv -f $TMP_LOG_FILE $FINAL_LOG_FILE
	$BBOX rm $FS_CHECKER_STATUS
	else
	$BBOX rm $FINAL_LOG_FILE
	$BBOX rm $FINAL_LOG_FILE
	$BBOX rm $FS_CHECKER_STATUS
fi

### BATTERY_STATS_CLEANER
if [ -f /system/etc/init.d/S94enable_001bkbatterystatsclear_002-on ];
	then
	$BBOX rm /data/system/batterystats.bin
fi
######

$BBOX mount -o ro,remount /

