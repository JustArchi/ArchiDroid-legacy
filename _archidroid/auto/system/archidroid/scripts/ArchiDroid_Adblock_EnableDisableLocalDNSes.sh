#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/ADBLOCK_APPEND_LOCAL_DNSES ]; then
	mv $ADDEV/ADBLOCK_APPEND_LOCAL_DNSES $ADDEV/ADBLOCK_IGNORE_LOCAL_DNSES
	echo "Local DNSes are now ignored by Adblock"
elif [ -e $ADDEV/ADBLOCK_IGNORE_LOCAL_DNSES ]; then
	mv $ADDEV/ADBLOCK_IGNORE_LOCAL_DNSES $ADDEV/ADBLOCK_APPEND_LOCAL_DNSES
	echo "Local DNSes are now being used by Adblock"
else
	sysro
	echo "Could not find actual adblock DNSes status!"
	exit 1
fi

sysro
sh /system/etc/init.d/99ArchiDroid_Init "RELOAD" "ADBLOCK"
exit 0