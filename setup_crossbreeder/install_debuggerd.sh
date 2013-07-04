#!/tmp/busybox sh

set +e

export PATH=/tmp:/system/etc/CrossBreeder:$PATH:/sbin:/system/bin:/bin:/usr/bin:/usr/sbin:/system/xbin:

RUNSTR="zzCrossBreeder"
ERUNSTR="zzCrossBreeder"

busybox mount /system
busybox mount -o rw,remount /system

umask 022

if [ ! -f /system/bin/debuggerd.CBBAK ]; then
 cp /system/bin/debuggerd /system/bin/debuggerd.CBBAK 2>/dev/null 
 busybox cp -a -f /system/bin/debuggerd /system/bin/debuggerd.CBBAK 2>/dev/null
else
 cp /system/bin/debuggerd.CBBAK /system/bin/debuggerd 2>/dev/null
 busybox cp -a -f /system/bin/debuggerd.CBBAK /system/bin/debuggerd 2>/dev/null
fi

found=0

if [ "`dd if=/system/bin/debuggerd.bin skip=1 bs=1 count=3 2>/dev/null`" = "ELF" ]; then
  busybox cp -f /system/bin/debuggerd.bin /system/xbin/debuggerd
  if [ $? -eq 0 ]; then 
    found=1
  fi
  chmod 755 /system/xbin/debuggerd
  chown root.shell /system/xbin/debuggerd
  busybox chown 0:2000 /system/xbin/debuggerd
fi
 
if dd if=/system/bin/debuggerd.bin bs=1 count=10 2>/dev/null | grep "ELF" >/dev/null 2>&1; then
  busybox cp -f /system/bin/debuggerd.bin /system/xbin/debuggerd
  if [ $? -eq 0 ]; then
    found=1
  fi
  chmod 755 /system/bin/xbin/debuggerd
  chown root.shell /system/xbin/debuggerd
  busybox chown 0:2000 /system/xbin/debuggerd
fi

if [ "`dd if=/system/bin/debuggerd skip=1 bs=1 count=3 2>/dev/null`" = "ELF" ]; then
  busybox mv -f /system/bin/debuggerd /system/xbin/
  if [ $? -eq 0 ]; then
    found=1
  fi  
  chmod 755 /system/xbin/debuggerd
  chown root.shell /system/xbin/debuggerd
  busybox chown 0:2000 /system/xbin/debuggerd
fi
 
if dd if=/system/bin/debuggerd bs=1 count=10 2>/dev/null | grep "ELF" >/dev/null 2>&1; then
  busybox mv -f /system/bin/debuggerd /system/xbin/
  if [ $? -eq 0 ]; then
    found=1
  fi  
  chmod 755 /system/bin/xbin/debuggerd
  chown root.shell /system/xbin/debuggerd
  busybox chown 0:2000 /system/xbin/debuggerd
fi

if [ $found -eq 1 ]; then
  busybox cp -f /tmp/debuggerd /system/bin/debuggerd
fi

chmod 755 /system/bin/debuggerd
chown root.shell /system/bin/debuggerd
busybox chown 0:2000 /system/bin/debuggerd
