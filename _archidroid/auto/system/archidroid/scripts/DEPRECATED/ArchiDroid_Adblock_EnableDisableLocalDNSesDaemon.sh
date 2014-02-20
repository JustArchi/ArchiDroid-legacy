#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ ! -e $ADDEV/ADBLOCK_LOCAL_DNSES_ENABLED ]; then
	echo "Local DNSes are not enabled, please enable local DNSes before calling local DNSes daemon!"
	exit 1
fi

if [ -e $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_ENABLED ]; then
	mv $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_ENABLED $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_DISABLED
	echo "Local DNSes daemon is now disabled, your local DNSes won't be automatically updated"
elif [ -e $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_DISABLED ]; then
	mv $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_DISABLED $ADDEV/ADBLOCK_LOCAL_DNSES_DAEMON_ENABLED
	echo "Local DNSes daemon is now running, your local DNSes are automatically being updated"
else
	sysro
	echo "Could not find actual adblock DNSes daemon status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "ADBLOCK"
exit 0