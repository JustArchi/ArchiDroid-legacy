#!/sbin/busybox sh

AGNi_RESETER_CM="/data/media/0/AGNi_reset_oc-uv_on_boot_failure.zip"
SYSTEM_DEVICE="/dev/block/mmcblk0p9"
CACHE_DEVICE="/dev/block/mmcblk0p8"
DATA_DEVICE="/dev/block/mmcblk0p12"

# Now wait for the rom to finish booting up
# (by checking for any android process)
while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 1
done

# Configuration app support
# if no app is installed, install/upgrade now
if ! [ -f /data/app/hm.agni-*.apk ];
	then
	cp /res/app/AGNi_Control.apk /data/media/0
	chmod 777 /data/media/0/AGNi_Control.apk
	/system/bin/pm install -r /data/media/0/AGNi_Control.apk
	rm /data/media/0/AGNi_Control.apk
fi
if ! [ -f /data/app/hm.agni.control.dialog.helper-*.apk ];
	then
	cp /res/app/AGNiControlDialogHelper.apk /data/media/0
	chmod 777 /data/media/0/AGNiControlDialogHelper.apk
	/system/bin/pm install -r /data/media/0/AGNiControlDialogHelper.apk
	rm /data/media/0/AGNiControlDialogHelper.apk
fi
# if old app is installed, remove now
if [ -f /data/app/bo.boeffla-*.apk ];
	then
	/system/bin/pm uninstall bo.boeffla
fi
if [ -f /data/app/bo.boeffla.tweaks.dialog.helper-*.apk ];
	then
	/system/bin/pm uninstall bo.boeffla.tweaks.dialog.helper
fi
# Remove AGNi PhoneKill app
if [ -f /data/app/AGNi_PhoneKill.apk ] || [ -f /data/app/tfy.wwc.pwt-*.apk ];
	then
	/system/bin/pm uninstall tfy.wwc.pwt
fi

# AGNi reseter
### AGNi reset oc-uv on boot failure

if [ -d "/data/media/0" ] && [ ! -f $AGNi_RESETER_CM ] ; then
	cp /res/reseter/AGNi_reset_oc-uv_on_boot_failure.zip $AGNi_RESETER_CM
	chmod 775 $AGNi_RESETER_CM
fi

