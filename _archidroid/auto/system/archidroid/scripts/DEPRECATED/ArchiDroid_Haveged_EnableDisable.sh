#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/HAVEGED_ENABLED ]; then
	mv $ADDEV/HAVEGED_ENABLED $ADDEV/HAVEGED_DISABLED
	echo "Haveged has been disabled"
elif [ -e $ADDEV/HAVEGED_DISABLED ]; then
	mv $ADDEV/HAVEGED_DISABLED $ADDEV/HAVEGED_ENABLED
	echo "Haveged has been enabled"
else
	sysro
	echo "Could not find actual haveged status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "HAVEGED"
exit 0