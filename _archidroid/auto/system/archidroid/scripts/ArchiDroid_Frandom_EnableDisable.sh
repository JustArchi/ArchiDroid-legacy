#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/FRANDOM_ENABLED ]; then
	mv $ADDEV/FRANDOM_ENABLED $ADDEV/FRANDOM_DISABLED
	echo "Frandom has been disabled"
elif [ -e $ADDEV/FRANDOM_DISABLED ]; then
	mv $ADDEV/FRANDOM_DISABLED $ADDEV/FRANDOM_ENABLED
	echo "Frandom has been enabled"
else
	sysro
	echo "Could not find actual frandom status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "FRANDOM"
exit 0