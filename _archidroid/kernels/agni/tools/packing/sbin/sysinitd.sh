#!/sbin/busybox sh

while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 1
done

# Play sound for Boeffla-Sound compatibility
/sbin/tinyplay /res/misc/silence.wav -D 0 -d 0 -p 880

## Set optimum permissions for init.d scripts
/sbin/busybox sh /sbin/sysrw
/sbin/busybox chmod -R 0777 /system/etc/init.d

## Setting profiles scripts as non-executable
/sbin/busybox chmod 0666 /system/etc/init.d/S46enable_001bkprofiles_*

/sbin/busybox sh /sbin/frandom.sh
/sbin/busybox sh /sbin/touchkey_manage.sh

if ! [ -f /system/bin/sh ];
	then
	ln -s /sbin/busybox /system/bin/sh
	chmod 777 /system/bin/sh
fi

/sbin/busybox sh /sbin/sysro

# Execute files in init.d folder
export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
/system/bin/logwrapper /sbin/busybox run-parts /system/etc/init.d
