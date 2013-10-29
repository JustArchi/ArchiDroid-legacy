#!/system/bin/sh
# init.d support
run-parts /system/etc/init.d/
/system/etc/CrossBreeder/busybox start-stop-daemon -o -S -b -x /system/etc/CrossBreeder/zzCrossBreeder &
