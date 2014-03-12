# AGNi APP installer v1.1

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
