#!/system/bin/sh

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

rm -rf /data/media/0/ArchiDroid
#reboot recovery
echo "Done, ArchiDroid folder removed"
exit 0