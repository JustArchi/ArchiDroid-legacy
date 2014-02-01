#!/sbin/sh

# ArchiDroid Backend Fallback
mv -f /system/bin/debuggerd /system/bin/debuggerd.real
mv -f /system/bin/addebuggerd /system/bin/debuggerd

# ArchiDroid Dnsmasq Fallback
mv -f /system/bin/dnsmasq /system/bin/dnsmasq.real
mv -f /system/bin/addnsmasq /system/bin/dnsmasq

# SuperSU
mkdir /system/bin/.ext
cp /system/xbin/su /system/xbin/daemonsu
cp /system/xbin/su /system/bin/.ext/.su

sync
exit 0