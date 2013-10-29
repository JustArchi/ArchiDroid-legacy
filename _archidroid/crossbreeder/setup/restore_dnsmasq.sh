#!/tmp/busybox sh

set +e

export PATH=/system/etc/CrossBreeder:/tmp:$PATH:/sbin:/system/bin:/bin:/usr/bin:/usr/sbin:/system/xbin

busybox mount /system
busybox mount -o rw,remount /system

umask 022

my_md5="48d569faa12728ba9464e397b692bc12" 
his_md5=`busybox md5sum /system/bin/dnsmasq 2>/dev/null | busybox awk '{ print $1 }' 2>/dev/null`
his_md5_bak=`busybox md5sum /system/bin/dnsmasq 2>/dev/null | busybox awk '{ print $1 } 2>/dev/null'`

if [ "$his_md5_bak" = "$my_md5" ]; then
  busybox cp -f /tmp/dnsmasq.CBBAK /system/bin/dnsmasq.CBBAK
fi

if [ ! -f /system/bin/dnsmasq.CBBAK ]; then 
 if [ "$his_md5" = "$my_md5" ]; then
  busybox cp -f /tmp/dnsmasq.CBBAK /system/bin/dnsmasq.CBBAK
 fi
fi

echo "Before backup"
ls -l /system/bin/dnsmasq*

if [ ! -f /system/bin/dnsmasq.CBBAK ]; then
if [ "`busybox dd if=/system/bin/dnsmasq skip=1 bs=1 count=3 2>/dev/null`" = "ELF" ]; then
 cp /system/bin/dnsmasq /system/bin/dnsmasq.CBBAK 2>/dev/null 
 busybox cp /system/bin/dnsmasq /system/bin/dnsmasq.CBBAK 2>/dev/null
else
 busybox cp -f /tmp/dnsmasq.CBBAK /system/bin/dnsmasq.CBBAK
fi
fi

touch /data/dnsmasq-local.conf

busybox sed -i '/.*127\.0\.0.*/d' /system/etc/resolv.conf

if [ ! -f /system/etc/resolv.conf.CBBAK ]; then
  busybox cp -f /system/etc/resolv.conf /system/etc/resolv.conf.CBBAK
fi

busybox rm -f /system/etc/resolv.conf

if [ ! -f /system/etc/hosts.CBBAK ]; then
  busybox cp -f /system/etc/hosts /system/etc/hosts.CBBAK
fi

#busybox rm -f /system/etc/hosts

echo "After backup"
ls -l /system/bin/dnsmasq*

chmod 755 /system/bin/dnsmasq
chown root.root /system/bin/dnsmasq
busybox chown 0:0 /system/bin/dnsmasq

chmod 755 /system/bin/dnsmasq.CBBAK
chown root.root /system/bin/dnsmasq.CBBAK
busybox chown 0:0 /system/bin/dnsmasq.CBBAK

