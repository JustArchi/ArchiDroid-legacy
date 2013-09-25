#!/system/bin/sh

# Check if we're not being executed twice
if [ -e /system/etc/init.d/91ArchiDroid_RestoreRoot ] || [ -z `which su` ]; then
	echo "Sorry but it looks like you're already unrooted till next reboot"
	exit 1
fi

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

if [ -z `which onandroid` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

onandroid -c ArchiDroidOnlineBackup -r

exit 0