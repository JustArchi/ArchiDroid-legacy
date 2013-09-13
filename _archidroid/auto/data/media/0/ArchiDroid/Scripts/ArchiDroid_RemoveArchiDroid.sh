#!/system/bin/sh

# Check if we're running as root
if [ `id -u | grep 'root' | wc -l` -lt 1 ]; then
	echo "Sorry but you need to execute this script as root"
	exit 2
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