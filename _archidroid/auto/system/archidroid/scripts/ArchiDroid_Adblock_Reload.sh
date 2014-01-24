#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"

if [ -e $ADDEV/ADBLOCK_ENABLED ]; then
	echo "Adblock has been reloaded"
else
	echo "Adblock is disabled, please enable it before reloading!"
	exit 1
fi

sh /system/etc/init.d/99ArchiDroid_Init "RELOAD" "ADBLOCK"
ndc resolver flushdefaultif >/dev/null # Flush DNS Cache
exit 0