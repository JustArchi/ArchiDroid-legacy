#!/system/bin/sh
# ArchiDroid Script

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/HOSTS_LOCKED ]; then
	chattr -i /system/etc/hosts
	mv $ADDEV/HOSTS_LOCKED $ADDEV/HOSTS_UNLOCKED
	echo "Hosts file has been unlocked"
	echo "WARNING! YOU SHOULD NOT MODIFY HOSTS FILE UNTIL ABSOLUTELY NECESSARY"
elif [ -e $ADDEV/HOSTS_UNLOCKED ]; then
	chattr +i /system/etc/hosts
	mv $ADDEV/HOSTS_UNLOCKED $ADDEV/HOSTS_LOCKED
	echo "Hosts file has been locked"
else
	sysro
	echo "Could not find actual hosts status!"
	exit 1
fi

sysro
exit 0