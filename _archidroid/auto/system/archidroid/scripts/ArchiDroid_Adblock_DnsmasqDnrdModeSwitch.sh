#!/system/bin/sh

# Check if we're running as root
if [ `whoami 2>&1 | grep -i "root" | wc -l` -eq 0 ] && [ `whoami 2>&1 | grep -i "uid 0" | wc -l` -eq 0 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 1
fi

ADDEV="/system/archidroid/dev"
sysrw

if [ -e $ADDEV/ADBLOCK_USE_DNSMASQ ]; then
	mv $ADDEV/ADBLOCK_USE_DNSMASQ $ADDEV/ADBLOCK_USE_DNRD
	echo "Dnrd adblock mode has been enabled"
elif [ -e $ADDEV/ADBLOCK_USE_DNRD ]; then
	mv $ADDEV/ADBLOCK_USE_DNRD $ADDEV/ADBLOCK_USE_DNSMASQ
	echo "Dnsmasq adblock mode has been enabled"
else
	sysro
	echo "Could not find actual adblock mode status!"
	exit 1
fi

sysro
ARCHIDROID_INIT "RELOAD" "ADBLOCK"
exit 0