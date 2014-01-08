#!/sbin/sh
sed -i 's/#qemu.hw.mainkeys=0/qemu.hw.mainkeys=0/g' /system/build.prop
exit 0