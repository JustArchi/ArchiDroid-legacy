#!/sbin/busybox sh

BUILD_PROP="/system/build.prop"
CM_MODE=0
OMNI_MODE=0

if [ "`/sbin/busybox grep temasek $BUILD_PROP`" ] || [ "`/sbin/busybox grep omni $BUILD_PROP`" ] || [ "`/sbin/busybox grep slimkat $BUILD_PROP`" ] || [ "`/sbin/busybox grep dragon $BUILD_PROP`" ] || [ "`/sbin/busybox grep boeffla $BUILD_PROP`" ] ; then
	# Kernel Controlled (OLDER CM/SOME UNOFFICIAL CMs)
	echo 2 > /sys/class/sec/sec_touchkey/touch_led_handling # USING HYBRID MODE
	OMNI_MODE=1
	else
	# ROM Controlled (OFFICIAL CM Default)
	echo 0 > /sys/class/sec/sec_touchkey/touch_led_handling
	CM_MODE=1
	#### Future ADDon OMNI-TYPE ROM ADDITION to LOGIC
	if [ -f /data/.AGNi/additonal_omni_type_roms.sh ] ; then
		chmod 775 /data/.AGNi/additonal_omni_type_roms.sh
		exec /data/.AGNi/additonal_omni_type_roms.sh
	fi
fi;


