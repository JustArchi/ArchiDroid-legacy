#!/system/bin/sh

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	echo "Trying to execute this script as root... Below is the output (if no output then I failed)"
	su -c "sh $0" &
	exit 0
fi

if [ -z `which fstrim` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

fstrim -v /data
fstrim -v /cache
fstrim -v /preload
fstrim -v /system
fstrim -v /efs

echo "Fstrim() of /data /cache /preload /system /efs done"
exit 0