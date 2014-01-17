#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

if [ -z `which onandroid` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

onandroid -c ArchiDroidOnlineBackup -r

exit 0