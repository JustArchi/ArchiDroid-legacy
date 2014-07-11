#!/sbin/busybox sh

while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 1
done

# Play sound for Boeffla-Sound compatibility
/sbin/tinyplay /res/misc/silence.wav -D 0 -d 0 -p 880

## Set optimum permissions for init.d scripts
/sbin/busybox sh /sbin/sysrw
/sbin/busybox sh /sbin/rootrw

/sbin/busybox chmod -R 777 /system/etc/init.d

## Setting profiles scripts as non-executable
/sbin/busybox chmod 0666 /system/etc/init.d/S46enable_001bkprofiles_*
/sbin/busybox rm /system/etc/init.d/S35enable_001bkusbumsmode_002-on

/sbin/busybox sh /sbin/frandom.sh
/sbin/busybox sh /sbin/touchkey_manage.sh

/sbin/busybox sh /sbin/sysro
/sbin/busybox sh /sbin/rootro

# AGNi sdcard1<-->sdcard0 Switcher
if [ -f /system/etc/init.d/S81enable_001bkextsd2intsd_020-on ];
	then
	/sbin/busybox sh /sbin/agni_storage_switcher.sh
fi

# Execute files in init.d folder
export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
/system/bin/logwrapper /sbin/busybox run-parts /system/etc/init.d

/sbin/busybox sh /sbin/optimise_remounts.sh

