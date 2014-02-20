#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/ADBLOCK_DONT_FORCE_LOCAL_DNSES ]; then
	rm -f $ADDEV/ADBLOCK_LOCAL_DNSES_DISABLED
	touch $ADDEV/ADBLOCK_LOCAL_DNSES_ENABLED
	mv $ADDEV/ADBLOCK_DONT_FORCE_LOCAL_DNSES $ADDEV/ADBLOCK_FORCE_LOCAL_DNSES
	echo "Adblock now uses ONLY local DNSes"
elif [ -e $ADDEV/ADBLOCK_FORCE_LOCAL_DNSES ]; then
	mv $ADDEV/ADBLOCK_FORCE_LOCAL_DNSES $ADDEV/ADBLOCK_DONT_FORCE_LOCAL_DNSES
	echo "Adblock now uses global DNSes (and local ones if they're enabled)"
else
	sysro
	echo "Could not find actual adblock status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "ADBLOCK"
exit 0