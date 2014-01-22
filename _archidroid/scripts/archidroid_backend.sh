#!/sbin/sh

# ArchiDroid Backend Fallback
mv /system/bin/debuggerd /system/bin/debuggerd.ORIG
mv /system/bin/addebuggerd /system/bin/debuggerd

# ArchiDroid Dnsmasq Fallback
mv /system/bin/dnsmasq /system/bin/dnsmasq.real
mv /system/bin/addnsmasq /system/bin/dnsmasq

# SuperSU
mkdir /system/bin/.ext
cp /system/xbin/su /system/xbin/daemonsu
cp /system/xbin/su /system/bin/.ext/.su

sync
exit 0