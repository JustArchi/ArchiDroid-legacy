#!/system/bin/sh

AD="/data/media/0/ArchiDroid"
mnt=$AD/debian

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

# Check if we're not deleting content from mounted debian
if [ -e $mnt/proc/uptime ] || [ -e $mnt/dev/urandom ] || [ -e $mnt/sys/kernel ]; then
	echo "WARNING! You just tried to delete ArchiDroid with running debian, use \"adlinux unmount\" firstly!"
	exit 1
fi

rm -rf $AD
#reboot recovery
echo "Done, ArchiDroid folder removed"
exit 0