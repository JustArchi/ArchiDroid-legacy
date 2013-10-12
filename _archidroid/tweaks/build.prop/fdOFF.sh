#!/sbin/sh
sed -i 's/#ro.ril.fast.dormancy.rule=0/ro.ril.fast.dormancy.rule=0/g' /system/build.prop
sed -i 's/#ro.config.hw_fast_dormancy=0/ro.config.hw_fast_dormancy=0/g' /system/build.prop
exit 0