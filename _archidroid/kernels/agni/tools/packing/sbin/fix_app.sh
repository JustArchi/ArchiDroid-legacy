#!/sbin/busybox sh

##DIRTY WORKAROUND for making AGNi Control App Usable in CM11
mount -o rw,remount /system

chmod 0775 /system/etc/init.d
chmod 0775 /system/etc/init.d/*

chmod 0775 /system/etc/init.d
chmod 0775 /system/etc/init.d/*
chmod 0666 /system/etc/init.d/*_001bkprofiles_*
mount -o ro,remount /system
