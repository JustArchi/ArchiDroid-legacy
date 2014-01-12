#!/sbin/sh

# SuperSU
mkdir /system/bin/.ext
cp /system/xbin/su /system/xbin/daemonsu
cp /system/xbin/su /system/bin/.ext/.su
touch /system/etc/.installed_su_daemon

sync
exit 0