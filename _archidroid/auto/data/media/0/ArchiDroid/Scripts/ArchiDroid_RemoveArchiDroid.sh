#!/system/bin/sh

# Check if we're running as root
if [ `whoami` != "root" ]; then
	echo "Sorry but you need to execute this script as root"
	echo "Trying to execute this script as root... Below is the output (if no output then I failed)"
	su -c "sh $0" &
	exit 0
fi

if [ -z `which sysrw` ] || [ -z `which sysro` ]; then
	echo "Sorry but it looks like you don't have required components. Are you using ArchiDroid?"
	exit 1
fi

sysrw
cd /system/etc/init.d
for FILE in `find . -name "*ArchiDroid*"` ; do
	rm -f $FILE
done
sysro
rm -rf /data/media/0/ArchiDroid
reboot recovery
exit 0