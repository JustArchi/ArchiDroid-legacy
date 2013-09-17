#!/system/bin/sh

# Check if we're not being executed twice
if [ -e /system/etc/init.d/91ArchiDroid_RestoreRoot ] || [ -z `which su` ]; then
	echo "Sorry but it looks like you're already unrooted till next reboot"
	exit 1
fi

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	echo "Trying to execute this script as root... Below is the output (if no output then I failed)"
	su -c "sh $0" &
	exit 0
fi

if [ -z `which sysrw` ] || [ -z `which sysro` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

sysrw
mv /system/bin/su /system/bin/ArchiDroid_r00t
mv /system/xbin/su /system/xbin/ArchiDroid_r00t
echo "#!/system/bin/sh
touch /data/media/0/ArchiDroid/HARD_REBOOT_REQUIRED
sysrw
mv /system/bin/ArchiDroid_r00t /system/bin/su
mv /system/xbin/ArchiDroid_r00t /system/xbin/su
rm -f \$0
sysro
exit 0" > /system/etc/init.d/91ArchiDroid_RestoreRoot
chmod 755 /system/etc/init.d/91ArchiDroid_RestoreRoot
sysro
echo "Done, ArchiDroid is now fully unrooted till next reboot"
exit 0