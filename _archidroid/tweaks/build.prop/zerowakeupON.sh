#!/sbin/sh
sed -i 's/pm.sleep_mode=1/pm.sleep_mode=2/g' /system/build.prop

sync
exit 0