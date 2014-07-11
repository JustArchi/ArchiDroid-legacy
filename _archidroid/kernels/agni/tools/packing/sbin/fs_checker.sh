#!/sbin/busybox sh

###### AGNi FS CHECKER v1.3 (I9300)################

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
SYSTEM_FS=""
PRELOAD_FS=""
DATA_FS=""
CACHE_FS=""
FS_CHECKER="OFF"
TMP_LOG_FILE="/agni_fs_checker.log"
BLKID_INFO="/blkid_info"
FS_CHECKER_STATUS="/fs_checker_status"

$BBOX mount -o rw,remount /

# CHECK FS_CHECKER SWITCH
$BBOX mount -t ext4,f2fs -o ro,noatime,nodiratime $SYSTEM /system
if [ -f /system/etc/init.d/S93enable_001bkagnibootfschecking_002-on ];
	then
	FS_CHECKER="ON"
	$BBOX touch /agni_fs_checker.log
	$BBOX chmod 777 /agni_fs_checker.log
	$BBOX echo " " > $TMP_LOG_FILE
	$BBOX echo " " >> $TMP_LOG_FILE
	$BBOX echo "################################################" >> $TMP_LOG_FILE
	$BBOX echo "	AGNi FS_CHECKER LOG " >> $TMP_LOG_FILE
	$BBOX echo "################################################" >> $TMP_LOG_FILE
	$BBOX echo "   DATED: `date`" >> $TMP_LOG_FILE
	$BBOX echo " " >> $TMP_LOG_FILE	
fi
$BBOX umount /system

# GATHERING PARTITION INFO
$BBOX echo "`$BBOX blkid`" > $BLKID_INFO
# /system
if [ "`$BBOX grep $SYSTEM_PARTITION $BLKID_INFO | $BBOX grep f2fs`" ];
	then
	SYSTEM_FS="F2FS"
	else
	SYSTEM_FS="EXT4"
fi
# /data
if [ "`$BBOX grep $DATA_PARTITION $BLKID_INFO | $BBOX grep f2fs`" ];
	then
	DATA_FS="F2FS"
	else
	DATA_FS="EXT4"
fi
# /cache
if [ "`$BBOX grep $CACHE_PARTITION $BLKID_INFO | $BBOX grep f2fs`" ];
	then
	CACHE_FS="F2FS"
	else
	CACHE_FS="EXT4"
fi
# /preload
if [ "`$BBOX grep $PRELOAD_PARTITION $BLKID_INFO | $BBOX grep f2fs`" ];
	then
	PRELOAD_FS="F2FS"
	else
	if [ "`$BBOX grep $PRELOAD_PARTITION $BLKID_INFO | $BBOX grep swap`" ];
		then
		PRELOAD_FS="SWAP"
		else
		PRELOAD_FS="EXT4"
	fi
fi

if [ "$FS_CHECKER" == "ON" ];
	then
	if [ "$SYSTEM_FS" == "EXT4" ];
		then
		$BBOX echo " /system EXT4 CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/e2fsck -p -f -v $SYSTEM`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$SYSTEM_FS" == "F2FS" ];
		then
		$BBOX echo " /system F2FS CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/fsck.f2fs $SYSTEM`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$DATA_FS" == "EXT4" ];
		then
		$BBOX echo " /data EXT4 CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/e2fsck -p -f -v $DATA`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$DATA_FS" == "F2FS" ];
		then
		$BBOX echo " /data F2FS CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/fsck.f2fs $DATA`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$CACHE_FS" == "EXT4" ];
		then
		$BBOX echo " /cache EXT4 CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/e2fsck -p -f -v $CACHE`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$CACHE_FS" == "F2FS" ];
		then
		$BBOX echo " /cache F2FS CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/fsck.f2fs $CACHE`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$PRELOAD_FS" == "EXT4" ];
		then
		$BBOX echo " /preload EXT4 CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/e2fsck -p -f -v $PRELOAD`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$PRELOAD_FS" == "F2FS" ];
		then
		$BBOX echo " /preload F2FS CHECKING...." >> $TMP_LOG_FILE
		$BBOX echo "`/sbin/fsck.f2fs $PRELOAD`" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
	if [ "$PRELOAD_FS" == "SWAP" ];
		then
		$BBOX echo " /preload NOT CHECKED (SWAP PARTITION)" >> $TMP_LOG_FILE
		$BBOX echo " " >> $TMP_LOG_FILE
	fi
fi

# MODIFY /fstab.smdk4x12 WITH CURRENT-STATE FILESYSTEM ENTRIES
$BBOX chmod 777 /fstab.smdk4x12
if [ "$SYSTEM_FS" == "EXT4" ];
	then
	$BBOX awk '/AGNI_SYSTEM/{print;print "/dev/block/mmcblk0p9		/system			ext4		ro,noatime		wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/system entry as EXT4 added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$SYSTEM_FS" == "F2FS" ];
	then
	$BBOX awk '/AGNI_SYSTEM/{print;print "/dev/block/mmcblk0p9		/system			f2fs		ro,noatime,background_gc=off	wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/system entry as F2FS added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$CACHE_FS" == "EXT4" ];
	then
	$BBOX awk '/AGNI_CACHE/{print;print "/dev/block/mmcblk0p8		/cache			ext4		noatime,nosuid,nodev,journal_async_commit,errors=panic		wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/cache entry as EXT4 added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$CACHE_FS" == "F2FS" ];
	then
	$BBOX awk '/AGNI_CACHE/{print;print "/dev/block/mmcblk0p8		/cache			f2fs		noatime,nosuid,nodev,background_gc=off		wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/cache entry as F2FS added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$PRELOAD_FS" == "EXT4" ];
	then
	$BBOX awk '/AGNI_PRELOAD/{print;print "/dev/block/mmcblk0p10		/preload		ext4		noatime,nosuid,nodev,journal_async_commit		wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/preload entry as EXT4 added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$PRELOAD_FS" == "F2FS" ];
	then
	$BBOX awk '/AGNI_PRELOAD/{print;print "/dev/block/mmcblk0p10		/preload		f2fs		noatime,nosuid,nodev,background_gc=off		wait";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/preload entry as F2FS added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$DATA_FS" == "EXT4" ];
	then
	$BBOX awk '/AGNI_DATA/{print;print "/dev/block/mmcblk0p12		/data			ext4		noatime,nosuid,nodev,discard,noauto_da_alloc,journal_async_commit,errors=panic		wait,check,encryptable=footer";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/data entry as EXT4 added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
if [ "$DATA_FS" == "F2FS" ];
	then
	$BBOX awk '/AGNI_DATA/{print;print "/dev/block/mmcblk0p12		/data			f2fs		noatime,nosuid,nodev,discard,background_gc=off	wait,encryptable=footer";next}1' /fstab.smdk4x12 > /fstab.smdk4x12-temp
	$BBOX mv /fstab.smdk4x12-temp /fstab.smdk4x12
	$BBOX echo "/data entry as F2FS added to /fstab.smdk4x12" >> $TMP_LOG_FILE
fi
$BBOX chmod 664 /fstab.smdk4x12

if [ "$FS_CHECKER" == "OFF" ];
	then
	$BBOX rm $TMP_LOG_FILE
fi

$BBOX rm $BLKID_INFO
$BBOX touch $FS_CHECKER_STATUS

$BBOX mount -o ro,remount /

