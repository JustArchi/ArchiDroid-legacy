#!/sbin/sh

AD="/data/media/0/ArchiDroid"
touch /data/ARCHIDROID_DONT_REMOVE_ME

if [ ! -d $AD ]; then
	mkdir -p $AD
fi

rm -f $AD/INSTALL
rm -f $AD/UPDATE
rm -f $AD/FORCE

sync
exit 0
