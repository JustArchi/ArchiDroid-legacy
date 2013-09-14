#!/system/bin/sh

# Check if we're running as root
if [ `id -u | grep 'root' | wc -l` -lt 1 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

if [ -z `which fstrim` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

#fstrim -v /data
exit 0