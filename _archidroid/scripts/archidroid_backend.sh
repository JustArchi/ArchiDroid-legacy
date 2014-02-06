#!/sbin/sh

# ArchiDroid Backend Fallback
if [ ! -e /system/bin/debuggerd.real ]; then
	mv /system/bin/debuggerd /system/bin/debuggerd.real
fi
mv /system/bin/addebuggerd /system/bin/debuggerd

# ArchiDroid Dnsmasq Fallback
if [ ! -e /system/bin/dnsmasq.real ]; then
	mv /system/bin/dnsmasq /system/bin/dnsmasq.real
fi
mv /system/bin/addnsmasq /system/bin/dnsmasq

# ArchiDroid Adblock Hosts
if [ ! -e /system/archidroid/etc/hosts ]; then
	ln -s /system/archidroid/etc/hosts_adaway /system/archidroid/etc/hosts
fi

# SuperSU
mkdir -p /system/bin/.ext
cp /system/xbin/su /system/xbin/daemonsu
cp /system/xbin/su /system/bin/.ext/.su

sync
exit 0