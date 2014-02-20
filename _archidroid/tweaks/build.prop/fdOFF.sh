#!/sbin/sh
sed -i 's/#ro.ril.fast.dormancy.rule=0/ro.ril.fast.dormancy.rule=0/g' /system/build.prop

sync
exit 0