#!/system/bin/sh

# Check if we're not being executed twice
if [ -e /system/etc/init.d/97ArchiDroid_RestoreRoot ]; then
	echo "Sorry but it looks like you're already unrooted till next reboot"
	exit 1
fi

# Check if we're running as root
if [ `id -u | grep 'root' | wc -l` -lt 1 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 2
fi

sysrw
mv /system/xbin/su /system/xbin/ArchiDroid_r00t
echo "#!/system/bin/sh
sysrw
mv /system/xbin/ArchiDroid_r00t /system/xbin/su
rm -f $0
sysro
exit 0" > /system/etc/init.d/97ArchiDroid_RestoreRoot
chmod 755 /system/etc/init.d/97ArchiDroid_RestoreRoot
sysro
echo "Done, ArchiDroid is now fully unrooted till next reboot"
exit 0