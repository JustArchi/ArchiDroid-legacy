#!/system/bin/sh

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

if [ -z `which busybox` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

if [ ! -e /data/media/0/ArchiDroid/Backups/efs.tar.gz ]; then
	echo "Sorry but it looks like you don't have any ArchiDroid backup available. What are you trying to achieve?"
	exit 1
fi

busybox tar -zxvf /data/media/0/ArchiDroid/Backups/efs.tar.gz -C /
reboot
exit 0