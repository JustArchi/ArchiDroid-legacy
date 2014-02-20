#!/system/bin/sh
# ArchiDroid Script

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/ADBLOCK_USE_ADAWAY_HOSTS ]; then
	rm -f /system/archidroid/etc/hosts
	ln -s /system/archidroid/etc/hosts_moab /system/archidroid/etc/hosts
	mv $ADDEV/ADBLOCK_USE_ADAWAY_HOSTS $ADDEV/ADBLOCK_USE_MOAB_HOSTS
	echo "Adblock now uses Mother-Of-Ad-Blocking hosts file, consuming about 25 megabytes of memory"
elif [ -e $ADDEV/ADBLOCK_USE_MOAB_HOSTS ]; then
	rm -f /system/archidroid/etc/hosts
	ln -s /system/archidroid/etc/hosts_adaway /system/archidroid/etc/hosts
	mv $ADDEV/ADBLOCK_USE_MOAB_HOSTS $ADDEV/ADBLOCK_USE_ADAWAY_HOSTS
	echo "Adblock now uses AdAway hosts file, consuming about 3 megabytes of memory"
else
	sysro
	echo "Could not find actual hosts status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "ADBLOCK"
exit 0