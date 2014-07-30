#!/tmp/packing/sbin/busybox sh

## PSN>> AGNi user settings reseter v1.1 (Preserves preloadSWAP indicator)

if [ -f /system/etc/init.d/S72enable_001bkpreloadswap_020-on ];
	then
	/tmp/packing/sbin/busybox mkdir -p /system/etc/init.d/temp
	/tmp/packing/sbin/busybox mv /system/etc/init.d/S72enable_001bkpreloadswap_020-on /system/etc/init.d/temp
fi

/tmp/packing/sbin/busybox rm /system/etc/init.d/*001bk*

if [ -d /system/etc/init.d/temp ];
	then
	/tmp/packing/sbin/busybox mv /system/etc/init.d/temp/S72enable_001bkpreloadswap_020-on /system/etc/init.d
fi
